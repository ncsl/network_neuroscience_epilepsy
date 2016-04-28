function points = pcspace(fsv_path, patient_info, reference_patient_indexes, test_patient_index)

%-----------------------------------------------------------------------------------
%
% Description: This function reads the time series of first singular
%              vectors of both training set and test element, converts them to
%              normalized rank signals of electrodes, groups these rank
%              signals and performs PCA on only the training set electrodes'
%              using the measure CDF for 10-D feature vector. Then the test
%              set electrodes are projected on 2-D space defined by PCA of
%              training set.
%
% Inputs:      This function takes 4 inputs:
%              1. path: string path for directory containing first singular vectors.
%              2. patient_info: patient database
%              3. training_set: the list of patient id string in the training set
%              4. test_element: string id of the patient passed as a test
%
% Output:      points: a structure containing electrode coordinates in 2-D PC space
%
%-----------------------------------------------------------------------------------

%% Variable initialization
num_pat = numel(reference_patient_indexes);
test_index = find(reference_patient_indexes == test_patient_index);

patient_results = cell(1, num_pat);

% create success and failure 0x0 cell arrays
succ_p_id = {};
fail_p_id = {};

all_patient_ids = fieldnames(patient_info);

% initialize success, fail, and test ids
for n = 1:num_pat
    patient_results{n} = all_patient_ids{reference_patient_indexes(n)};
    patient_id = patient_results{n};
    if n == test_index
        test_p_id = patient_id;
    elseif strcmpi(patient_info.(patient_id).type.outcome, 'success')
        succ_p_id = cat(2, succ_p_id, patient_id);
    elseif strcmpi(patient_info.(patient_id).type.outcome, 'failure')
        fail_p_id = cat(2, fail_p_id, patient_id);
    end
end

points = cdfs(fsv_path, patient_results, patient_info, test_p_id, succ_p_id, fail_p_id);

total_number_signals = [size(points.SR.cdfs, 1), size(points.SNR.cdfs, 1), size(points.FR.cdfs, 1), size(points.FNR.cdfs, 1)];

srr  = 1:total_number_signals(1);                               % number of S_RR signals
snrr = (srr(end)  + 1):(srr(end)  + total_number_signals(2));   % number of S_NRR signals
frr  = (snrr(end) + 1):(snrr(end) + total_number_signals(3));   % number of F_RR signals
fnrr = (frr(end)  + 1):(frr(end)  + total_number_signals(4));   % number of F_NRR signals


%% CDFs PCA for all electrodes

% X defines the data set for PCA
% Rows of X contain the observations and columns are the variables

% The model contains a weight function in a 2D space.
% 2 x 10 matrix.
% Test subject is a 10-D space. Place them in the PC space.
X = [points.SR.cdfs; points.SNR.cdfs; points.FR.cdfs; points.FNR.cdfs];
% The second output, score, contains the coordinates of the original data in the new coordinate system defined by the principal components. 
% The score matrix is the same size as the input data matrix.
[a, b, ~, ~, ~] = pca(X, 'Centered', true);

points.SR.all_PC  = b(srr,  1:2);
points.SNR.all_PC = b(snrr, 1:2);
points.FR.all_PC  = b(frr,  1:2);
points.FNR.all_PC = b(fnrr, 1:2);

avg = mean(X);

diff = (points.TEST.cdfs - repmat(avg, [size(points.TEST.cdfs, 1), 1]));

points.TEST.all_PC = diff * a(:, [1 2]);

end