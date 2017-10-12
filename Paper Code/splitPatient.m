function [pat, pat_id, seiz_id, isseeg] = splitPatient(patient)
    % set patientID and seizureID
    pat_id = patient(1:strfind(patient, 'seiz')-1);
    seiz_id = strcat('_', patient(strfind(patient, 'seiz'):end));
    isseeg = 1;
    
    if isempty(pat_id) % split by 'sz'
        pat_id = patient(1:strfind(patient, 'sz')-1);
        seiz_id = patient(strfind(patient, 'sz'):end);
        isseeg = 0;
    end
    if isempty(pat_id) % split by 'aslp'
        pat_id = patient(1:strfind(patient, 'aslp')-1);
        seiz_id = patient(strfind(patient, 'aslp'):end);
        isseeg = 0;
    end
    if isempty(pat_id) % split by 'aw'
        pat_id = patient(1:strfind(patient, 'aw')-1);
        seiz_id = patient(strfind(patient, 'aw'):end);
        isseeg = 0;
    end
    if isempty(pat_id) % split by '_' for LA/laser ablation
        pat_id = patient(1:strfind(patient, '_')-1);
        seiz_id = patient(strfind(patient, '_')+1:end);
        isseeg = 1;
    end
    
    buffpatid = pat_id;
    if strcmp(pat_id(end), '_')
        pat_id = pat_id(1:end-1);
    end
    
    pat = strcat(buffpatid, seiz_id);
end