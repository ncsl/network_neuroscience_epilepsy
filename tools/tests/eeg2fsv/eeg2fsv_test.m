home = getenv('HOME');
eeg_output = '/dev/eztrack/tools/output/eeg';
working_directory = [home eeg_output];

patient_id = 'PY12N008';
frequency = 1000;

% nChannels depends on the patient
% some of the hard-coded channels don't match this in the original impl.
num_channels = 89;
sample_to_access = 0;

% 'FTG7' and 'FTG8', index 5 and 6, get removed.
% The std of these channels is < 10...are they grounds or faulty channels?
% TODO: See the channel filtering card for more information.
included_channels = [1:4 7:89];

tic
eeg2fsv(working_directory, patient_id, frequency, num_channels, included_channels, sample_to_access);
display(sprintf('computed fsv for %s in %fs\n', patient_id, toc));

expected = load([home '/dev/eztrack/tools/output/fsv/fsv_pwr' patient_id '.mat']);
actual = load([working_directory '/' patient_id '/adj_pwr/svd_vectors/fsv_pwr' patient_id '.mat']);

isequal(expected, actual);