function [patients_in_region, patient_info] = reference_data(eztrack_home, patients_in_region, test_patient_id, labels_filename, start_mark, end_mark)
    patient_info = load([eztrack_home '/data/patient_info.mat']);                     
                     
    % Add test patient info to reference data.
    if (~any(find(ismember(patients_in_region, test_patient_id))))
        patients_in_region{end+1,1} = test_patient_id;
        
        % Test patient labels
        labels_row = fileread([eztrack_home '/output/eeg/' test_patient_id '/' labels_filename]);
        labels = strread(labels_row,'%s','delimiter',',')';

        p = struct([]);
        p(1).labels = struct([]);
        p(1).labels(1).values = labels;
        
        % Test patient events
        p.events = struct([]);
        p.events(1).nevents = 1;
        p.events(1).ttl_electrodes = length(labels);
        p.events(1).start_marks = start_mark; % TODO: check param - must be greater than 60.
        p.events(1).end_marks = end_mark;   % TODO: check param - must be at least 60s less than the duration of the file.
        p.events(1).RR_electrodes = [];
        patient_info.(test_patient_id) = p;
    end

end
