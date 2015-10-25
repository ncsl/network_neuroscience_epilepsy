function eeg2fsv(working_directory, patient_id, frequency, num_channels, included_channels, sample_to_access)

patient_file_path = [working_directory '/' patient_id '/'];

% mef2eeg/edf2eeg output files will be stored in files with the pattern 
% '.../PY12N008/PY12N008_07_21_2012_14-05-48_640sec'...
patient_files = dir([patient_file_path patient_id '*_eeg.csv']);
patient_file_names = {patient_files.name};

% 1. Compute adjacency matrix sequence, stored into 1-D arrays
parpool;
parfor i = 1:length(patient_file_names)
    power_coherence(patient_file_path, patient_file_names{i}, num_channels, frequency, sample_to_access);
end
delete(gcp('nocreate'));

% 2. Compute ranked-Eigenvector Centrality (rEVC) sequence
for i = 1:length(patient_file_names)
    svd_decomposition([patient_file_path 'adj_pwr'], patient_file_names{i}, num_channels, included_channels);
end

% 3. Save the output to '.../<svd_vector_path>/fsv_pwr/<patient_id>' as a struct with snapx_gamma
svd_vector_path = [patient_file_path 'adj_pwr/svd_vectors'];
extract_vectors(patient_id, svd_vector_path, length(included_channels));

% TODO: Quick test: Check that all signs are the same in each column
% TODO: Look for cases of extremely small values that should be zero.

end
