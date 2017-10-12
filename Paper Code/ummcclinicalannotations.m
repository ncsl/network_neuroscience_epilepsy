if strcmp(patient_id, 'UMMC001')
    included_channels = [1:22 24:29 31:33 35:79 81:92];
    onset_electrodes = {'GP13', 'GP21', 'GP29'};
    earlyspread_labels = {'GP12', 'GP18', 'GP19', 'GP20', ...
        'GP27', 'GP28', 'GA7', 'GA14', 'GA21'};
    latespread_labels = {};

    frequency_sampling = 500;
    success_or_failure = 1;

    center = 'ummc';
elseif strcmp(patient_id, 'UMMC002')
    included_channels = [1:22 24:29 31:33 35:52];
    onset_electrodes = {'ANT1', 'ANT2', 'ANT3', 'MEST1', 'MEST2', 'MEST3', 'MEST4', 'AT1', 'GRID17', 'GRID25'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 500;
    success_or_failure = 1;

    center = 'ummc';
elseif strcmp(patient_id, 'UMMC003')
    included_channels = [1:22 24:29 31:33 35:48];
%         onset_electrodes = {'MesT4', 'MesT5', 'Grid4', 'Grid10', 'Grid12',...
%             'Grid18', 'Grid19', 'Grid20', 'Grid26', 'Grid27'};

    onset_electrodes = {'MEST4', 'MEST5', 'GRID4', 'GRID10', 'GRID12', ...
        'GRID18', 'GRID19', 'GRID20', 'GRID26', 'GRID27'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 250;

    success_or_failure = 1;
    center = 'ummc';
elseif strcmp(patient_id, 'UMMC004')
    included_channels = [1:22 24:29 31:33 35:49];
    onset_electrodes = {'AT1', 'GRID1', 'GRID9', 'GRID10', 'GRID17', 'GRID18'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 249.853552;
    frequency_sampling = 250;

    success_or_failure = 1;
    center = 'ummc';
elseif strcmp(patient_id, 'UMMC005')
    included_channels = [1:33 35:48];
    onset_electrodes = {'AT2', 'G17', 'G19', 'G25', 'G27', 'AT1', 'AT2', 'AT3', 'AT4', 'AT5', 'AT6'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 999.412111;
    frequency_sampling = 1000;

    success_or_failure = 1;
    center = 'ummc';
elseif strcmp(patient_id, 'UMMC006')
    included_channels = [1:22 24:29 31:33 35:56]; 
    included_channels = [1:22 24:26 28:29 31:33 35:56]; % got rid of G6
    onset_electrodes = {'MT2', 'MT3', 'MT4', 'MES2', 'MES3', 'MES4', 'MES5', 'MAT1', 'MAT2'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 250;
    success_or_failure = 1;
    center = 'ummc';
elseif strcmp(patient_id, 'UMMC007')
    included_channels = [1:30];
    onset_electrodes = {'LMT1', 'LMT2', 'LMT3', 'LMT4', 'RMT1', 'RAT1', 'RAT2', 'RAT3', 'RAT4', ...
        'RPT3', 'RPT4', 'RPT5', 'LPT3', 'LMT1', 'LMT2', 'LAT4', 'LAT5'};
% relabeled from EZTrack        
%         {'LMES1', 'LMES2', 'LMES3', 'LMES4', 'RMES1', 'RPT3', ...
%     'RPT4', 'RPT5', 'RANT1', 'RANT2', 'RANT3', 'RANT4', 'LPT3', ...
%     'LANT4', 'LANT5'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 1000;
    success_or_failure = 0;
    center = 'ummc';
elseif strcmp(patient_id, 'UMMC008')
    included_channels = [1:30];
    onset_electrodes = {'GRID1', 'GRID2', 'GRID3', 'GRID4', 'GRID5', 'GRID9','GRID10', 'GRID11', 'GRID12', 'GRID13', ...
        'GRID17', 'GRID18', 'GRID19', 'GRID20', 'GRID21', 'AT1', 'AT2', 'AT3', 'AT4', 'MT1', 'MT2', ...
        'MT3', 'MT4'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 1000;
    if strcmp(seizure_id, 'sz1')
        frequency_sampling = 250;
    end

    success_or_failure = 1;
    center = 'ummc';
elseif strcmp(patient_id, 'UMMC009')
    included_channels = [1:9 11:30];
    onset_electrodes = {'G4', 'G5', 'G6', 'G7', 'G12', 'G14', 'PT1', 'AT1'};
    earlyspread_labels = {};
    latespread_labels = {};

    frequency_sampling = 1000;

    success_or_failure = -1;
    center = 'ummc';
end