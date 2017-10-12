function csv_file = fsv2heatmap(eztrack_home, patients_in_region, patient_info, patient_type, test_patient_id, fs)
    
    % path to save output computation
    fsv_path = [eztrack_home '/output/fsv'];
    points = fsv2pcspace(patients_in_region, test_patient_id, patient_info, fsv_path, fs);

    figure_path = [eztrack_home '/output/figures/'];
    plot_pcspace(points, figure_path);

    test_patient = patient_info.(test_patient_id);
    % TODO: Refactor electrode_classifier to take just the values it needs from test_patient
    %       instead of taking a struct to make it easier to get rid of the patient_info data structure.

    number_heatmap_colors = 20;
    results = struct(test_patient_id, electrode_classifier(patient_type, test_patient, points, number_heatmap_colors));

    heatmap_file = [eztrack_home '/output/heatmap/' test_patient_id '_iEEG_temporal_results_' date];
    csv_file = [heatmap_file '.csv'];
    heatmap_to_csv(results, csv_file);

end

