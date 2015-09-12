function points = pcspace(fsv_path, patient_info, training_patient_indexes, test_patient_id)

%-----------------------------------------------------------------------------------
%
% Description: This function reads the time series of first singular
%              vectors of both training set and test element, converts them to
%              normalized rank signals of electrodes, groups these rank
%              signals and performs PCA on only the training set electrodes'
%              using the measure CDF for 10-D feature vector. Then the test
%              set electrodes are projected on 2-D space defined by PCA of
%              training set.
%
% Inputs:      This function takes 4 inputs:
%              1. path: string path for directory containing first singular vectors.
%              2. patient_info: patient database
%              3. training_set: the list of patient id string in the training set
%              4. test_element: string id of the patient passed as a test
%
% Output:      points: a structure containing electrode coordinates in 2-D PC space
%
%-----------------------------------------------------------------------------------

%% Variable initialization
num_pat = numel(training_patient_indexes);
test_index = find(training_patient_indexes == test_patient_id);

patient_results = cell(1, num_pat);

% create success and failure 0x0 cell arrays
succ_p_id = {};
fail_p_id = {};

all_patient_ids = fieldnames(patient_info);

% initialize success, fail, and test ids
for n = 1:num_pat
    % TODO: patient_results{n} = patient_id
    patient_results{n} = all_patient_ids{training_patient_indexes(n)};
    if n ~= test_index
        if strcmpi(patient_info.(patient_results{n}).type.outcome, 'success')
            succ_p_id = cat(2, succ_p_id, patient_results{n});
        elseif strcmpi(patient_info.(patient_results{n}).type.outcome, 'failure')
            fail_p_id = cat(2, fail_p_id, patient_results{n});
        end
    else
        % TODO: Isn't this the same as the parameter that was passed in?
        test_p_id = patient_results{n};
    end
end

pre = 60;                                                                  % window (in s) before onset of a seizure
post = 60;                                                                 % window (in s) after end of a seizure

freqband = {'beta', 'gamma'};                                              % frequency band for cross power

window = 21;                                                               % smoothing window proportional to the length of the window, ~60%

tmp = struct('rank',[], 'cdfs', [], 'all_PC', []);
points = struct('SR', tmp, 'SNR', tmp, 'FR', tmp, 'FNR', tmp, 'TEST', tmp);

cdf = 0.1:0.1:1;                                                           % Domain of CDF: Used to create intervals
length_cdf = length(cdf);

max_dur = 500;                                                             % Maximum seizure duration set to 500 seconds for Hopkins
number_of_points = 0;                                                      % counter for number of points in PC space

pca_cent_flag = true;                                                      % true for centering in PCA


%% Main loop
% Scanning through each patient
for n = 1:num_pat
    % TODO: patient_results{n} = patient_id
    
    % Load the file containing information about eigenvalues from crosspowers
    f1 = load(fullfile(fsv_path, sprintf('fsv_pwr%s', patient_results{n}))); %#ok<NASGU>
    
    % Extract non-resected electrodes into a seperate array
    non_resected_electrodes = setdiff(1:patient_info.(patient_results{n}).events.ttl_electrodes, patient_info.(patient_results{n}).events.RR_electrodes);
    
    number_of_points = number_of_points + patient_info.(patient_results{n}).events.nevents * patient_info.(patient_results{n}).events.ttl_electrodes;
    
    
    for k = 1:patient_info.(patient_results{n}).events.nevents
        
        % Extracting the eigen centrality from file 
        cent = eval(sprintf('f1.snap%d_%s', k, freqband{2}));
        cent = abs(cent);
        cent(cent < 1*10^-10) = 0;
        

        if  pre < patient_info.(patient_results{n}).events.start_marks(k) && ...
            patient_info.(patient_results{n}).events.end_marks(k)+post < size(cent,2)
            
            % Extracting seizure duration and the flanks information
            dur = patient_info.(patient_results{n}).events.start_marks(k):...
                patient_info.(patient_results{n}).events.end_marks(k);                      % Seizure duration
            dur1 = patient_info.(patient_results{n}).events.start_marks(k)-pre:...
                patient_info.(patient_results{n}).events.start_marks(k)-1;                  % Pre-Seizure duration
            dur2 = patient_info.(patient_results{n}).events.end_marks(k)+1:...
                patient_info.(patient_results{n}).events.end_marks(k)+post;                 % Post-Seizure duration
            
            % Setting the flag
            if length(dur) ~= max_dur
                dur_flag = 1;
                interval = linspace(1, length(dur), max_dur);
            else
                dur_flag = 0;
            end
            
            % Converting eigen vector centrality to rank centrality
            rankcent = ranking(cent(:, dur), 'ascend');
            flank1 = ranking(cent(:, dur1), 'ascend');
            flank2 = ranking(cent(:, dur2), 'ascend');
            
            clear cent
            
            %checking for any illegal entries in the electrode rank centrality matrix
            if ~(isempty(find(rankcent > patient_info.(patient_results{n}).events.ttl_electrodes, 1))...
                    || isempty(find(flank1 > patient_info.(patient_results{n}).events.ttl_electrodes, 1))...
                    || isempty(find(flank2 > patient_info.(patient_results{n}).events.ttl_electrodes, 1))...
                    || isempty(find(rankcent < 1, 1))...
                    || isempty(find(flank1 < 1, 1))...
                    || isempty(find(flank2 < 1, 1)))
                error('Error in rank centrality: Illegal entries in the matrix');
            end
            
            %Normalization in length (#time points)
            if dur_flag
                rankcent = interp1(1:length(dur), rankcent', interval, 'linear')';
            end
                        
            if ~(isempty(find(rankcent > patient_info.(patient_results{n}).events.ttl_electrodes, 1)) || ...
                 isempty(find(rankcent < 1, 1)))
                error('Error in rankcentrality interpolation: Illegal matrix entries');
            end
            
            % concatenating pre and post seizure activity to define the signal of interest
            rankcent = cat(2, flank1, rankcent, flank2);
            
            % Smoothing the rank signal with a sliding window of size 'window'
            for etd = 1:patient_info.(patient_results{n}).events.ttl_electrodes
                rankcent(etd,:) = smooth(rankcent(etd,:), window, 'moving');
            end
            
            % Normalizing in y-axis
            rankcent = rankcent./patient_info.(patient_results{n}).events.ttl_electrodes;
            
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
            I = zeros(patient_info.(patient_results{n}).events.ttl_electrodes, length_cdf);
            for i = 1:patient_info.(patient_results{n}).events.ttl_electrodes
                for j = 1:length_cdf
                    I(i,j) = find(ci(i, :) <= cdf(j), 1, 'last');
                end
            end
            % I is now number of electrodes by length of cdf
            %----------------------------
            
            % Classifying and seggregating electrodes into 4 groups
            %   1. Success and Resected (SR)
            %   2. Success and not Resected (SNR)
            %   3. Failure and Resected (FR)
            %   4. Failure and not Resected (FNR)
            switch patient_results{n}
                case succ_p_id
                    points.SR.rank = cat(1, points.SR.rank, rankcent(patient_info.(patient_results{n}).events.RR_electrodes, :));
                    points.SR.cdfs = cat(1, points.SR.cdfs, I(patient_info.(patient_results{n}).events.RR_electrodes, :));
                    points.SNR.rank = cat(1, points.SNR.rank, rankcent(non_resected_electrodes, :));
                    points.SNR.cdfs = cat(1, points.SNR.cdfs, I(non_resected_electrodes, :));
                case fail_p_id
                    points.FR.rank = cat(1, points.FR.rank, rankcent(patient_info.(patient_results{n}).events.RR_electrodes, :));
                    points.FR.cdfs = cat(1, points.FR.cdfs, I(patient_info.(patient_results{n}).events.RR_electrodes, :));
                    points.FNR.rank = cat(1, points.FNR.rank, rankcent(non_resected_electrodes, :));
                    points.FNR.cdfs = cat(1, points.FNR.cdfs, I(non_resected_electrodes, :));
                case test_p_id
                    points.TEST.rank = cat(1, points.TEST.rank, rankcent);
                    points.TEST.cdfs = cat(1, points.TEST.cdfs, I);
                    number_of_points = number_of_points - patient_info.(patient_results{n}).events.ttl_electrodes;
            end
            clear rankcent
        end
    end
    clear f1
end

%% Initialization for PCA
no_signals = [size(points.SR.cdfs, 1), size(points.SNR.cdfs, 1),...
    size(points.FR.cdfs, 1), size(points.FNR.cdfs, 1)];                    %total number of signals

if ~(sum(no_signals) == number_of_points)
    error('Error in the total number of signals for analysis');
end

srr = 1:no_signals(1);                                                     %number of S_RR signals
snrr = (srr(end) + 1):(srr(end) + no_signals(2));                          %number of S_NRR signals
frr = (snrr(end) + 1):(snrr(end) + no_signals(3));                         %number of F_RR signals
fnrr = (frr(end) + 1): (frr(end) + no_signals(4));                         %number of F_NRR signals


%% CDFs PCA for all electrodes

%X defines the data set for PCA, Rows of X contain the observations and
%columns are the variables
% TODO: X should be done once across all patients
% I also need to know the patient id
% Store this 'X': This is the model
% Remove the values for this patient
% The model contains a weight function in a 2D space.
% 2 x 10 matrix.
% Test subject is a 10-D space. Place them in the PC space.
X = [points.SR.cdfs; points.SNR.cdfs; points.FR.cdfs; points.FNR.cdfs];
% The second output, score, contains the coordinates of the original data in the new coordinate system defined by the principal components. The score matrix is the same size as the input data matrix
[a, b, ~, ~, ~] = pca(X, 'Centered', pca_cent_flag);

points.SR.all_PC = b(srr, 1:2);
points.SNR.all_PC = b(snrr, 1:2);
points.FR.all_PC = b(frr, 1:2);
points.FNR.all_PC = b(fnrr, 1:2);

avg = mean(X);
points.TEST.all_PC = (points.TEST.cdfs - repmat(avg, [size(points.TEST.cdfs, 1), 1]))*a(:, [1 2]);
end