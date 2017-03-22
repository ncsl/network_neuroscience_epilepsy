close all;

% reads in DOA excel files and computes the optimal threshold per patient
HOPPATS = {'PY04N007', 'PY04N008', 'PY04N012', 'PY04N013', 'PY04N015', ...
    'PY05N004', 'PY05N005', 'PY11N003', 'PY11N004', 'PY11N006', ...
    'PY12N005', 'PY12N008', 'PY12N010', 'PY12N012', 'PY13N001', ...
    'PY13N003', 'PY13N004', 'PY13N011', 'PY14N004', 'PY14N005'};

%- success patients
SUCCESS_JHUOLD = {'PY04N008', 'PY04N013', 'PY05N004', 'PY11N006', 'PY12N005', 'PY12N010', ...
    'PY13N003', 'PY13N011', 'PY14N004', 'PY14N005'};
SUCCESS_JHU = {'JH101', 'JH105', 'JH106', 'JH107'};
SUCCESS_NIH = {'pt1', ...
            'pt2', 'pt3', 'pt8', 'pt10', 'pt11', 'pt13'};
SUCCESS_UMMC = {'UMMC002', 'UMMC003', 'UMMC004', 'UMMC005', 'UMMC006', 'UMM008'};

%- failure patients
FAILURE_JHU = {'JH102', 'JH103'};
FAILURE_NIH = {'pt6', 'pt7', 'pt12'};
FAILURE_OLDJHU = {'PY04N007', 'PY04N012', 'PY04N015', 'PY05N005', 'PY11N003', 'PY11N004', ...
    'PY12N008', 'PY12N012', 'PY13N001', 'PY13N004'};

%- no resection patients
NR_JHU = {'JH104'};
NR_UMMC = {'UMMC001', 'UMMC007', 'UMMC009'};

%% Set Working Dirs
homeDir = '/Users/adam2392/Dropbox/EZTrack/PAPER/Data/';
workDir = '/home/WIN/ali39/Dropbox/EZTrack/Hopkins patients data/results/';
if ~isempty(dir(homeDir)), rootDir = homeDir;
elseif ~isempty(dir(workDir)), rootDir = workDir;
else   error('Neither Work nor Home EEG directories exist! Exiting'); end

% old jhu results file
resultsFile = fullfile(rootDir, 'iEEG_all_CV_results_22-Jun-2015.mat');
data = load(resultsFile);

% new jhu results file
jhuresults = fullfile(rootDir, 'jhu_iEEG_results.mat');

% nih results file
nihresults = fullfile(rootDir, 'nih_iEEG_results.mat');

% ummc results file
ummcresults = fullfile(rootDir, 'ummc_iEEG_results.mat');

% plotting params
FONTSIZE = 20;

figDir = './figures/doa/';
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

patients = fieldnames(data);

%% Do All Patients
% patThresholds = zeros(length(patients), length(thresholds));
% for iPat=1:length(patients)
%     patient = patients{iPat};
%     
%     % set patientID and seizureID
%     patient_id = patient(1:strfind(patient, 'seiz')-1);
%     seizure_id = strcat('_', patient(strfind(patient, 'seiz'):end));
%     seeg = 1;
%     INTERICTAL = 0;
%     if isempty(patient_id)
%         patient_id = patient(1:strfind(patient, 'sz')-1);
%         seizure_id = patient(strfind(patient, 'sz'):end);
%         seeg = 0;
%     end
%     if isempty(patient_id)
%         patient_id = patient(1:strfind(patient, 'aslp')-1);
%         seizure_id = patient(strfind(patient, 'aslp'):end);
%         seeg = 0;
%         INTERICTAL = 1;
%     end
%     if isempty(patient_id)
%         patient_id = patient(1:strfind(patient, 'aw')-1);
%         seizure_id = patient(strfind(patient, 'aw'):end);
%         seeg = 0;
%         INTERICTAL = 1;
%     end
%     
%     patData = data.(patient);
%     
%     % get the weights and the labels
%     e_weights = patData.E_Weights;
%     outcome = patData.Outcome;
%     
%     % ALL
%     elec_labels = patData.E_labels;
%     
%     % CEZ
%     resect_labels = patData.R_E_labels(~cellfun('isempty', patData.R_E_labels));
%     
%     % based on a certain threshold, compute EEZ for this dataset
%     thresholds = linspace(0.1, 0.95, 100); % create range of thresholds to test
%     doas = zeros(length(thresholds), 1);
%     % for each threshold, compute doa using jaccard index
%     for iThresh=1:length(thresholds)
%         threshold = thresholds(iThresh);
%         
%         % compute EEZ
%         EEZ = elec_labels(find(e_weights > threshold));
%         
%         % compute Jaccard Index
%         doa = DOA(EEZ, resect_labels, elec_labels, 'jaccard');
%         
%         doas(iThresh) = doa;
%     end
%     
%     % compute optimal threshold
%     max_index = find(doas == max(doas));
%     
%     % plotting doa vs threshold for this patient
%     figure;
%     titleStr = {[patient, ' EZTrack | ', outcome{:}], ['Degree of Agreement']};
%     plot(thresholds, doas, 'k-'); hold on;
%     plot(thresholds(max_index), doas(max_index), 'r*');
%     axes = gca;
%     XLIM = axes.XLim;
%     YLIM = axes.YLim;
%     axes.FontSize = FONTSIZE;
%     xlabel('Thresholds');
%     ylabel('Jaccard Index');
%     title(titleStr);
%     text(mean(XLIM), mean(YLIM), ['Max DOA at ', num2str(thresholds(max_index))]);
%     
%     % save optimal thresholds
%     if length(max_index) > 1
%         max_index = max_index(1);
%     end
%     patThresholds(iPat, :) = doas;
%     
%     % save the figure 
%     toSaveFigFile = fullfile(figDir, strcat(patient, 'doavsthreshold'));
%     print(toSaveFigFile, '-dpng', '-r0')
%     
%     close all
% end
% 
% figure;
% shadedErrorBar(thresholds, mean(patThresholds,1), std(patThresholds, 0, 1));


%% Compute SUCCESS AND FAILURE DOA Plots
patients = SUCCESS;
patThresholds = zeros(length(patients), length(thresholds));
for iPat=1:length(patients)
    patient = patients{iPat};
    
    % set patientID and seizureID
    patient_id = patient(1:strfind(patient, 'seiz')-1);
    seizure_id = strcat('_', patient(strfind(patient, 'seiz'):end));
    seeg = 1;
    INTERICTAL = 0;
    if isempty(patient_id)
        patient_id = patient(1:strfind(patient, 'sz')-1);
        seizure_id = patient(strfind(patient, 'sz'):end);
        seeg = 0;
    end
    if isempty(patient_id)
        patient_id = patient(1:strfind(patient, 'aslp')-1);
        seizure_id = patient(strfind(patient, 'aslp'):end);
        seeg = 0;
        INTERICTAL = 1;
    end
    if isempty(patient_id)
        patient_id = patient(1:strfind(patient, 'aw')-1);
        seizure_id = patient(strfind(patient, 'aw'):end);
        seeg = 0;
        INTERICTAL = 1;
    end
    
    patData = data.(patient);
    
    % get the weights and the labels
    e_weights = patData.E_Weights;
    outcome = patData.Outcome;
    
    % ALL
    elec_labels = patData.E_labels;
    
    % CEZ
    resect_labels = patData.R_E_labels(~cellfun('isempty', patData.R_E_labels));
    
    % based on a certain threshold, compute EEZ for this dataset
    thresholds = linspace(0.1, 0.95, 100); % create range of thresholds to test
    doas = zeros(length(thresholds), 1);
    % for each threshold, compute doa using jaccard index
    for iThresh=1:length(thresholds)
        threshold = thresholds(iThresh);
        
        % compute EEZ
        EEZ = elec_labels(find(e_weights > threshold));
        
        % compute Jaccard Index
        doa = DOA(EEZ, resect_labels, elec_labels, 'jaccard');
        
        doas(iThresh) = doa;
    end
    
    % compute optimal threshold
    max_index = find(doas == max(doas));
    
    % plotting doa vs threshold for this patient
    figure;
    titleStr = {[patient, ' EZTrack | ', outcome{:}], ['Degree of Agreement']};
    plot(thresholds, doas, 'k-'); hold on;
    plot(thresholds(max_index), doas(max_index), 'r*');
    axes = gca;
    XLIM = axes.XLim;
    YLIM = axes.YLim;
    axes.FontSize = FONTSIZE;
    xlabel('Thresholds');
    ylabel('Jaccard Index');
    title(titleStr);
    text(mean(XLIM), mean(YLIM), ['Max DOA at ', num2str(thresholds(max_index))]);
    
    % save optimal thresholds
    if length(max_index) > 1
        max_index = max_index(1);
    end
    patThresholds(iPat, :) = doas;
end

figure;
shadedErrorBar(thresholds, mean(patThresholds,1), std(patThresholds, 0, 1));

%% FAILURE
patients = FAILURE;
patThresholds = zeros(length(patients), length(thresholds));
for iPat=1:length(patients)
    patient = patients{iPat};
    
    % set patientID and seizureID
    patient_id = patient(1:strfind(patient, 'seiz')-1);
    seizure_id = strcat('_', patient(strfind(patient, 'seiz'):end));
    seeg = 1;
    INTERICTAL = 0;
    if isempty(patient_id)
        patient_id = patient(1:strfind(patient, 'sz')-1);
        seizure_id = patient(strfind(patient, 'sz'):end);
        seeg = 0;
    end
    if isempty(patient_id)
        patient_id = patient(1:strfind(patient, 'aslp')-1);
        seizure_id = patient(strfind(patient, 'aslp'):end);
        seeg = 0;
        INTERICTAL = 1;
    end
    if isempty(patient_id)
        patient_id = patient(1:strfind(patient, 'aw')-1);
        seizure_id = patient(strfind(patient, 'aw'):end);
        seeg = 0;
        INTERICTAL = 1;
    end
    
    patData = data.(patient);
    
    % get the weights and the labels
    e_weights = patData.E_Weights;
    outcome = patData.Outcome;
    
    % ALL
    elec_labels = patData.E_labels;
    
    % CEZ
    resect_labels = patData.R_E_labels(~cellfun('isempty', patData.R_E_labels));
    
    % based on a certain threshold, compute EEZ for this dataset
    thresholds = linspace(0.1, 0.95, 100); % create range of thresholds to test
    doas = zeros(length(thresholds), 1);
    % for each threshold, compute doa using jaccard index
    for iThresh=1:length(thresholds)
        threshold = thresholds(iThresh);
        
        % compute EEZ
        EEZ = elec_labels(find(e_weights > threshold));
        
        % compute Jaccard Index
        doa = DOA(EEZ, resect_labels, elec_labels, 'jaccard');
        
        doas(iThresh) = doa;
    end
    
    % compute optimal threshold
    max_index = find(doas == max(doas));
    
    % plotting doa vs threshold for this patient
    figure;
    titleStr = {[patient, ' EZTrack | ', outcome{:}], ['Degree of Agreement']};
    plot(thresholds, doas, 'k-'); hold on;
    plot(thresholds(max_index), doas(max_index), 'r*');
    axes = gca;
    XLIM = axes.XLim;
    YLIM = axes.YLim;
    axes.FontSize = FONTSIZE;
    xlabel('Thresholds');
    ylabel('Jaccard Index');
    title(titleStr);
    text(mean(XLIM), mean(YLIM), ['Max DOA at ', num2str(thresholds(max_index))]);
    
    % save optimal thresholds
    if length(max_index) > 1
        max_index = max_index(1);
    end
    patThresholds(iPat, :) = doas;
end

figure;
shadedErrorBar(thresholds, mean(patThresholds,1), std(patThresholds, 0, 1));