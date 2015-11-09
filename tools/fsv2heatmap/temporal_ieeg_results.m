function csv_file = temporal_ieeg_results(test_patient_id)
% temporal_ieeg_results('PY12N008')

eztrack_home = [getenv('HOME') '/dev/eztrack/tools'];
patient_info = load([eztrack_home '/data/patient_info.mat']);
test_patient = patient_info.(test_patient_id);

patient_type = 1; % corresponds to iEEG temporal patients
number_heatmap_colors = 20;
                  
% patients in pro study but not used here: 'PY04N008'    'PY05N004'    'PY11N004'    'PY13N001'    'PY13N004'    'PY13N010'
% TODO: What is the effect of adding these patients on the resulting heatmaps?

points = load('/Users/bnorton/dev/eztrack/tools/output/heatmap/points.mat');
results = cell(1,1);
results.(test_patient_id) = electrode_classifier(patient_type, test_patient, points, number_heatmap_colors);

%heatmaps = fsv2heatmap(fsv_path, reference_patients, patient_type, number_heatmap_colors, patient_info);

heatmap_file = [eztrack_home '/output/heatmap/' 'iEEG_temporal_CV_results_' date];
csv_file = [heatmap_file '.csv'];

heatmap_to_csv(results, csv_file);

end