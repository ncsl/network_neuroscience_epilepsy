function results = fsv2heatmap(fsv_path, list_of_patients, patient_type, number_heatmap_colors, patient_info)
%-------------------------------------------------------------------------------------------
%
% Description: Creates electrode weights and heat maps for the given list of patients.
%
% Input:      This function takes 5 inputs:
%             1. fsv_path: the path to home directory of FSV data, a string
%             2. list_of_patients: the cross-validation data set, a cell/array of strings
%             3. patient_type: ieeg, temporal, occipital, etc.
%             4. number_heatmap_colors:
%             5. patient_info: the patient database
%
% Output:
%             results: a struct of patients with electrode weights and heat map colors
%
%-------------------------------------------------------------------------------------------

n = numel(list_of_patients);
all_patient_ids = fieldnames(patient_info);

% Get the index vector into the patient data that matches the list of patients.
[~,patient_indexes,~] = intersect(all_patient_ids, list_of_patients);

% Create a temp variable for parpool to work correctly
output = cell(n,1);

parpool;
parfor i = 1:n
    % step 1: Select one patient as a test and use the rest as a training set 
    test_patient_id = patient_indexes(i);
    
    % step 2: passing the training set for PC analysis and projecting test set
    % on the 2D space defined by training set
    points = pcspace(fsv_path, patient_info, patient_indexes, test_patient_id);   
    
    % step 3: Generating test set's electrodes weights based on the 2D PC space
    output{i} = electrode_classifier(patient_type, test_patient_id, patient_info, points, number_heatmap_colors);
end
delete(gcp('nocreate'))

for i = 1:n
    results.(all_patient_ids{patient_indexes(i)}) = output{i};
end

end