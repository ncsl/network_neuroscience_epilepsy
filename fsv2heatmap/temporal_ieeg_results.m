function csv_file = temporal_ieeg_results(eztrack_home, test_patient_id, labels_filename, included_channels, start_mark, end_mark, fs)
    if nargin==0
        eztrack_home = '/Users/adam2392/Documents/eztrack/';
        test_patient_id = 'EZT007_seiz003';
        labels_filename = strcat(test_patient_id, '_labels.csv');
        start_mark = 120;
        end_mark = 161;
        included_channels = [1:94];
        fs = 1000;
    end

    % e.g. temporal_ieeg_results([getenv('HOME') '/dev/eztrack'], 'PY12N008', [test_patient_id '_' segment_id '_labels.csv'], 61, 150)
    temporal_patients = {'PY04N007';'PY04N012';'PY04N013';'PY04N015';'PY05N005';...
                         'PY11N003';'PY11N006';'PY12N005';'PY12N008';'PY12N010';...
                         'PY12N012';'PY13N003';'PY13N011';'PY14N004';'PY14N005'};
    
    patient_type = 1; % corresponds to iEEG temporal patients
                     
    [patients_in_region, patient_info] = reference_data(eztrack_home, temporal_patients, test_patient_id, labels_filename, included_channels, start_mark, end_mark);

    csv_file = fsv2heatmap(eztrack_home, patients_in_region, patient_info, patient_type, test_patient_id, fs);
end