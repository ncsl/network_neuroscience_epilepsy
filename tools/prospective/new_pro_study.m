electrode_pcspace_temporal;

pro_p_id = {'PY15N004'};

ranks = cell(length(pro_p_id), 1);
f_vectors = cell(length(pro_p_id), 1);

freqband = {'band', 'gamma'};                                              %frequecny band for cross power.
fsv_path  = '/Users/bnorton/dev/eztrack/tools/output/fsv';
f = load('/Users/bnorton/dev/eztrack/tools/data/infolabels.mat');
f2 = load('/Users/bnorton/dev/eztrack/tools/data/infoevents.mat');

count = 1;
for n = find(ismember({f2.events(1:end).subject}, pro_p_id))

    f1 =load(fullfile(fsv_path, sprintf('fsv_pwr%s', pro_p_id{count})));
    
    for k = 1:f2.events(n).nevents
        
        dur = f2.events(n).start_marks(k):f2.events(n).end_marks(k);                           %Seizure activity duration
        dur1 = f2.events(n).start_marks(k)-pre:f2.events(n).start_marks(k)-1;                  %Pre-Seizure activity duration
        dur2 = f2.events(n).end_marks(k)+1:f2.events(n).end_marks(k)+post;                     %Post-Seizure activity duration
        
        %setting the flag
        if length(dur) < max_dur
            dur_flag = 1;
            interval = linspace(1, length(dur), max_dur);
        else
            dur_flag = 0;
        end
        
        %Extracting the eigen centrality from file and converting to
        %normalized ranks
        cent = eval(sprintf('f1.snap%d_%s', k, freqband{2}));
        cent = abs(cent);
        cent(cent < 1*10^-10) = 0;
        rankcent = ranking(cent(:, dur), 'ascend'); %./f2.ttl_electrodes;
        flank1 = ranking(cent(:, dur1), 'ascend'); %./f2.ttl_electrodes;
        flank2 = ranking(cent(:, dur2), 'ascend'); %./f2.ttl_electrodes;
        
        clear cent
        
        %checking for any illegal entries in the electrode rankcentrality
        %matrix
        if ~(isempty(find(rankcent > f2.events(n).ttl_electrodes, 1))...
                || isempty(find(flank1 > f2.events(n).ttl_electrodes, 1))...
                || isempty(find(flank2 > f2.events(n).ttl_electrodes, 1))...
                || isempty(find(rankcent < 1, 1))...
                || isempty(find(flank1 < 1, 1))...
                || isempty(find(flank2 < 1, 1)))
            error('Error in rank centrality: Illegal entries in the matrix');
        end
        
        
        %Normalization in length (#time points)
        if dur_flag
            %rankcent = spline(1:length(dur), rankcent, interval);
            rankcent = interp1(1:length(dur), rankcent', interval, 'linear')';
        end
        
        
        if ~(isempty(find(rankcent > f2.events(n).ttl_electrodes, 1))...
                || isempty(find(rankcent < 1, 1)))
            error('Error in rankcentrality interpolation: Illegal matrix entries');
        end
        
        %concatenating pre and post seizure activity to define the signal
        %of interest
        rankcent = cat(2, flank1, rankcent, flank2);
        
        %Smoothing the rank signal with a sliding window of size 21
        for etd = 1:f2.events(n).ttl_electrodes
            rankcent(etd,:) = smooth(rankcent(etd,:), window, 'moving');
        end
        
        %Normalizing in y-axis
        rankcent = rankcent./f2.events(n).ttl_electrodes;
        
        %Normalizing the area to 1 (defining a pdf)
        ci = cumtrapz(rankcent, 2);
        for i = 1:size(rankcent, 1)
            rankcent(i, :) = rankcent(i, :)./ci(i, end);
            ci(i, :) = ci(i, :)./ci(i, end);
        end
        
        if ~(isempty(find(ci(:, end) ~= 1, 1)))
            error('Error in area normalization: Illegal matrix entries');
        end
        
        %Extracting the variables for CDF (10 dimensional feature vectors)
        I = zeros(f2.events(n).ttl_electrodes, length_cdf);
        for i = 1:f2.events(n).ttl_electrodes
            for j = 1:length_cdf
                I(i,j) = find(ci(i, :) <= cdf(j), 1, 'last');
            end
        end
       
       ranks{1} = cat(1, ranks{1}, rankcent);
       f_vectors{1} = cat(1, f_vectors{1}, I);
        
        clear rankcent
    end
    
    count = count + 1;
end

avg = mean(X);

sr = points.SR.all_PC;
snr = points.SNR.all_PC;
fr = points.FR.all_PC;
fnr = points.FNR.all_PC;
all = [sr; snr; fr; fnr];

cov_mat = cov(all);

mu = [-100, -100];
x1 = -400:mu(1); x2 = mu(1):400;
y1 = -200:mu(2); y2 = mu(2):200;

[X1, Y1] = meshgrid(x1,y1); tmp1 = [X1(:) Y1(:)]; mf1 = 2e-2;
[X2, Y2] = meshgrid(x2,y1); tmp2 = [X2(:) Y2(:)]; mf2 = 5e-2;
[X3, Y3] = meshgrid(x2,y2); tmp3 = [X3(:) Y3(:)]; mf3 = 20e-2;
[X4, Y4] = meshgrid(x1,y2); tmp4 = [X4(:) Y4(:)]; mf4 = 2e-4;

%% Function 1 for SR
cov_mat_inv1 = cov_mat^-1;
Z1 = zeros(size(tmp1,1),1);
for i = 1:length(Z1)
    Z1(i) = exp(-mf1*(tmp1(i,:) - mu)*cov_mat_inv1*(tmp1(i,:) - mu)');
end


%% Function 2 for FR
cov_mat_inv2 = cov_mat_inv1;
cov_mat_inv2(2,2) = mf1*cov_mat_inv2(2,2)/mf2;
cov_mat_inv2(1,1) = 0.2*cov_mat_inv2(1,1);
Z2 = zeros(size(tmp2,1),1);
for i = 1:length(Z2)
    Z2(i) = exp(-mf2*(tmp2(i,:) - mu)*cov_mat_inv2*(tmp2(i,:) - mu)');
end


%% Function 3 for SNR

cov_mat_inv3 = cov_mat_inv2;
cov_mat_inv3(1,1) = mf2*cov_mat_inv3(1,1)/mf3;
cov_mat_inv3(2,2) = 8e0*cov_mat_inv3(2,2);
Z3 = zeros(size(tmp3,1),1);
for i = 1:length(Z3)
    Z3(i) = exp(-mf3*(tmp3(i,:) - mu)*cov_mat_inv3*(tmp3(i,:) - mu)');
end


%% Function 4 FNR
cov_mat_inv4 = cov_mat_inv3;
cov_mat_inv4(1,1) = mf1*cov_mat_inv1(1,1)/mf4;
cov_mat_inv4(2,2) = mf3*cov_mat_inv3(2,2)/mf4;
Z4 = zeros(size(tmp4,1),1);
for i = 1:length(Z4)
    Z4(i) = exp(-mf4*(tmp4(i,:) - mu)*cov_mat_inv4*(tmp4(i,:) - mu)');
end

Z = [Z1; Z2;Z3;Z4];
num_clrs_hm = 20;
clr_ind = linspace(min(Z), max(Z), num_clrs_hm+1);

%% Classification

output_filename = sprintf('/Users/bnorton/dev/eztrack/tools/output/heatmap/propat_testing_%s', date);
if exist(sprintf('%s.mat', output_filename), 'file')
    delete(sprintf('%s.mat', output_filename));
end


count = 1;
for n = find(ismember({f2.events(1:end).subject}, pro_p_id))
    tmp = f_vectors{count} - repmat(avg, [size(f_vectors{count}, 1), 1]);
    tmp = tmp*a(:, [1 2]);

    eval([sprintf('%s', pro_p_id{count}), '=struct([]);']);
    
    e_count = 0;
    E_gauss = zeros(f2.events(n).ttl_electrodes, f2.events(n).nevents);

    for k = 1:f2.events(n).nevents
        tmp1 = tmp((e_count+1):(e_count + f2.events(n).ttl_electrodes), :);
        
        sr_mu = tmp1(:,1) <=  mu(1) & tmp1(:,2) <= mu(2);
        mu1 = repmat(mu, size(tmp1(sr_mu,:),1),1);
        E_gauss(sr_mu, k) = diag(exp(-mf1*(tmp1(sr_mu,:) - mu1)*...
            cov_mat_inv1*(tmp1(sr_mu,:) - mu1)'));
        
        fr_mu = tmp1(:,1) >=  mu(1) & tmp1(:,2) <= mu(2);
        mu2 = repmat(mu, size(tmp1(fr_mu,:),1),1);
        E_gauss(fr_mu, k) = diag(exp(-mf2*(tmp1(fr_mu,:) - mu2)*...
            cov_mat_inv2*(tmp1(fr_mu,:) - mu2)'));
        
        snr_mu = tmp1(:,1) >=  mu(1) & tmp1(:,2) >= mu(2);
        mu3 = repmat(mu, size(tmp1(snr_mu,:),1),1);
        E_gauss(snr_mu, k) = diag(exp(-mf3*(tmp1(snr_mu,:) - mu3)*...
            cov_mat_inv3*(tmp1(snr_mu,:) - mu3)'));
        
        fnr_mu = tmp1(:,1) <=  mu(1) & tmp1(:,2) >= mu(2);
        mu4 = repmat(mu, size(tmp1(fnr_mu,:),1),1);
        E_gauss(fnr_mu, k) = diag(exp(-mf4*(tmp1(fnr_mu,:) - mu4)*...
            cov_mat_inv4*(tmp1(fnr_mu,:) - mu4)'));
        e_count = e_count + f2.events(n).ttl_electrodes;
    end
    
    E_Weights = sum(E_gauss,2)/f2.events(n).nevents;

    tmp2 = zeros(f2.events(n).ttl_electrodes, 1);
    for i = 1:num_clrs_hm
        tmp3 = (E_Weights < clr_ind(i+1)) & ...
            (E_Weights >= clr_ind(i));
        tmp2(tmp3) = (num_clrs_hm - i) + 1;
    end
    tmp2(E_Weights == clr_ind(end)) = 1; %#ok<NASGU>

    [~, ind] = sort(E_Weights, 'descend');

    for k = 1:f2.events(n).nevents
        eval([sprintf('%s(1).E_gauss%d', pro_p_id{count}, k), '= E_gauss(ind, k);']);
    end

    eval([sprintf('%s(1).E_Weights', pro_p_id{count}), '= E_Weights(ind);']);
    eval([sprintf('%s(1).E_HeatCodes', pro_p_id{count}), '= tmp2(ind);']);
    eval([sprintf('%s(1).E_labels', pro_p_id{count}), '= f.labels(n).values(ind).'';']);
    
    clear tmp tmp2 tmp3
    
    if ~exist(sprintf('%s.mat', output_filename), 'file')
        save(sprintf('%s.mat', output_filename), sprintf('%s', pro_p_id{count}));
    else
        save(sprintf('%s.mat', output_filename), sprintf('%s', pro_p_id{count}), '-append')
    end
    
    count = count + 1;
end

display('done');