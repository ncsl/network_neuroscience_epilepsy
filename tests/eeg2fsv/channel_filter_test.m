function channel_filter_test(patient_id, time, expected_size)

home = getenv('HOME');
output = '/dev/eztrack/data/channel_filter/';
event = [patient_id '_' num2str(time) 'sec'];
labels_file_name = [event '_labels.csv'];
eeg_file_name = [event '_eeg.csv'];

% Read in the labels file to get the number of channels...
labels_row = fileread([home output labels_file_name]);
labels = strread(labels_row,'%s','delimiter',',')';
num_channels = length(labels);

display(sprintf('Reading %s...', eeg_file_name));
eeg = csv2eeg([home output], eeg_file_name, expected_size, num_channels);
assert(isequal(expected_size, length(eeg(1,:))), 'number of signals read does not match expected size');

patient_info = load_patient_info();

included_channels = filter_channels(labels, eeg);

assert(isequal(included_channels, patient_info.(patient_id).labels.values),...
       'The results of the channel filter should match the channels in patient_info...');

end
