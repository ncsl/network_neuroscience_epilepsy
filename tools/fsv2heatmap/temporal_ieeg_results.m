function csv_file = temporal_ieeg_results(test_patient_id)
% e.g. temporal_ieeg_results('PY12N008')

eztrack_home = [getenv('HOME') '/dev/eztrack/tools'];
patient_info = load([eztrack_home '/data/patient_info.mat']);
test_patient = patient_info.(test_patient_id);
% TODO: Refactor electrode_classifier to take just the values it needs from test_patient
%       instead of taking a struct.

patient_type = 1; % corresponds to iEEG temporal patients
number_heatmap_colors = 20;

points = load('/Users/bnorton/dev/eztrack/tools/output/heatmap/points.mat');
results = cell(1,1);
results.(test_patient_id) = electrode_classifier(patient_type, test_patient, points, number_heatmap_colors);

%heatmaps = fsv2heatmap(fsv_path, reference_patients, patient_type, number_heatmap_colors, patient_info);

heatmap_file = [eztrack_home '/output/heatmap/' 'iEEG_temporal_CV_results_' date];
csv_file = [heatmap_file '.csv'];

heatmap_to_csv(results, csv_file);

end