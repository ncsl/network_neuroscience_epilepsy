resultsDir = '/Users/adam2392/Dropbox (Personal)/EZTrack/PAPER/Organized Results/matlab clinical data/results/';

% ezt_file = fullfile(resultsDir, 'ummc_iEEG_results.mat');
% 
% results = load(ezt_file);
% 
% patients = fieldnames(results);
% numPats = length(patients);
% 
% for iPat=1:numPats
%     patient = patients{iPat};
%     
%     ezt_struct = results.(patient);
%     
%     if strcmp(patient, 'ummc001')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc002')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc003')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc004')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc005')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc006')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc007')
%         results.(patient).outcome = 'failure';
%     elseif strcmp(patient, 'ummc008')
%         results.(patient).outcome = 'success';
%     elseif strcmp(patient, 'ummc009')
%         results.(patient).outcome = 'success';
%     end
% end
% 
% save(ezt_file, '-struct', 'results');

%% CC
ezt_file = fullfile('seeg_temporal.mat');

results = load(ezt_file);

patients = fieldnames(results);
numPats = length(patients);

for iPat=1:numPats
    patient = patients{iPat};
    
    ezt_struct = results.(patient);
    
    if strcmp(patient, 'EZT090')
        results.(patient).outcome = 'success';
    elseif strcmp(patient, 'EZT007')
        results.(patient).outcome = 'failure';
    end
end

save(ezt_file, '-struct', 'results');