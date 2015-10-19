home = getenv('HOME');
eeg_output = '/dev/eztrack/tools/output/eeg';

% TODO: Inputs to fn-----------------------------------------------------------------
% working_directory
% patient_id
% frequency
% num_channels
% sample_to_access

working_directory = [home eeg_output];
patient_id = 'PY12N008';
frequency = 1000;

% nChannels depends on the patient - this will need to be an input parameter: 
% length(channels)?
% some of the hard-coded channels don't match this in the original impl.
% There are reference channels that are removed later in the process.
% Some channels are also removed from the analysis if they are consistently 
% noisy or don't change during a seizure.
% TODO: Try leaving in all channels to compare the results.
% NB: Cleveland is more complicated because some channels are in white matter,
% and should be excluded.
num_channels = 89;

sample_to_access = 0;

%----------------------------------------------------------------------

patient_file_path = [working_directory '/' patient_id '/'];

% Find mef2eeg/edf2eeg output files in '.../PY12N008/PY12N008_07_21_2012_14-05-48_640sec.mat'...
patient_files = dir([patient_file_path patient_id '*.mat']);
patient_file_names = {patient_files.name};

%------------------------------------------------------------------------------
% 1. Compute adjacency matrix sequence
% - matrices are stored into 1-D arrays
% parpool;
% parfor i = 1:length(patient_file_names)
%     power_coherence(patient_file_path, patient_file_names{i}, num_channels, frequency, sample_to_access);
% end
% delete(gcp('nocreate'));
%
%------------------------------------------------------------------------------

% 2. Compute ranked-Eigenvector Centrality (rEVC) sequence
for i = 1:length(patient_file_names)
    svd_decomposition([patient_file_path 'adj_pwr'], patient_file_names{i}, num_channels, [1:4 7:89]);
end

svd_vector_path = [patient_file_path 'adj_pwr/svd_vectors'];

extract_vectors(patient_id, svd_vector_path, 87);

% saves the output to ['.../svd_vector_path/fsv_pwr' patient_id] as a struct with snapx_gamma

% TODO: Quick test: Check that all signs are the same in each column
% There are also cases of extremely small values that should be zero.

%------------------------------------------------------------------------------