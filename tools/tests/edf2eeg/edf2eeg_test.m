home = getenv('HOME');
eegHome = '/dev/eztrack/tools/data/edf/';
patient = 'PY13N003';
file = '/PY13N003_02_12_2013_00-25-39_701sec.edf';
edf_path = [home eegHome patient file];
output_path = [home '/dev/eztrack/tools/output/eeg/' patient '/' ];

edf2eeg(edf_path, output_path);

% TODO: This is currently just a driver, not a test. Create some assertions.