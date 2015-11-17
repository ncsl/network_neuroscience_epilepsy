function points = cdfs(fsv_path, patient_results, patient_info, test_p_id, succ_p_id, fail_p_id)

pre = 60;              % window (in s) before onset of a seizure
post = 60;             % window (in s) after end of a seizure

number_of_points = 0;  % counter for number of points in PC space

tmp = struct('rank',[], 'cdfs', [], 'all_PC', []);
points = struct('SR', tmp, 'SNR', tmp, 'FR', tmp, 'FNR', tmp, 'TEST', tmp);

for n = 1:length(patient_results)
    patient_id = patient_results{n};
    patient = patient_info.(patient_id);
    
    % Load the file containing information about eigenvalues from crosspowers
    fsv = load(fullfile(fsv_path, sprintf('fsv_pwr%s', patient_id))); %#ok<NASGU>

    num_electrodes = patient.events.ttl_electrodes;
    % Extract non-resected electrodes into a separate array
    non_resected_electrodes = setdiff(1:num_electrodes, patient.events.RR_electrodes);

    for k = 1:patient.events.nevents        
        % Extract eigenvector centrality from file 
        cent = eval(sprintf('fsv.snap%d_gamma', k));
        cent = abs(cent);
        cent(cent < 1*10^-10) = 0;
        
        % Ensure event happens within boundary of available data.
        if ~((pre < patient.events.start_marks(k)) && ((patient.events.end_marks(k) + post) < size(cent,2))); continue; end
        
        % Extracting seizure duration and the flanks information
        duration      = patient.events.start_marks(k):patient.events.end_marks(k);
        pre_duration  = patient.events.start_marks(k)-pre:patient.events.start_marks(k)-1;
        post_duration = patient.events.end_marks(k)+1:patient.events.end_marks(k)+post;
        rankcent = rank_centrality(cent, num_electrodes, duration, pre_duration, post_duration);

        area = normalize_area(rankcent);
        intervals = cdf_intervals(num_electrodes, area);

        % Classifying and segregating electrodes into 4 groups
        %   1. Success and Resected (SR)
        %   2. Success and Not Resected (SNR)
        %   3. Failure and Resected (FR)
        %   4. Failure and Not Resected (FNR)
        switch patient_id
            case succ_p_id
                points.SR.rank  = cat(1, points.SR.rank,  rankcent(patient.events.RR_electrodes, :));
                points.SR.cdfs  = cat(1, points.SR.cdfs,  intervals(patient.events.RR_electrodes, :));
                points.SNR.rank = cat(1, points.SNR.rank, rankcent(non_resected_electrodes, :));
                points.SNR.cdfs = cat(1, points.SNR.cdfs, intervals(non_resected_electrodes, :));
                number_of_points = number_of_points + num_electrodes;
            case fail_p_id
                points.FR.rank  = cat(1, points.FR.rank,  rankcent(patient.events.RR_electrodes, :));
                points.FR.cdfs  = cat(1, points.FR.cdfs,  intervals(patient.events.RR_electrodes, :));
                points.FNR.rank = cat(1, points.FNR.rank, rankcent(non_resected_electrodes, :));
                points.FNR.cdfs = cat(1, points.FNR.cdfs, intervals(non_resected_electrodes, :));
                number_of_points = number_of_points + num_electrodes;
            case test_p_id
                points.TEST.rank = cat(1, points.TEST.rank, rankcent);
                points.TEST.cdfs = cat(1, points.TEST.cdfs, intervals);
        end
    end
end

total_number_signals = [size(points.SR.cdfs, 1), size(points.SNR.cdfs, 1), size(points.FR.cdfs, 1), size(points.FNR.cdfs, 1)];

if ~(sum(total_number_signals) == number_of_points)
    error('Error in the total number of signals for analysis');
end

end