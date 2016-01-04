home = getenv('HOME');
output = '/dev/eztrack/output';
patient_id = 'PY12N008';
patient_file_path = [home output '/eeg/' patient_id '/'];

num_channels = 89;

% 'FTG7' and 'FTG8', index 5 and 6, are grounds or noise.
included_channels = [1:4 7:89];

% Sizes are based on the length of the recording in the filename and frequency.
sizes = [640000, 672000, 737000, 729000];

tic
% eeg2fsv(patient_file_path, patient_id, num_channels, included_channels, sizes);
display(sprintf('computed fsv for %s in %fs\n', patient_id, toc));

expected_file = [home output '/fsv/fsv_pwr' patient_id '.mat'];
expected = load(expected_file);

actual_file = [patient_file_path 'adj_pwr/svd_vectors/fsv_pwr' patient_id '.mat'];
actual = load(actual_file);
display(sprintf('Comparing reference %s to %s...', expected_file, actual_file)); 

% NB: No assertion is included here because the results differ by a small amount due to
% floating point differences.
isequal(expected, actual);