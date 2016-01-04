function classified_electrodes = electrode_classifier(data_type, test, points, number_heatmap_colors)
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

%% Configuration
%
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
ax_mf = [1   1;
         0.2 1;
         1   8;
         1   1];

%% 
     
origin = mu_type(data_type,:);
     
test_points = points.TEST.all_PC;

all_points = [points.SR.all_PC;
              points.SNR.all_PC;
              points.FR.all_PC;
              points.FNR.all_PC];

if data_type > 3
    % TODO: What was different about Cleveland occipital data to require this?
    all_points(:,2) = -all_points(:,2);
end

inv_cov_mat = inverse_covariance_matrix(all_points, ax_mf, mf);

num_electrodes = test.events.ttl_electrodes;
num_seizures = test.events.nevents;

weights = compute_weights(num_electrodes, num_seizures, test_points, origin, mf, inv_cov_mat);
heatcodes = score_quadrants(weights, all_points, origin, mf, inv_cov_mat, number_heatmap_colors);

% create output data structure
[~, sort_descending] = sort(weights, 'descend');
classified_electrodes = struct('E_Weights', []);
[classified_electrodes.E_Weights(1:length(weights))] = deal(weights(sort_descending));
[classified_electrodes.E_HeatCodes(1:length(heatcodes))] = deal(heatcodes(sort_descending));
classified_electrodes.E_labels = test.labels.values(sort_descending);

end