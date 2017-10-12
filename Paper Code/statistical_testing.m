% Script: compute_doa_nih
% By: Adam Li
% Description:
% 
% Load in the clinical data and then load in the EZTrack Results to compute
% the degree of agreement with respect to a certain threshold for only NIH
% 
% Will compute:
% i) a set of EZTrack Resulting electrodes that is a function of a
% threshold set, alpha
% ii) the set of clinical electrodes that are important in EZ localization
% iii) a degree of agreement statistic for every dataset
close all;

% for non avgref
resultsDir = '/Users/adam2392/Dropbox (Personal)/EZTrack/PAPER/Organized Results/matlab struct results/';

% for avgref
resultsDir = '/Users/adam2392/Dropbox (Personal)/EZTrack/PAPER/Organized Results/matlab struct results/avgref';

% figure directory to save corresponding figures
figDir = './figures/finalized/';
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

%% set parameters

% thresholds for degree of agreement
thresholds = linspace(0, 1, 100);
thresholds = [0.3, 0.6, 0.9];
FONTSIZE = 20;
metric = 'default';

centers = {'NIH', 'UMMC', 'PY', 'CC'};
center = 'NIH';

% initialize degree of agreement results data struct
success_d = []; % vector to store DOA
failure_d = [];
success_pats = {}; % vector to store patients that were successful
failure_pats = {};
numPats = 0;

%% Main Analysis
% Load in clinical data
if strcmp(center, 'NIH')
    clin_file = fullfile(resultsDir, 'infolabels_NIH.mat');
    ezt_file = fullfile(resultsDir, 'nih_iEEG_results.mat');
elseif strcmp(center, 'UMMC')
    clin_file = 'infolabels_UMMC.mat';
    ezt_file = fullfile(resultsDir, 'ummc_iEEG_results.mat');
elseif strcmp(center, 'PY')
    clin_file = 'infolabels_PY.mat';
    ezt_file = fullfile(resultsDir, 'py_iEEG_results.mat');
elseif strcmp(center, 'CC')
    clin_file = 'infolabels_CC.mat';
    ezt_file = fullfile(resultsDir, 'cc_iEEG_results.mat');
%     ezt_file = 'seeg_temporal.mat';
%     ezt_file = fullfile(resultsDir, 'seeg_cc.mat');
end

clin_results = load(clin_file); clin_results = clin_results.labels;

% Load in EZTrack Results
results = load(ezt_file);
patients = fieldnames(results);
% 
% I = ismember(patients, 'EZT091');
% patients(I) = [];

numPats = length(patients)+numPats;
% loop through each patient
for iPat=1:length(patients)
    patient = patients{iPat};
    
    % vector to store doa for this patient
    pat_d = [];
    
    % get index that this patient occurs in
    clin_index = find(strcmp(lower({clin_results.subject}), lower(patient)));

    % get the resulting matlab struct for this patient
    ezt_struct = results.(patient);
    try
        outcome = ezt_struct.outcome;
    catch e
        disp(e);
        outcome = ezt_struct.Outcome;
    end

    % extract onset, labels, 
    try
        onset_set = clin_results(clin_index).onset;
    catch e
        disp(e)
        onset_set = clin_results(clin_index).focus;
    end
    
    try
        % extract the electrode label names
        elec_labels = ezt_struct.labels;
    catch e
        elec_labels = ezt_struct.E_labels;
    end
    elec_labels = upper(elec_labels);
    elec_labels = strrep(elec_labels, 'POL', '');

    % loop through each seizure result
    try
        seizures = fieldnames(ezt_struct.seiz);
        seizures(strcmp('E_weights' ,seizures)) = [];
    catch e
        seizures = fieldnames(ezt_struct);
        
        seizures(strcmp('outcome' ,seizures)) = [];
        seizures(strcmp('E_labels' ,seizures)) = [];
        seizures(strcmp('E_Weights' ,seizures)) = [];
        seizures(strcmp('R_E_labels', seizures)) = [];
        seizures(strcmp('E_HeatCodes', seizures)) = [];
        seizures(strcmp('Outcome' ,seizures)) = [];
    end
    for iField=1:length(seizures)
        % initialize doa results for this seizure
        D_seiz_results = zeros(length(thresholds), 1);

        try
            weights = ezt_struct.seiz.(seizures{iField});
        catch e
            weights = ezt_struct.(seizures{iField});
        end
        % perform thresholding on the weights to get the ezt_set
        threshold_set = threshold_inclusions(weights', thresholds);
        for iThresh=1:length(thresholds)
            ezt_set = elec_labels(logical(threshold_set(:, iThresh)));
            
            % old files transpose
            try
                D = DOA(ezt_set', onset_set, elec_labels', metric);
            catch e
            % new files don't transpose
                try
                    D = DOA(ezt_set, onset_set, elec_labels, metric);
                catch newe
                    disp(newe);
                end
            end
            % store this doa for this threshold
            D_seiz_results(iThresh) = D;
        end

        % store results into success/failure data struct
        if strcmp(upper(outcome), 'SUCCESS')
            if isempty(success_d)
                success_d = D_seiz_results;
            else
                success_d = [success_d, D_seiz_results];
            end

            success_pats{end+1} = strcat(patient, seizures{iField});
        elseif strcmp(upper(outcome), 'FAILURE')
            if isempty(failure_d) 
                failure_d = D_seiz_results;
            else
                failure_d = [failure_d, D_seiz_results];
            end

            failure_pats{end+1} = strcat(patient, seizures{iField});
        end

        if isempty(pat_d)
            pat_d = D_seiz_results;
        else
            pat_d = [pat_d, D_seiz_results];
        end
            % plot degree of agreement for this seizure index
%             figure;
%             subplot(211);
%             plot(thresholds, D_seiz_results, 'k-'); hold on;
%             axes = gca;
%             xlabel('Thresholds'); ylabel(strcat({'Degree of Agreement using ', metric}));
%             title(strcat(seiz_field, ' degree of agreement for ', patient));
%             if strcmp(metric, 'default')
%                 axes.YLim = [-1, 1]; 
%                 plot(axes.XLim, [0, 0], 'k--'); 
%             elseif strcmp(metric, 'jaccard')
%                 axes.YLim = [0, 1];
%             end
%             axes.FontSize = FONTSIZE;
%     
%             subplot(212);
%             plot(sort(weights));
%             xlabel('Electrodes sorted'); ylabel('Weights From EZTrack');
    end % loop through EZTRACK results 
end % loop through patients

%% Statistical Testing
tests = zeros(length(thresholds),1);
pvals = zeros(length(thresholds),1);
for i=1:length(thresholds)
    [tests(i), pvals(i)] = ttest2(success_d(i,:), failure_d(i,:));
    [tests(i), pvals(i)] = ranksum(success_d(i,:), failure_d(i,:));
end

tests
pvals

%% Box Plotting and Result DOA Visualization
% center = 'All Centers';
figure;
for i=1:length(thresholds)
%     figure;
    subplot(1,3,i);
    hold on;
    axes = gca;
    currfig = gcf;
    toPlot = [success_d(i,:), failure_d(i,:)];
    grp = [zeros(1, length(success_d(i,:))), ones(1, length(failure_d(i,:)))];
    bh = boxplot(toPlot, grp, 'Labels', {'S', 'F'});
    set(bh, 'linewidth', 3);
    axes.Box = 'off';
    axes.LineWidth = 3;
    xlabel('Success or Failed Surgery');
    ylabel(strcat('Degree of Agreement (', metric, ')'));
%     titleStr = strcat(center, ' Patients Distribution of Agreement With Clinical For Surgical Outcomes', ...
%         strcat(' For Threshold =', {' '}, num2str(thresholds(i))));
%     title(titleStr);

    titleStr = strcat('Threshold =', {' '}, num2str(thresholds(i)));
    title(titleStr);
    
    axes.FontSize = FONTSIZE;
    if strcmp(metric, 'default')
        axes.YLim = [-1, 1]; 
        plot(axes.XLim, [0, 0], 'k--', 'LineWidth', 1.5); 
    elseif strcmp(metric, 'jaccard')
        axes.YLim = [0, 1];
    end
%     set(currfig, 'Units', 'inches');
    currfig.Units = 'inches';
    currfig.PaperPosition = [0    0.6389   20.0000   10.5417];
    currfig.Position = [0    0.6389   20.0000   10.5417];
    
%     toSaveFigFile = fullfile(figDir, strcat(center, '_DOA_', num2str(thresholds(i)), '.png'));
%     print(toSaveFigFile, '-dpng', '-r0')
end

% print our results for threshold = 0.9
avg_s = mean(success_d(3,:)); 
sd_s = std(success_d(3,:));

avg_f = mean(failure_d(3,:)); 
sd_f = std(failure_d(3,:));

fprintf('Success doa: %.02f +/- %.02f\n', avg_s, sd_s);
fprintf('Failure doa: %.02f +/- %.02f\n', avg_f, sd_f);

% set the title of overall plot
titleStr = strcat(center, ' Agreement With Surgical Resection Outcomes N=', num2str(numPats));
h = suptitle(titleStr);
set(h, 'FontSize', FONTSIZE); 
h.FontWeight = 'bold';
toSaveFigFile = fullfile(figDir, strcat(center, '_', metric, '_DOA_All'));

savefig(strcat(toSaveFigFile,'.fig'));
print(toSaveFigFile, '-dpng', '-r0')
