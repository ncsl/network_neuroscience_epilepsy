function classified_electrodes = electrode_classifier(data_type, test_element, patient_info, points, number_heatmap_colors)
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


% Centers of the weighting function: "Parameters we found by testing after a couple of iterations."
% Locations of the means in a Gaussian distribution, for example. 
% Weighting fn is a 2-D Gaussian vector.
% Fit and test the data.
% hopkins temporal lobe
% hopkins occipital
% cleveland temporal
% cleveland occipital
mu_type = [-250, -25; ...
           -100, -100; ...
           -270, -80; ... %-120,-70;...%-100, -100;...%-340,-140;...%-145, -20;...
            130, -60]; %130, -50];
    
% exponential multiplying factors
mf1 = 2e-2;
mf2 = 2.5*mf1;
mf3 = 4*mf2;
mf4 = 1e-3*mf3;
mf = [mf1 mf2 mf3 mf4];

% elliptical axes' multiplying factors
ax_mf1 = [1,1];
ax_mf2 = [0.2,1];
ax_mf3 = [1,8];
ax_mf4 = [1,1];

patients = fieldnames(patient_info);
test_patient_id = patients{test_element};
test = patient_info.(test_patient_id);
test_pc = points.TEST.all_PC;

sr = points.SR.all_PC;
snr = points.SNR.all_PC;
fr = points.FR.all_PC;
fnr = points.FNR.all_PC;
all = [sr; snr; fr; fnr];

if data_type > 3
    % TODO: What was different about Cleveland occipital data to require this?
    all(:,2) = -all(:,2);
end

%% covariance matrix computation
cov_mat = cov(all);

% Function 1 for SR
cov_mat_inv1 = cov_mat^-1;
cov_mat_inv1(1,1) = ax_mf1(1)*cov_mat_inv1(1,1);
cov_mat_inv1(2,2) = ax_mf1(2)*cov_mat_inv1(2,2);

% Function 2 for FR
cov_mat_inv2 = cov_mat_inv1;
cov_mat_inv2(1,1) = ax_mf2(1)*cov_mat_inv2(1,1);
cov_mat_inv2(2,2) = ax_mf2(2)*mf(1)*cov_mat_inv2(2,2)/mf(2);

% Function 3 for SNR
cov_mat_inv3 = cov_mat_inv2;
cov_mat_inv3(1,1) = ax_mf3(1)*mf(2)*cov_mat_inv3(1,1)/mf(3);
cov_mat_inv3(2,2) = ax_mf3(2)*cov_mat_inv3(2,2);

% Function 4 FNR
cov_mat_inv4 = cov_mat_inv3;
cov_mat_inv4(1,1) = ax_mf4(1)*mf(1)*cov_mat_inv1(1,1)/mf(4);
cov_mat_inv4(2,2) = ax_mf4(2)*mf(3)*cov_mat_inv3(2,2)/mf(4);

cov_mat_inv = cat(3, cov_mat_inv1, cov_mat_inv2, cov_mat_inv3, cov_mat_inv4);
%% end

% Calculates the weights for each electrode and outputs it.

e_count = 0;
num_electrodes = test.events.ttl_electrodes;
num_seizures = test.events.nevents;
E_gauss = zeros(num_electrodes, num_seizures);

origin = mu_type(data_type,:);

for k = 1:num_seizures
    electrodes_in_event = test_pc((e_count+1):(e_count + num_electrodes), :);
    e_count = e_count + num_electrodes;
    
    for j=1:length(electrodes_in_event)
        E_gauss(j, k) = compute_weight(electrodes_in_event(j,:), origin, mf, cov_mat_inv);
    end
end

E_Weights = sum(E_gauss,2) / num_seizures;

%% heatcodes

% Set up the four quadrants
x1 = min(all(:,1)):origin(1);
x2 = origin(1):max(all(:,1));
y1 = min(all(:,2)):origin(2);
y2 = origin(2):max(all(:,2));

[X1, Y1] = meshgrid(x1,y1);
tmp1 = [X1(:) Y1(:)];
[X2, Y2] = meshgrid(x2,y1);
tmp2 = [X2(:) Y2(:)];
[X3, Y3] = meshgrid(x2,y2);
tmp3 = [X3(:) Y3(:)];
[X4, Y4] = meshgrid(x1,y2);
tmp4 = [X4(:) Y4(:)];

% quadrants = quadrants_from(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
% keyboard

% Computes the https://en.wikipedia.org/wiki/Multivariate_normal_distribution

% SR
Z1 = zeros(size(tmp1,1),1);
for i = 1:length(Z1)
    Z1(i) = exp(-mf(1)*(tmp1(i,:) - origin)*cov_mat_inv1*(tmp1(i,:) - origin)');
end

% FR
Z2 = zeros(size(tmp2,1),1);
for i = 1:length(Z2)
    Z2(i) = exp(-mf(2)*(tmp2(i,:) - origin)*cov_mat_inv2*(tmp2(i,:) - origin)');
end

% SNR
Z3 = zeros(size(tmp3,1),1);
for i = 1:length(Z3)
    Z3(i) = exp(-mf(3)*(tmp3(i,:) - origin)*cov_mat_inv3*(tmp3(i,:) - origin)');
end

% FNR
Z4 = zeros(size(tmp4,1),1);
for i = 1:length(Z4)
    Z4(i) = exp(-mf(4)*(tmp4(i,:) - origin)*cov_mat_inv4*(tmp4(i,:) - origin)');
end

Z = [Z1;Z2;Z3;Z4];
clr_ind = linspace(min(Z), max(Z), number_heatmap_colors + 1);

heatcodes = zeros(size(E_Weights));
for i = 1:number_heatmap_colors
    filter = (E_Weights < clr_ind(i+1)) & (E_Weights >= clr_ind(i));
    heatcodes(filter) = (number_heatmap_colors - i) + 1;
end
heatcodes(E_Weights == clr_ind(end)) = 1;
%% end

[~, index_descending] = sort(E_Weights, 'descend');

classified_electrodes = struct('E_Weights', []);
[classified_electrodes.E_Weights(1:length(E_Weights))] = deal(E_Weights(index_descending));
[classified_electrodes.E_HeatCodes(1:length(heatcodes))] = deal(heatcodes(index_descending));
classified_electrodes.E_labels = test.labels.values(index_descending);


end