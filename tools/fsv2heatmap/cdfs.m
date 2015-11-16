function points = cdfs(fsv_path, patient_results, patient_info, test_p_id, succ_p_id, fail_p_id)

pre = 60;              % window (in s) before onset of a seizure
post = 60;             % window (in s) after end of a seizure
window = 21;           % smoothing window proportional to the length of the window, ~60%
max_dur = 500;         % Maximum seizure duration set to 500 seconds for Hopkins
number_of_points = 0;  % counter for number of points in PC space

tmp = struct('rank',[], 'cdfs', [], 'all_PC', []);
points = struct('SR', tmp, 'SNR', tmp, 'FR', tmp, 'FNR', tmp, 'TEST', tmp);

cdf = 0.1:0.1:1;           % Domain of CDF: Used to create intervals
length_cdf = length(cdf);

for n = 1:length(patient_results)
    patient_id = patient_results{n};
    patient = patient_info.(patient_id);
    
    % Load the file containing information about eigenvalues from crosspowers
    f1 = load(fullfile(fsv_path, sprintf('fsv_pwr%s', patient_id))); %#ok<NASGU>
    
    % Extract non-resected electrodes into a seperate array
    non_resected_electrodes = setdiff(1:patient.events.ttl_electrodes, patient.events.RR_electrodes);
    
    for k = 1:patient.events.nevents
        
        % Extract eigenvector centrality from file 
        cent = eval(sprintf('f1.snap%d_gamma', k));
        cent = abs(cent);
        cent(cent < 1*10^-10) = 0;
        
        if  (pre < patient.events.start_marks(k)) && ((patient.events.end_marks(k) + post) < size(cent,2))
            
            % Extracting seizure duration and the flanks information
            duration      = patient.events.start_marks(k):patient.events.end_marks(k);
            pre_duration  = patient.events.start_marks(k)-pre:patient.events.start_marks(k)-1;
            post_duration = patient.events.end_marks(k)+1:patient.events.end_marks(k)+post;
            
            % Converting eigen vector centrality to rank centrality
            rankcent = ranking(cent(:, duration), 'ascend');
            flank1   = ranking(cent(:, pre_duration), 'ascend');
            flank2   = ranking(cent(:, post_duration), 'ascend');
            
            %checking for any illegal entries in the electrode rank centrality matrix
            if ~(isempty(find(rankcent > patient.events.ttl_electrodes, 1))...
                    || isempty(find(flank1 > patient.events.ttl_electrodes, 1))...
                    || isempty(find(flank2 > patient.events.ttl_electrodes, 1))...
                    || isempty(find(rankcent < 1, 1))...
                    || isempty(find(flank1 < 1, 1))...
                    || isempty(find(flank2 < 1, 1)))
                error('Error in rank centrality: Illegal entries in the matrix');
            end
            
            % Normalization in length (#time points)
            if length(duration) ~= max_dur
                interval = linspace(1, length(duration), max_dur);
                rankcent = interp1(1:length(duration), rankcent', interval, 'linear')';
            end
                        
            if ~(isempty(find(rankcent > patient.events.ttl_electrodes, 1)) || isempty(find(rankcent < 1, 1)))
                error('Error in rankcentrality interpolation: Illegal matrix entries');
            end
            
            % concatenating pre and post seizure activity to define the signal of interest
            rankcent = cat(2, flank1, rankcent, flank2);
            
            % Smoothing the rank signal with a sliding window
            for etd = 1:patient.events.ttl_electrodes
                rankcent(etd,:) = smooth(rankcent(etd,:), window, 'moving');
            end
            
            % Normalizing in y-axis
            rankcent = rankcent ./ patient.events.ttl_electrodes;
            
            % TODO: rankcent should now only have values from 0 to 1
            
            %----------------------------
            % TODO: Extract function
            %
            % Normalizing the area to 1 (defining a cdf)
            % so that each row of rankcent integrates to one
            ci = cumtrapz(rankcent, 2);
            for i = 1:size(rankcent, 1)
                rankcent(i, :) = rankcent(i, :)./ci(i, end);
                ci(i, :) = ci(i, :)./ci(i, end);
            end
            
            if ~(isempty(find(ci(:, end) ~= 1, 1)))
                error('Error in area normalization: Illegal matrix entries');
            end
            %---------------------------
            
            %----------------------------
            % TODO: Extract function
            %
            % Extracting the variables for CDF (10 dimensional feature vectors)
            I = zeros(patient.events.ttl_electrodes, length_cdf);
            for i = 1:patient.events.ttl_electrodes
                for j = 1:length_cdf
                    I(i,j) = find(ci(i, :) <= cdf(j), 1, 'last');
                end
            end
            % I is now number of electrodes by length of cdf
            %----------------------------
            
            % Classifying and segregating electrodes into 4 groups
            %   1. Success and Resected (SR)
            %   2. Success and Not Resected (SNR)
            %   3. Failure and Resected (FR)
            %   4. Failure and Not Resected (FNR)
            switch patient_id
                case succ_p_id
                    points.SR.rank  = cat(1, points.SR.rank,  rankcent(patient.events.RR_electrodes, :));
                    points.SR.cdfs  = cat(1, points.SR.cdfs,  I(patient.events.RR_electrodes, :));
                    points.SNR.rank = cat(1, points.SNR.rank, rankcent(non_resected_electrodes, :));
                    points.SNR.cdfs = cat(1, points.SNR.cdfs, I(non_resected_electrodes, :));
                    number_of_points = number_of_points + patient.events.ttl_electrodes;
                case fail_p_id
                    points.FR.rank  = cat(1, points.FR.rank,  rankcent(patient.events.RR_electrodes, :));
                    points.FR.cdfs  = cat(1, points.FR.cdfs,  I(patient.events.RR_electrodes, :));
                    points.FNR.rank = cat(1, points.FNR.rank, rankcent(non_resected_electrodes, :));
                    points.FNR.cdfs = cat(1, points.FNR.cdfs, I(non_resected_electrodes, :));
                    number_of_points = number_of_points + patient.events.ttl_electrodes;
                case test_p_id
                    points.TEST.rank = cat(1, points.TEST.rank, rankcent);
                    points.TEST.cdfs = cat(1, points.TEST.cdfs, I);
            end
        end
    end
end

total_number_signals = [size(points.SR.cdfs, 1), size(points.SNR.cdfs, 1), size(points.FR.cdfs, 1), size(points.FNR.cdfs, 1)];
if ~(sum(total_number_signals) == number_of_points)
    error('Error in the total number of signals for analysis');
end

end