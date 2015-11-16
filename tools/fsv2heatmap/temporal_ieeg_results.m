function csv_file = temporal_ieeg_results(test_patient_id)
% e.g. temporal_ieeg_results('PY12N008')

eztrack_home = [getenv('HOME') '/dev/eztrack/tools'];
fsv_path = [eztrack_home '/output/fsv'];
figure_path = [eztrack_home '/output/figures/'];
patient_info = load([eztrack_home '/data/patient_info.mat']);

temporal_patients = {'PY04N007';'PY04N012';'PY04N013';'PY04N015';'PY05N005';'PY11N003';'PY11N006';...
                     'PY12N005';'PY12N008';'PY12N010';'PY12N012';'PY13N003';'PY13N011';'PY14N004';...
                     'PY14N005'};

if (~any(find(ismember(temporal_patients, test_patient_id))))
    temporal_patients{end+1,1} = test_patient_id;
end

points = fsv2pcspace(temporal_patients, test_patient_id, patient_info, fsv_path);

plot_pcspace(points, figure_path);

results = cell(1,1);
test_patient = patient_info.(test_patient_id);
% TODO: Refactor electrode_classifier to take just the values it needs from test_patient
%       instead of taking a struct to make it easier to get rid of the patient_info data structure.
patient_type = 1; % corresponds to iEEG temporal patients
number_heatmap_colors = 20;
results.(test_patient_id) = electrode_classifier(patient_type, test_patient, points, number_heatmap_colors);

heatmap_file = [eztrack_home '/output/heatmap/' test_patient_id '_iEEG_temporal_results_' date];
csv_file = [heatmap_file '.csv'];
heatmap_to_csv(results, csv_file);

end