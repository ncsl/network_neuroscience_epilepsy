home = getenv('HOME');
fsv_path = [home '/dev/eztrack/tools/output/fsv'];
patient_info = load([home '/dev/eztrack/tools/data/patient_info.mat']);

% See EZ_extract_patpool in original code to see how these values correspond to temporal patients.
sample = [32 34 35 36 38 39 41 42 43 44 45 47 50 51 52];
test_element = 32;
patient_ids = fieldnames(patient_info);
test_patient_id = patient_ids{test_element};

points = pcspace(fsv_path, patient_info, sample, test_element);

patient_type = 1;
number_heatmap_colors = 20;
output.(test_patient_id) = electrode_classifier(patient_type, test_element, patient_info, points, number_heatmap_colors);

actual_file = ['/tmp/actual_weights_' test_patient_id '.csv'];
heatmap_to_csv(output, actual_file);

expected = fileread([home '/dev/eztrack/tools/tests/fsv2heatmap/expected_weights_PY04N007.csv']);
actual = fileread(actual_file);

assert(isequal(actual, expected));