function eeg2fsv(patient_file_path, patient_id, num_channels, ...
    included_channels, sample_rate)
if nargin==0
    patient_id='pt1sz2';
    patient_file_path = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient_id);
    num_channels=98;
    included_channels=[1:36 42 43 46:54 56:69 72:95];
    sample_rate = 1000; % need to change depending on sampling freq. of center (e.g. UMMC = 500 sometimes, NIH=1000)
    file_sizes=269000;
end

sample_to_access = 0;

% Find files to process
f = dir(fullfile(patient_file_path, '*eeg.csv'));
patient_file_names = cell(1, length(f));
for i=(1:length(f))
    patient_file_names{i} = f(i).name;
end

% read through the file and get the number of data points there are.
% delimiter = ',';
% for i=1:length(patient_file_names)
%     fid = fopen(fullfile(patient_file_path, patient_file_names{i}), 'rt');
%     n=0; tline = fgetl(fid);
%     while ischar(tline)
%         tline=fgetl(fid);
%         n = n+1;
%     end
%     fclose(fid);
% end

num_values = file_sizes;
% 1. Compute adjacency matrix sequence, stored into 1-D arrays
% power_coherence(patient_file_path, patient_file_names{i}, num
parpool;
parfor i = 1:length(patient_file_names)
    power_coherence(patient_file_path, patient_file_names{i}, num_values, num_channels, sample_rate, sample_to_access);
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
