function temporal_ieeg_results

number_heatmap_colors = 20;

eeg_flag = 'iEEG';
lobe = 'temporal';
patient_type = 1; % corresponds to iEEG temporal patients

list_of_patients = {'PY04N007';'PY04N012';'PY04N013';'PY04N015';'PY05N005';'PY11N003';'PY11N006';...
                    'PY12N005';'PY12N008';'PY12N010';'PY12N012';'PY13N003';'PY13N011';'PY14N004';...
                    'PY14N005'};

eztrack_home = [getenv('HOME') '/dev/eztrack/tools'];
data_path = [eztrack_home '/data'];
heatmap_path = [eztrack_home '/output/heatmap'];
fsv_path = [eztrack_home '/output/fsv'];

patient_info = load([data_path '/patient_info.mat']);

heatmap = fsv2heatmap(fsv_path, list_of_patients, patient_type, number_heatmap_colors, patient_info);

save(fullfile(heatmap_path, ...
              sprintf('%s_%s_CV_results_%s.mat', eeg_flag, lobe, date)), ...
              '-struct', 'heatmap');

end