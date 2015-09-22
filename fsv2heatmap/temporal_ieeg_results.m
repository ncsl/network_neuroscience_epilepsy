function csv_file = temporal_ieeg_results

eztrack_home = [getenv('HOME') '/dev/eztrack/tools'];

eeg_flag = 'iEEG';
lobe = 'temporal';
heatmap_filename = sprintf('%s_%s_CV_results_%s', eeg_flag, lobe, date);
heatmap_file = [eztrack_home '/output/heatmap/' heatmap_filename];

fsv_path = [eztrack_home '/output/fsv'];
patient_type = 1; % corresponds to iEEG temporal patients
number_heatmap_colors = 20;
patient_info = load([eztrack_home '/data/patient_info.mat']);
list_of_patients = {'PY04N007';'PY04N012';'PY04N013';'PY04N015';'PY05N005';'PY11N003';'PY11N006';...
                    'PY12N005';'PY12N008';'PY12N010';'PY12N012';'PY13N003';'PY13N011';'PY14N004';...
                    'PY14N005'};
heatmaps = fsv2heatmap(fsv_path, list_of_patients, patient_type, number_heatmap_colors, patient_info);

save([heatmap_file '.mat'], '-struct', 'heatmaps');

csv_file = [heatmap_file '.csv'];
heatmap_to_csv(heatmaps, csv_file);

end