function eeg = PY13N003_channel_filter_test()

home = getenv('HOME');
output = '/dev/eztrack/tools/output';
patient_id = 'PY13N003';
patient_file_path = [home output '/eeg/' patient_id '/'];

num_channels = 190;

% Sizes are based on the length of the recording in the filename and frequency.
size = 702121;

eeg = csv2eeg(patient_file_path, 'PY13N003_02_12_2013_00-25-39_701sec_eeg.csv', size, num_channels);
isequal(size, length(eeg(1,:)));




end

