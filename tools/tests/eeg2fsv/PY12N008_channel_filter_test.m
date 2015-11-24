function eeg = PY12N008_channel_filter_test()

home = getenv('HOME');
output = '/dev/eztrack/tools/output';
patient_id = 'PY12N008';
patient_file_path = [home output '/eeg/' patient_id '/'];

num_channels = 89;

% Sizes are based on the length of the recording in the filename and frequency,
% in this case, 640 * 1kHz.
size = 640000;

% 'FTG7' and 'FTG8', index 5 and 6, are apparently grounds or noise.
included_channels = [1:4 7:89];

eeg = csv2eeg(patient_file_path, 'PY12N008/PY12N008_640sec_eeg.csv', size, num_channels);
isequal(size, length(eeg(1,:)));

end