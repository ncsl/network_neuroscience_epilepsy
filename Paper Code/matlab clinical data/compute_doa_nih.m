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

resultsDir = '/Users/adam2392/Dropbox (Personal)/EZTrack/PAPER/Organized Results/matlab clinical data/results/';
figDir = './figures/finalized/';
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

% set thresholds
thresholds = linspace(0, 1, 100);
thresholds = [0.3, 0.6, 0.9];
FONTSIZE = 20;
metric = 'default';

centers = {'NIH', 'UMMC', 'PY', 'CC'};
center = 'CC';

% initialize degree of agreement results data struct
success_d = [];
failure_d = [];
success_pats = {};
failure_pats = {};
numPats = 0;
% for iCenter=1:length(centers)
%     center = centers{iCenter};
    % Load in clinical data
    if strcmp(center, 'NIH')
        clin_file = 'infolabels_NIH.mat';
        ezt_file = fullfile(resultsDir, 'nih_iEEG_results.mat');
    elseif strcmp(center, 'UMMC')
        clin_file = 'infolabels_UMMC.mat';
        ezt_file = fullfile(resultsDir, 'ummc_iEEG_results.mat');
    elseif strcmp(center, 'PY')
        clin_file = 'infolabels_PY.mat';
        ezt_file = fullfile(resultsDir, 'py_iEEG_results.mat');
    elseif strcmp(center, 'CC')
        clin_file = 'infolabels_CC.mat';
        ezt_file = fullfile(resultsDir, 'seeg_temporal.mat');
        ezt_file = 'seeg_temporal.mat';
    end

    clin_results = load(clin_file); clin_results = clin_results.labels;

    % Load in EZTrack Results
    results = load(ezt_file);

    patients = fieldnames(results);
    
    % test removal of certain patients
%     I = ismember(patients, 'ummc007');
%     patients(I) = [];
    I = ismember(patients, 'ummc008');
    patients(I) = [];
    I = ismember(patients, 'ummc009');
    patients(I) = [];
    I = ismember(patients, 'pt11'); % removal of patient with different size electrodes
    patients(I) = [];
    I = ismember(patients, 'pt6'); % removal of strip patient
    patients(I) = [];
    I = ismember(patients, 'pt7');
    patients(I) = [];
    
    numPats = length(patients)+numPats;
    % loop through each patient
    for iPat=1:length(patients)
        patient = patients{iPat};
        clin_index = find(strcmp(lower({clin_results.subject}), lower(patient)));

        % vector to store doa for this patient
        pat_d = [];
        
        ezt_struct = results.(patient);
        try
            outcome = ezt_struct.outcome;
        catch e
            disp(e);
            outcome = ezt_struct.Outcome;
        end

        fields = fieldnames(ezt_struct);
        I = ismember(fields, 'E_HeatCodes');
        fields(I) = [];
        I = ismember(fields, 'E_labels');
        fields(I) = [];
        I = ismember(fields, 'R_E_labels');
        fields(I) = [];
        I = ismember(fields, 'Outcome');
        fields(I) = [];
        I = ismember(fields, 'E_Weights'); % remove average of all outcomes
        fields(I) = [];
        I = ismember(fields, 'onset_electrodes');
        fields(I) = [];
        I = ismember(fields, 'outcome');
        fields(I) = [];

        num_fields = length(fields); % does not include resection, onset and outcome

        try
            clin_set = clin_results(clin_index).onset;
        catch e
            disp(e)
            clin_set = clin_results(clin_index).focus;
        end

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
            seiz_field = strcat('E_gauss', num2str(iField)); % comment out if including average

            seiz_field = fields{iField};

            weights = ezt_struct.(seiz_field);
            seiz_field = lower(seiz_field);

            D_seiz_results = zeros(length(thresholds), 1);

            % perform thresholding on the weights to get the ezt_set
            threshold_set = threshold_inclusions(weights, thresholds);
            for iThresh=1:length(thresholds)
                ezt_set = elec_labels(logical(threshold_set(:, iThresh)));

                D = DOA(ezt_set, clin_set, elec_labels, metric);

                D_seiz_results(iThresh) = D;
            end

            % store results into success/failure data struct
            if strcmp(upper(outcome), 'SUCCESS')
                if isempty(success_d)
                    success_d = D_seiz_results;
                else
                    success_d = [success_d, D_seiz_results];
                end

                success_pats{end+1} = strcat(patient, seiz_field);
            elseif strcmp(upper(outcome), 'FAILURE')
                if isempty(failure_d) 
                    failure_d = D_seiz_results;
                else
                    failure_d = [failure_d, D_seiz_results];
                end

                failure_pats{end+1} = strcat(patient, seiz_field);
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
        
%         figure;
%         for i=1:length(thresholds)
%         %     figure;
%             subplot(1,3,i);
%             hold on;
%             axes = gca;
%             currfig = gcf;
%             toPlot = pat_d(i, :);
%             grp = [zeros(1, length(pat_d(i,:)))];
%             boxplot(toPlot, grp, 'Labels', outcome);
%             xlabel('Success or Failed Surgery');
%             ylabel(strcat('Degree of Agreement (', metric, ')'));
%         %     titleStr = strcat(center, ' Patients Distribution of Agreement With Clinical For Surgical Outcomes', ...
%         %         strcat(' For Threshold =', {' '}, num2str(thresholds(i))));
%         %     title(titleStr);
% 
%             titleStr = strcat('Threshold =', {' '}, num2str(thresholds(i)));
%             title(titleStr);
% 
%             axes.FontSize = FONTSIZE;
%             if strcmp(metric, 'default')
%                 axes.YLim = [-1, 1]; 
%                 plot(axes.XLim, [0, 0], 'k--'); 
%             elseif strcmp(metric, 'jaccard')
%                 axes.YLim = [0, 1];
%             end
%             currfig.Units = 'inches';
%             currfig.PaperPosition = [0    0.6389   20.0000   10.5417];
%             currfig.Position = [0    0.6389   20.0000   10.5417];
%         end
%         
%         titleStr = strcat(center, ' - ', patient, ' Agreement With Clinical For Surgical Outcomes');
%         h = suptitle(titleStr);
%        set(h, 'FontSize', FONTSIZE); 

        
    end % loop through patients
% end % loop through hospital centers

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
