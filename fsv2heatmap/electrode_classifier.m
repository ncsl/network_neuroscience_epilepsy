function electrodes = electrode_classifier(data_type, test_element, patient_info, points, number_heatmap_colors)
%-------------------------------------------------------------------------------------------
%
% Description: Creates electrode weights and heat maps for the given list of patients.
%
% Input:      This function takes 5 inputs:
%             1. data_type is 1,2,3,4
%             2. test_element
%             3. patient_info: the patient database
%             4. points: output of pcspace
%             5. number_heatmap_colors:
%
% Output:
%             electrodes: a struct of electrodes in each seizure with average weight
%                         heat is a number from 1 - 20; rgb values come from this heat
%                         TODO: Describe this struct in more depth
%-------------------------------------------------------------------------------------------

patients = fieldnames(patient_info);
test_patient_id = patients{test_element};

sr = points.SR.all_PC;
snr = points.SNR.all_PC;
fr = points.FR.all_PC;
fnr = points.FNR.all_PC;
all = [sr; snr; fr; fnr];

% Centers of the weighting function: "Parameters we found by testing after a couple of iterations."
% Locations of the means in a Gaussian distribution, for example. 
% Weighting fn is a 2-D Gaussian vector.
% Fit and test the data.

% These four means correspond to the four data types:
% hopkins temporal lobe
% hopkins occipital
% cleveland temporal
% cleveland occipital
mu_type = [-250, -25; ...
           -100, -100; ...
           -270, -80; ... %-120,-70;...%-100, -100;...%-340,-140;...%-145, -20;...
            130, -60]; %130, -50];
   
% mf = multiplying factor
% exponential decay, compensating for the fact that the normal dist. isn't 
mf1 = 2e-2; mf2 = 2.5*mf1; mf3 = 4*mf2; mf4 = 1e-3*mf3;                    % exponential multiplying factors
ax_mf1 = [1,1]; ax_mf2 = [0.2,1]; ax_mf3 = [1,8]; ax_mf4 = [1,1];          % elliptical axes' multiplying factors

if data_type <= 3
    cov_mat = cov(all);
    mu = mu_type(data_type,:);    
else
    all(:,2) = -all(:,2);
    cov_mat = cov(all);
    mu = mu_type(data_type,:);
end

% defining quadrants in the pc space
x1 = min(all(:,1)):mu(1); x2 = mu(1):max(all(:,1));
y1 = min(all(:,2)):mu(2); y2 = mu(2):max(all(:,2));

% tmp variables contain the x,y coords of the grid
[X1, Y1] = meshgrid(x1,y1); tmp1 = [X1(:) Y1(:)]; 
[X2, Y2] = meshgrid(x2,y1); tmp2 = [X2(:) Y2(:)]; 
[X3, Y3] = meshgrid(x2,y2); tmp3 = [X3(:) Y3(:)]; 
[X4, Y4] = meshgrid(x1,y2); tmp4 = [X4(:) Y4(:)]; 

%% Function 1 for SR
% https://en.wikipedia.org/wiki/Multivariate_normal_distribution
cov_mat_inv1 = cov_mat^-1;
cov_mat_inv1(1,1) = ax_mf1(1)*cov_mat_inv1(1,1);
cov_mat_inv1(2,2) = ax_mf1(2)*cov_mat_inv1(2,2);
Z1 = zeros(size(tmp1,1),1);
for i = 1:length(Z1)
    Z1(i) = exp(-mf1*(tmp1(i,:) - mu)*cov_mat_inv1*(tmp1(i,:) - mu)');
end

%% Function 2 for FR
cov_mat_inv2 = cov_mat_inv1;
cov_mat_inv2(1,1) = ax_mf2(1)*cov_mat_inv2(1,1);
cov_mat_inv2(2,2) = ax_mf2(2)*mf1*cov_mat_inv2(2,2)/mf2;
Z2 = zeros(size(tmp2,1),1);
for i = 1:length(Z2)
    Z2(i) = exp(-mf2*(tmp2(i,:) - mu)*cov_mat_inv2*(tmp2(i,:) - mu)');
end

%% Function 3 for SNR
cov_mat_inv3 = cov_mat_inv2;
cov_mat_inv3(1,1) = ax_mf3(1)*mf2*cov_mat_inv3(1,1)/mf3;
cov_mat_inv3(2,2) = ax_mf3(2)*cov_mat_inv3(2,2);
Z3 = zeros(size(tmp3,1),1);
for i = 1:length(Z3)
    Z3(i) = exp(-mf3*(tmp3(i,:) - mu)*cov_mat_inv3*(tmp3(i,:) - mu)');
end

%% Function 4 FNR
cov_mat_inv4 = cov_mat_inv3;
cov_mat_inv4(1,1) = ax_mf4(1)*mf1*cov_mat_inv1(1,1)/mf4;
cov_mat_inv4(2,2) = ax_mf4(2)*mf3*cov_mat_inv3(2,2)/mf4;
Z4 = zeros(size(tmp4,1),1);
for i = 1:length(Z4)
    Z4(i) = exp(-mf4*(tmp4(i,:) - mu)*cov_mat_inv4*(tmp4(i,:) - mu)');
end

%%%%%%%%%%

% visualize the first Gaussian

for i=1: length(X1)
    for j = 1:length(Y1)
        
    Ztemp1(i,j) = (exp(-mf1*([X1(i), Y1(j)] - [-250 , -25])*...
        cov_mat_inv1*([X1(i), Y1(j)] - [-250 , -25])'));
 
    end
end

figure(1)
clf
mesh(Ztemp1)

keyboard

%%%%%%%%%%%

% Calculates the weights for each electrode and outputs it.

Z = [Z1;Z2;Z3;Z4];
clr_ind = linspace(min(Z), max(Z), number_heatmap_colors + 1);

test_pc = points.TEST.all_PC;

eval([sprintf('%s', test_patient_id), '=struct([]);']);

e_count = 0;
E_gauss = zeros(patient_info.(test_patient_id).events.ttl_electrodes, patient_info.(test_patient_id).events.nevents);

for k = 1:patient_info.(test_patient_id).events.nevents
    % coordinates in pc space for this electrode for event k
    tmp1 = test_pc((e_count+1):(e_count + patient_info.(test_patient_id).events.ttl_electrodes), :);
    
    % now, to which grid points are they closest?
    
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
    
    % each quadrant has a guassian distribution
    fnr_mu = tmp1(:,1) <=  mu(1) & tmp1(:,2) >= mu(2);
    mu4 = repmat(mu, size(tmp1(fnr_mu,:),1),1);
    E_gauss(fnr_mu, k) = diag(exp(-mf4*(tmp1(fnr_mu,:) - mu4)*...
        cov_mat_inv4*(tmp1(fnr_mu,:) - mu4)'));

    e_count = e_count + patient_info.(test_patient_id).events.ttl_electrodes;
    clear tmp1
end

% Averages the gaussian scores for each quadrant across all seizure events.
% TODO: Average might not make sense if there is high variability.
% This weighting function is a combination of the four gaussians.
% gaussian*heaviside + gaussian*heaviside
E_Weights = sum(E_gauss,2)/patient_info.(test_patient_id).events.nevents;

tmp2 = zeros(size(E_Weights));
for i = 1:number_heatmap_colors
    tmp3 = (E_Weights < clr_ind(i+1)) & ...
        (E_Weights >= clr_ind(i));
    tmp2(tmp3) = (number_heatmap_colors - i) + 1;
end
tmp2(E_Weights == clr_ind(end)) = 1; %#ok<NASGU>

[~, ind] = sort(E_Weights, 'descend'); %#ok<ASGLU>

for k = 1:patient_info.(test_patient_id).events.nevents
    eval([sprintf('%s(1).E_gauss%d', test_patient_id, k), '= E_gauss(ind, k);']);
end

% TODO: Replace these dynamic expressions with a Map
eval([sprintf('%s(1).E_Weights', test_patient_id), '= E_Weights(ind);']);
eval([sprintf('%s(1).E_HeatCodes', test_patient_id), '= tmp2(ind);']);
eval([sprintf('%s(1).E_labels', test_patient_id), '= patient_info.(test_patient_id).labels.values(ind).'';']);

tmp4 = patient_info.(test_patient_id).labels.values(:);
R_E_labels = repmat({''}, patient_info.(test_patient_id).events.ttl_electrodes,1);
R_E_labels(patient_info.(test_patient_id).events.RR_electrodes) = tmp4(patient_info.(test_patient_id).events.RR_electrodes); %#ok<NASGU>
eval([sprintf('%s(1).R_E_labels', test_patient_id), '= R_E_labels(ind);']);

tmp5 = cellstr(upper(patient_info.(test_patient_id).type.outcome)); %#ok<NASGU>
eval([sprintf('%s(1).Outcome', test_patient_id), '= tmp5;']);

electrodes = eval(sprintf('%s', test_patient_id));

end