%% Set Working Dirs
homeDir = '/Users/adam2392/Dropbox/EZTrack/PAPER/Data/';
workDir = '/home/WIN/ali39/Dropbox/EZTrack/Hopkins patients data/results/';
if ~isempty(dir(homeDir)), rootDir = homeDir;
elseif ~isempty(dir(workDir)), rootDir = workDir;
else   error('Neither Work nor Home EEG directories exist! Exiting'); end

% new jhu results file
jhuresults = fullfile(rootDir, 'jhu_iEEG_results.mat');

% nih results file
nihresults = fullfile(rootDir, 'nih_iEEG_results.mat');

% ummc results file
ummcresults = fullfile(rootDir, 'ummc_iEEG_results.mat');
seizure_id = 0;

%% Import Data and Add Fields
% data = load(jhuresults);
% patients = fieldnames(data);
% for ipat=1:length(patients)
%     patient = patients{ipat};
% 
%     % set patientID and seizureID
%     patient_id = strcat('JH', patient(4:end));
% 
%     [onset_electrodes, outcome] = determineOnsetElecs(upper(patient_id), upper(seizure_id));
%     
%     patData = data.(patient);
%     
%     if outcome == 1
%         outcome = 'SUCCESS';
%     elseif outcome == 0
%         outcome = 'FAILURE';
%     else
%         outcome = 'N/A';
%     end
%     
%     data.(patient).onset_electrodes = onset_electrodes;
%     data.(patient).outcome = outcome;
% end
% 
% save('jhu_iEEG_results.mat', '-struct', 'data');

%% Import Data and Add Fields
data = load(nihresults);
patients = fieldnames(data);
for ipat=1:length(patients)
    patient = patients{ipat};

    % set patientID and seizureID
    patient_id = strcat('pt', patient(3:end));

    [onset_electrodes, outcome] = determineOnsetElecs(lower(patient_id), upper(seizure_id));
    
    patData = data.(patient);
    
    if outcome == 1
        outcome = 'SUCCESS';
    elseif outcome == 0
        outcome = 'FAILURE';
    else
        outcome = 'N/A';
    end
    
    data.(patient).onset_electrodes = onset_electrodes;
    data.(patient).outcome = outcome;
end

save('nih_iEEG_results.mat', '-struct', 'data');

%% Import Data and Add Fields
data = load(ummcresults);
patients = fieldnames(data);
for ipat=1:length(patients)
    patient = patients{ipat};

    % set patientID and seizureID
    patient_id = strcat('ummc', patient(5:end));

    [onset_electrodes, outcome] = determineOnsetElecs(upper(patient_id), upper(seizure_id));
    
    patData = data.(patient);
    
    if outcome == 1
        outcome = 'SUCCESS';
    elseif outcome == 0
        outcome = 'FAILURE';
    else
        outcome = 'N/A';
    end
    
    data.(patient).onset_electrodes = onset_electrodes;
    data.(patient).outcome = outcome;
end

save('ummc_iEEG_results.mat', '-struct', 'data');