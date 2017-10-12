% Script: compute_doa
% By: Adam Li
% Description:
% 
% Load in the clinical data and then load in the EZTrack Results to compute
% the degree of agreement with respect to a certain threshold
% 
% Will compute:
% i) a set of EZTrack Resulting electrodes that is a function of a
% threshold set, alpha
% ii) the set of clinical electrodes that are important in EZ localization
% iii) a degree of agreement statistic for every dataset

resultsDir = '/Users/adam2392/Dropbox (Personal)/EZTrack/PAPER/Organized Results/code/';

% set thresholds
thresholds = linspace(0, 1, 100);
FONTSIZE = 17;
metric = 'default';

% Load in clinical data
nih_clin_file = 'infolabels_NIH.mat';
ummc_clin_file = 'infolabels_UMMC.mat';
jhu_clin_file = 'infolabels_JHU.mat';
py_clin_file = 'infolabels_PY.mat';
cc_clin_file = 'infolabels_CC.mat';

nih = load(nih_clin_file); nih = nih.labels;
ummc = load(ummc_clin_file); ummc = ummc.labels;
jhu = load(jhu_clin_file); jhu = jhu.labels;
py = load(py_clin_file);    py = py.labels;
cc = load(cc_clin_file);    cc = cc.labels;

% Load in EZTrack Results
jhu_ezt_file = fullfile(resultsDir, 'jhu_iEEG_results.mat');
nih_ezt_file = fullfile(resultsDir, 'nih_iEEG_results.mat');
ummc_ezt_file = fullfile(resultsDir, 'ummc_iEEG_results.mat');
cc_ezt_file = fullfile(resultsDir, 'seeg_cc.mat');
py_ezt_file = fullfile(resultsDir, 'py_iEEG_results.mat');

nih_results = load(nih_ezt_file);
jhu_results = load(jhu_ezt_file);
ummc_results = load(ummc_ezt_file);
cc_results = load(cc_ezt_file);
py_results = load(py_ezt_file);

results = {nih_results, jhu_results, ummc_results, cc_results, py_results};
clin_labels = {nih, jhu, ummc, cc, py};
% loop through all centers and compute degree of agreement for each
% seizure, avg, 
for i=1:length(results)
    curr_results = results{i};
    clin_results = clin_labels{i};
    
    patients = fieldnames(curr_results);
    numPats = length(patients);
    
    % loop through each patient
    for iPat=1:numPats
        patient = patients{iPat};
        clin_index = find(strcmp({clin_results.subject}, patient));
        
        ezt_struct = curr_results.(patient);
        num_fields = length(fieldnames(ezt_struct)) - 3; % does not include resection, onset and outcome
        clin_set = clin_results(clin_index).onset;
        
        % extract the electrode label names
        elec_labels = ezt_struct.E_labels;
        elec_labels = upper(elec_labels);
        elec_labels = strrep(elec_labels, 'POL', '');
    
        % loop through each seizure result
        for iField=1:num_fields
            % set the field to look at inside ezt_struct
            if iField ~= num_fields
                seiz_field = strcat('E_gauss', num2str(iField));
            else
                seiz_field = 'E_Weights';
            end
            
            weights = ezt_struct.(seiz_field);
            
            D_seiz_results = zeros(length(thresholds), 1);
            
            % perform thresholding on the weights to get the ezt_set
            threshold_set = threshold_inclusions(weights, thresholds);
            for iThresh=1:length(thresholds)
                ezt_set = elec_labels(logical(threshold_set(:, iThresh)));
                
                D = DOA(ezt_set, clin_set, elec_labels, metric);
                
                D_seiz_results(iThresh) = D;
            end
            
            % plot degree of agreement for this seizure index
            figure;
            subplot(211);
            plot(thresholds, D_seiz_results, 'k-');
            axes = gca;
            xlabel('Thresholds'); ylabel(strcat({'Degree of Agreement using ', metric}));
            title(strcat(seiz_field, ' degree of agreement for ', patient));
            axes.YLim = [-1 1];
            axes.FontSize = FONTSIZE;
            
            subplot(212);
            plot(sort(weights));
            xlabel('Electrodes sorted'); ylabel('Weights From EZTrack');
            
            
        end % loop through EZTRACK results 
    end % loop through patients
end %
