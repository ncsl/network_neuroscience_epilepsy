
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% m-file: electrode_PCspace
%
%Description: This file groups all electrodes' normalized rank signals and
%             perfomrs PCA using the measure CDF for feature vectors and
%             plots 2D PC Space.
%
%Input:       No input during execution and run time, everything is hard
%             coded. Though one can set the flag for uncentered or centered
%             PCA.
%
%Output:      No output. The fucntion might be called by another fucntion.
%
%Author:      Bhaskar Chennuri
%Version:     2.0
%Date:        01/14/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except pca_cent_flag
close all

%% Variable initialization
p_id = {'PY04N007', 'PY04N012', 'PY04N013', 'PY04N015',...
        'PY05N005', 'PY11N003', 'PY11N006',...
        'PY12N005', 'PY12N010', 'PY12N012',...
        'PY13N003', 'PY13N011', 'PY14N004', 'PY14N005'};

%patient number/id in successful cases
succ_p_id = {'PY04N013', 'PY11N006', 'PY12N005', 'PY12N010',...
             'PY13N003', 'PY13N011', 'PY14N004', 'PY14N005'};

%patient number/id in failed cases
fail_p_id = {'PY04N007', 'PY04N012', 'PY04N015',  'PY05N005', 'PY11N003', 'PY12N012'};

pre = 60;                                                                  %window (in s) before onset of a seizure
post = 60;                                                                 %window (in s) after end of a seizure

freqband = {'band', 'gamma'};                                              %frequecny band for cross power

if strcmp(freqband,'beta')                                                 %gamma for every hopkins patient by default
    band = '13-25';
elseif strcmp(freqband,'gamma')
    band = '62-100';
end

window = 21;

fsv_path  = '/Users/bnorton/dev/eztrack/tools/output/fsv';
info_path = '/Users/bnorton/dev/eztrack/tools/data';
event_info = load(fullfile(info_path, 'infoevents'));

tmp = struct('rank',[], 'cdfs', [], 'all_PC', []);
points = struct('SR', tmp, 'SNR', tmp, 'FR', tmp, 'FNR', tmp);
clear tmp

points.f_vectors = cell(length(p_id), 1);                                  %Unsorted feature vectors

cdf = 0.1:0.1:1;                                                           %Domain of CDF
length_cdf = length(cdf);

max_dur = 0;                                                               %Maximum seizure duration in a given set
%of seizures used for nomalization
dur_flag = 0;                                                              %flag for normaliztion in time
count = 0;

if ~exist('pca_cent_flag', 'var')
    pca_cent_flag = true;                                                  %flag for centering in PCA:
end                                                                        %true when centered, false when not.

%%

%Find the maximum seizure duration in a given set for normalization in time
% These correspond to labels(n).subject
ids = [1,3,4,5,7,8,10,11,13,14,16,19,20,21];
for n = ids                           
    for k = 1:event_info.events(n).nevents
        seiz_dur = (event_info.events(n).end_marks(k) - event_info.events(n).start_marks(k)) + 1;
        
        if max_dur < seiz_dur
            max_dur = seiz_dur;
        end
        
    end
    clear seiz_dur
end

%% Main loop

for n = ids
    
    display(sprintf('here is %s', p_id{n}));
    %%%For hopkins' patients data
    
    %load the file containing information about eigenvalues from crosspowers
    
    %loads the file containing information about seizure times and resected electrodes
    f1 = load(fullfile(fsv_path, sprintf('fsv_pwr%s', p_id{n}))); %#ok<NASGU>
    
    %Extracting non resected electrodes into a seperate array
    NRR_electrodes = setdiff(1:event_info.events(n).ttl_electrodes, event_info.events(n).RR_electrodes);
    
    count = count + event_info.events(n).nevents*event_info.events(n).ttl_electrodes;
    
    for k = 1:event_info.events(n).nevents
        
        dur = event_info.events(n).start_marks(k):event_info.events(n).end_marks(k);                           %Seizure activity duration
        dur1 = event_info.events(n).start_marks(k)-pre:event_info.events(n).start_marks(k)-1;                  %Pre-Seizure activity duration
        dur2 = event_info.events(n).end_marks(k)+1:event_info.events(n).end_marks(k)+post;                     %Post-Seizure activity duration
        
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
        if ~(isempty(find(rankcent > event_info.events(n).ttl_electrodes, 1))...
                || isempty(find(flank1 > event_info.events(n).ttl_electrodes, 1))...
                || isempty(find(flank2 > event_info.events(n).ttl_electrodes, 1))...
                || isempty(find(rankcent < 1, 1))...
                || isempty(find(flank1 < 1, 1))...
                || isempty(find(flank2 < 1, 1)))
            error('Error in rank centrality: Illegal entries in the matrix');
        end
                
        %Normalization in length (#time points)
        if dur_flag
            rankcent = interp1(1:length(dur), rankcent', interval, 'linear')';
        end
        
        if ~(isempty(find(rankcent > event_info.events(n).ttl_electrodes, 1))...
                || isempty(find(rankcent < 1, 1)))
            error('Error in rankcentrality interpolation: Illegal matrix entries');
        end
        
        %concatenating pre and post seizure activity to define the signal of interest
        rankcent = cat(2, flank1, rankcent, flank2);
        
        %Smoothing the rank signal with a sliding window of size 21
        for etd = 1:event_info.events(n).ttl_electrodes
            rankcent(etd,:) = smooth(rankcent(etd,:), window, 'moving');
        end
        
        %Normalizing in y-axis
        rankcent = rankcent./event_info.events(n).ttl_electrodes;
        
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
        I = zeros(event_info.events(n).ttl_electrodes, length_cdf);
        for i = 1:event_info.events(n).ttl_electrodes
            for j = 1:length_cdf
                I(i,j) = find(ci(i, :) <= cdf(j), 1, 'last');
            end
        end
        
        points.f_vectors{n} = cat(1, points.f_vectors{n}, I);
        
        %Classifying and seggregating electrodes into 4 groups
        %   1. Success and Resected (SR)
        %   2. Success and not Resected (SNR)
        %   3. Failure and Resected (FR)
        %   4. Failure and not Resected (FNR)
        switch p_id{n}
            case succ_p_id
                points.SR.rank = cat(1, points.SR.rank, rankcent(event_info.events(n).RR_electrodes, :));
                points.SR.cdfs = cat(1, points.SR.cdfs, I(event_info.events(n).RR_electrodes, :));
                points.SNR.rank = cat(1, points.SNR.rank, rankcent(NRR_electrodes, :));
                points.SNR.cdfs = cat(1, points.SNR.cdfs, I(NRR_electrodes, :));
            case fail_p_id
                points.FR.rank = cat(1, points.FR.rank, rankcent(event_info.events(n).RR_electrodes, :));
                points.FR.cdfs = cat(1, points.FR.cdfs, I(event_info.events(n).RR_electrodes, :));
                points.FNR.rank = cat(1, points.FNR.rank, rankcent(NRR_electrodes, :));
                points.FNR.cdfs = cat(1, points.FNR.cdfs, I(NRR_electrodes, :));
        end
        clear rankcent
    end
    clear f1
end

%% Initialization for PCA
no_events = [size(points.SR.cdfs, 1), size(points.SNR.cdfs, 1),...
    size(points.FR.cdfs, 1), size(points.FNR.cdfs, 1)];                    %total number of signals

if ~(sum(no_events) == count)
    error('Error in the total number of signals for analysis');
end


srr = 1:no_events(1);                                                      %number of S_RR signals
snrr = (srr(end) + 1):(srr(end) + no_events(2));                           %number of S_NRR signals
frr = (snrr(end) + 1):(snrr(end) + no_events(3));                          %number of F_RR signals
fnrr = (frr(end) + 1): (frr(end) + no_events(4));                          %number of F_NRR signals


%% CDFs PCA for all electrodes

%X defines the data set for PCA, Rows of X contain the observations and
%colums are the variables
X = [points.SR.cdfs; points.SNR.cdfs; points.FR.cdfs; points.FNR.cdfs];
[a, b, e_var, ~, explained] = pca(X, 'Centered', pca_cent_flag);

points.SR.all_PC = b(srr, 1:2);
points.SNR.all_PC = b(snrr, 1:2);
points.FR.all_PC = b(frr, 1:2);
points.FNR.all_PC = b(fnrr, 1:2);

%% Plotting 2D PC space
figure
hold on
scatter(b(srr, 1), b(srr, 2), 'g+');
scatter(b(snrr, 1), b(snrr, 2), 'r.');
scatter(b(frr, 1), b(frr, 2), 'k+');
scatter(b(fnrr, 1), b(fnrr, 2), 'k.');
xlabel('First principal component'), ylabel('Second principal component');
title('PC space projection'), axis('tight')
grid on
axis([-600 600 -300 300])
set(gca,'xtick',-600:100:600)
set(gca,'ytick',-300:50:300)
legend('Success & R', 'Success & NR', 'Failure & R', 'Failure & NR');
hold off

%-------------------------------------------------------------------------%
