home = getenv('HOME');
eeg_output = '/dev/eztrack/tools/output/eeg';
patient_id = 'PY12N008';
patient_file_path = [home eeg_output '/' patient_id '/'];

frequency = 1000;
num_channels = 89;
sample_to_access = 0;

% 'FTG7' and 'FTG8', index 5 and 6, get removed.
% The std of these channels is < 10...are they grounds or faulty channels?
% TODO: See the channel filtering card for more information.
included_channels = [1:4 7:89];

files = {...
    'PY12N008_07_21_2012_14-05-48_640sec_eeg.csv',...
    'PY12N008_07_21_2012_14-53-23_672sec_eeg.csv',...
    'PY12N008_07_22_2012_13-15-41_737sec_eeg.csv',...
    'PY12N008_07_23_2012_08-41-30_729sec_eeg.csv'};

% Sizes are based on the length of the recording in the filename and frequency.
sizes = [640000, 672000, 737000, 729000];

patient_files = containers.Map(files, sizes);

tic
eeg2fsv(patient_files, patient_file_path, patient_id, frequency, num_channels, included_channels, sample_to_access);
display(sprintf('computed fsv for %s in %fs\n', patient_id, toc));

expected = load([home '/dev/eztrack/tools/output/fsv/fsv_pwr' patient_id '.mat']);
actual = load([patient_file_path 'adj_pwr/svd_vectors/fsv_pwr' patient_id '.mat']);

isequal(expected, actual);