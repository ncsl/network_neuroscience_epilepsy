function points = fsv2pcspace(reference_patients, test_patient_id, patient_info, fsv_path, fs)


% get all the patient ids currently in the patient info struct
all_patient_ids = fieldnames(patient_info);

% Get the index vector into the patient data that matches the list of patients.
[~,reference_patient_indexes,~] = intersect(all_patient_ids, reference_patients);

% step 1: Select one patient as a test and use the rest as a training set
cellfind = @(string)(@(cell_contents)(strcmp(string, cell_contents)));
test_patient_index = find(cellfun(cellfind(test_patient_id), all_patient_ids), 1);

% step 2: passing the training set for PC analysis and projecting test set
%         on the 2D space defined by training set
points = pcspace(fsv_path, patient_info, reference_patient_indexes, test_patient_index, fs);   

end

