
if strcmp(patient_id, 'pt1')
    included_channels = [1:36 42 43 46:69 72:95];

    if strcmp(seizure_id, 'aslp1')
        included_channels = [1:36 42 43 46:54 56:60 62:69 72:95];
    end

%         included_channels = [1:36 42:69 72:95]; % to test automatic rejection

    onset_electrodes = {'POLATT1', 'POLATT2',...
        'POLAD1', 'POLAD2', 'POLAD3', 'POLAD4', ...
        'POLPD1', 'POLPD2', 'POLPD3', 'POLPD4'}; %pt1
    earlyspread_labels = {'POLATT3', 'POLAST1', 'POLAST2'};
    latespread_labels = {'POLATT4', 'POLATT5', 'POLATT6', ...
                        'POLSLT2', 'POLSLT3', 'POLSLT4', ...
                        'POLMLT2', 'POLMLT3', 'POLMLT4', ...
                        'POLG8', 'POLG16'};        
    resection_labels = {'ATT', 'AST', 'PST', 'AD', 'PD', 'PLT', 'POLSLT'};
    resection_labels = {'POLATT1', 'POLATT2', 'POLATT3', 'POLATT4', 'POLATT5', 'POLATT6', 'POLATT7', 'POLATT8',...
        'POLAST1', 'POLAST2', 'POLAST3', 'POLAST4',...
        'POLPST1', 'POLPST2', 'POLPST3', 'POLPST4', ...
        'POLAD1', 'POLAD2', 'POLAD3', 'POLAD4', ...
        'POLPD1', 'POLPD2', 'POLPD3', 'POLPD4', ...
        'POLPLT5', 'POLPLT6', 'POLSLT1'};
    center = 'nih';

    success_or_failure = 1;
elseif strcmp(patient_id, 'pt2')
    included_channels = [1:14 16:19 21:25 27:37 43 44 47:74];

    if strcmp(seizure_id, 'aslp2')
        included_channels = [1:14 16:19 21:25 27:37 43 44 47:68];
    end
    if strcmp(seizure_id, 'aw2')
        included_channels = [1:14 16:19 21:25 27:37 43 44 47:68 70:74];
    end
%         included_channels = [1:19 21:37 43:74]; % to test automatic rejection

    onset_electrodes = {'POLMST1', ...
                        'POLPST1', ...
                        'POLAST1', 'POLTT1'}; %pt2
    earlyspread_labels = {'POLTT2', 'POLAST2', 'POLMST2', 'POLPST2'};
    latespread_labels = {};
    resection_labels = {'POLTT', 'POLMST', 'POLAST', 'POLG1-4', 'POLG9-12', 'POLG18-20', 'POLG26', 'POLG27'};

    resection_labels = {'TT1', 'TT2', 'TT3', 'TT4', 'TT5', 'TT6', ...
                    'G1', 'G2', 'G3', 'G4', 'G9', 'G10', 'G11', 'G12', 'G18', 'G19', 'G20', 'G26', 'G27',...
                    'AST1', 'AST2', 'AST3', 'AST4',...
                    'MST1', 'MST2', 'MST3', 'MST4'};

    center = 'nih';
    success_or_failure = 1;
elseif strcmp(patient_id, 'pt3')
    included_channels = [1:19 21:37 42 43 46:69 71:133 135];
    included_channels = [1:19 21:37 42:43 46:69 71:107]; % removing left hemisphere electrodes

%         included_channels = [1:37 42:69 71:107]; % testing test automatic rejection

    onset_electrodes = {'POLSFP1', 'POLSFP2', 'POLSFP3', ...
        'POLIFP1', 'POLIFP2', 'POLIFP3', ...
        'POLMFF2', 'POLMFF3', ...
        'POLOF1', 'POLOF2', 'POLOF3', 'POLOF4', ...
        };
    earlyspread_labels = {'POLSFP5', 'POLSFP6', ...
                        'POLIFP1', 'POLIFP2', 'POLIFP3'};
    latespread_labels = {'POLFG10', 'POLFG25'};

    resection_labels = {
        'FG1', 'FG2', 'FG9', 'FG10', 'FG17', 'FG18', 'FG25', ...
        'SFP1', 'SFP2', 'SFP3', 'SFP4', 'SFP5', 'SFP6', 'SFP7', 'SFP8',...
        'MFP1', 'MFP2', 'MFP3', 'MFP4', 'MFP5', 'MFP6', ...
        'IFP1', 'IFP2', 'IFP3', 'IFP4', ...
        'OF3', 'OF4'
        };

    center = 'nih';
    success_or_failure = 1;
elseif strcmp(patient_id, 'pt4')
    included_channels = [3:19 23:24 29:34];
    onset_electrodes = {};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};

    frequency_sampling = 200;

    center = 'nih';

elseif strcmp(patient_id, 'pt5')
    included_channels = [21:22 25:26 35:36];
    onset_electrodes = {};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};

    frequency_sampling = 200;

    center = 'nih';
elseif strcmp(patient_id, 'pt6')
    included_channels = [1:36 42:43 46 52:56 58:71 73:95];
    onset_electrodes = {'POLLA1', 'POLLA2', 'POLLA3', 'POLLA4',...
        'POLLAH1', 'POLLAH2', 'POLLAH3', 'POLLAH4',...
        'POLLPH1', 'POLLPH2', 'POLLPH3', 'POLLPH4'};
    earlyspread_labels = {'POLRAST1', 'POLRPH1', ...
        'POLLALT1', 'POLLALT2', 'POLLALT3', 'POLLALT4', 'POLLALT5', 'POLLALT6' ...
        'POLLPST1', 'POLLPST2', ...
        'POLLAST1', 'POLLAST2', 'POLLAST3'};
    latespread_labels = {'POLRAH1', 'POLRAH2', ...
        'POLLPLT5', 'POLLPLT6', ...
        'POLLFT6'};

    resection_labels = {'LALT1', 'LALT2', 'LALT3', 'LALT4', 'LALT5', 'LALT6',...
        'LAST1', 'LAST2', 'LAST3', 'LAST4', ...
        'LA1', 'LA2', 'LA3', 'LA4', 'LPST4', ...
        'LAH1', 'LAH2', 'LAH3', 'LAH4', ...
        'LPH1', 'LPH2'
        };

    center = 'nih';
    success_or_failure = 0;
 elseif strcmp(patient_id, 'pt7')
    included_channels = [1:17 19:35 37:38 41:62 67:109];
    onset_electrodes = {'POLMFP1', 'POLLFP3', ...
        'POLPT2', 'POLPT3', 'POLPT4', 'POLPT5', ...
        'POLMT2', 'POLMT3', ...
        'POLAT3', 'POLAT4', ...
        'POLG29', 'POLG30', 'POLG39', 'POLG40', 'POLG45', 'POLG46'};
    earlyspread_labels = {'POLG22', 'POLG63', 'POLG64'};
    latespread_labels = {};
    resection_labels = {'G28', 'G29', 'G30', 'G36', 'G37', 'G38', 'G39', ...
        'G41', 'G44', 'G45', 'G46', ...
        'LFP1', 'LFP2', 'LSF3', 'LSF4' };

    center = 'nih';
    success_or_failure = 0;
elseif strcmp(patient_id, 'pt8')
    included_channels = [1:19 21 23 30:37 39:40 43:64 71:76];
    onset_electrodes = {'POLG19','POLG23', 'POLG29', 'POLG30', 'POLG31',...
        'POLTO6', 'POLTO5', ...
        'POLMST3', 'POLMST4', ...
        'POLO8', 'POLO9'};
    earlyspread_labels = {'POLAST2', 'POLAST3', 'POLG10', 'POLG11', 'POLG12', 'POLG13', 'POLG14'};
     latespread_labels = {'POLSO11', 'POLSO12', 'POLPPST3', 'POLPPST4'};

     resection_labels = {'G22', 'G23', 'G27', 'G28', 'G29', 'G30', 'G31', ...
         'MST2', 'MST3', 'MST4', 'PST2', 'PST3', 'PST4'
         };

     center = 'nih';
     success_or_failure = 1;
elseif strcmp(patient_id, 'pt10')
    included_channels = [1:3 5:10 12:19 21:22 24:35 48:85];
    included_channels = [1:3 5:10 12:19 21:22 24:35 48:69]; %w/o p ELECTRODES hfreq noise electrodes
    
    included_channels = [1:3 5:19 21:35 48:69]; % adapted 8/28/17 by Adam to include more electrodes
    onset_electrodes = {'POLTT1', 'POLTT2', 'POLTT3', 'POLTT4', 'POLTT5', 'POLTT6', ...
        'POLMST1', 'POLMST2', ...
        'POLAST2'};

    earlyspread_labels = {'POLMST2', 'POLAST2', 'POLTT3', 'POLTT5'};
    latespread_labels = {};

    center = 'nih';
    success_or_failure = 1;
elseif strcmp(patient_id, 'pt11')
    included_channels = [1:19 21:37 39 40 43:74 76:81 83:87 89:94 101:130];

    % removed G25, B2, B1, RIM, RIPI
    included_channels = [1:19 21:35 37 39 40 43:74 76:81 83:84 101:128];

    % remove LG, LIPI, LIM, LIAI -> left hemisphere electrodes
    included_channels = [1:19 21:35 37 39 40 43:74 76:81 83:84];

%         if REGION_ONLY of microgrid electrodes
%             included_channels = [11:19 21:37 39:40 43:62];
%         end
    onset_electrodes = {'POLRG29', 'POLRG30', 'POLRG31', 'POLRG37', 'POLRG38', 'POLRG39', ...
        'POLRG44', 'POLRG45'};
    earlyspread_labels = {'POLRG4', 'POLRPG5', 'POLRPG6', 'POLRPG11', 'POLRPG12', 'POLRG19', ...
        'POLRAM8', 'POLRAL8', 'POLRG43'};
    latespread_labels = {'POLLIPS4', 'POLRIM3', 'POLRIAI6', 'POLRIPS4', 'POLRIPS5'};

    resection_labels = {'RG4', 'RG5', 'RG6', 'RG7', 'RG12', 'RG13', 'RG14', 'RG15', ...
        'RG21', 'RG22', 'RG23', 'RG29', 'RG30', 'RG31', 'RG37', 'RG38', 'RG39', 'RG45', 'RG46', 'RG47'};

     center = 'nih';
     success_or_failure = 1;
elseif strcmp(patient_id, 'pt12')
    included_channels = [1:15 17:33 38:39 42:61];

    onset_electrodes = {'POLAST1', 'POLAST2', ...
        'POLTT2', 'POLTT3', 'POLTT4', 'POLTT5'};
    earlyspread_labels = {'POLG27', 'POLG28', 'POLG29', 'POLG19', 'POLG20'};
    latespread_labels = { 'POLG12','POLG13','POLG14', 'POLG15', 'POLG22', 'POLG21'};

    resection_labels = {'G19', 'G20', 'G21', 'G22', 'G23', 'G27', 'G28', 'G29', 'G30', 'G31', ...
        'TT1', 'TT2', 'TT3', 'TT4', 'TT5', 'TT6', ...
        'AST1', 'AST2', 'AST3', 'AST4', ...
        'MST1', 'MST2', 'MST3', 'MST4'};

    center = 'nih';
    success_or_failure = 0;
elseif strcmp(patient_id, 'pt13')
    included_channels = [1:36 39:40 43:66 69:74 77 79:94 96:103 105:130];

    onset_electrodes = {'POLG1', 'POLG2', 'POLG9', 'POLG10', 'POLG17', 'POLG18'};
    earlyspread_labels = {'POLAP3', 'POLMF6', ...
        'POLG25', 'POLG26', 'POLG27', 'POLG19', ...
        'POLG11', 'POLG12', 'POLG3', 'POLG4', 'POLG5'};
    latespread_labels = {'POLG4', 'POLRPPIH6', 'POLFPPIH5', 'POLRPPIH4'};

    resection_labels = {'G1', 'G2', 'G3', 'G4', 'G9', 'G10', 'G11', ...
        'G17', 'G18', 'G19', ...
        'AP2', 'AP3', 'AP4'};

    center = 'nih';
    success_or_failure = 1;
elseif strcmp(patient_id, 'pt14')
    included_channels = [1:19 21:37 41:42 45:61 68:78];

    if strcmp(seizure_id, 'sz3')
        included_channels = [1:17 19 21:37 41:42 45:61 68:78];
    end

    % removed G23, 15, G6, 7 (6 and 7 are not on clinical annotations -
    % 02/2/17)
    included_channels = [1:4 7:10 12:17 19 21:37 41:42 45:61 68:78];

    onset_electrodes = {'POLMST1', 'POLMST2', ...
                    'POLTT1', 'POLTT2', 'POLTT3', ...
                    'POLAST1', 'POLAST2'};
    earlyspread_labels = {'POLG2', 'POLG3', 'POLG4', 'POLG5', 'POLG6', ...
        'POLG10', 'POLG11', 'POLG12', 'POLG13', 'POLG18', 'POLG19', 'POLG20', 'POLG21', 'POLG22'};
    latespread_labels = {'POLOF1', 'POLOF2', 'POLOF3', 'POLOF4', ...
        'POLPT4', 'POLPT5', ...
        'POLTT4', 'POLTT5', 'POLTT6', ...
        'POLG29', 'POLG30', 'POLG31', 'POLG32', ...
        'POLLF2', 'POLLF3', 'POLP4', 'POLP5'};

    resection_labels = {'TT1', 'TT2', 'TT3', 'AST1', 'AST2', ...
        'MST1', 'MST2', 'PST1'};

    center = 'nih';
    success_or_failure = 0;
elseif strcmp(patient_id, 'pt15')
    included_channels = [2:7 9:30 32:36 41:42 45:69 71:86 88:89];

    % excludes LSF8 and PST2 due to red strip and no R electrodes
    included_channels = [2:7 9:30 32:36 41:42 45:47 49:66 69 71:85]; 

    onset_electrodes = {'POLTT1', 'POLTT2', 'POLTT3', 'POLTT4', ...
        'POLMST1', 'POLMST2', 'POLAST1', 'POLAST2', 'POLAST3'};
%         if strcmp(seizure_id, 'sz1') % getting rid of TT5, which isn't in clinical EZ
%             included_channels = [2:7 9:30 32:36 41:42 45:69 71:86 88:89];
%             ezone_labels = {'POLTT1', 'POLTT2', 'POLTT3', 'POLTT4', 'POLTT5', ...
%                         'POLMST1', 'POLMST2', 'POLAST1', 'POLAST2', 'POLAST3'};
%         end
    earlyspread_labels = {'POLMST3', 'POLMST4', 'POLPST1', 'POLPST2', 'POLG5'};
    latespread_labels = {'POLTO5', 'POLTO6', 'POLOF2', 'POLOF3', 'POLG22'};

    resection_labels = {'G2', 'G3', 'G4', 'G5', 'G10', 'G11', 'G12', 'G13', ...
        'TT1', 'TT2', 'TT3', 'TT4', 'TT5', ...
        'AST1', 'AST2', 'AST3', 'AST4', ...
        'MST1', 'MST2', 'MST3', 'MST4'};

    center = 'nih';
    success_or_failure = 1;
elseif strcmp(patient_id, 'pt16')
    included_channels = [1:19 21:37 42:43 46:53 56:60];
    if strcmp(seizure_id, 'sz2')
        included_channels = [1:19 21:37 42:43 46:53 56:57]; % get rid of R3,R4,R5 with high freq noise
    end

    % remove R1 and R2 and entire R strip -> Ref electrodes
    included_channels = [1:19 21:37 42:43 46:53];

    onset_electrodes = {'POLTT2', 'POLTT3', 'POLTT5', 'POLAST1'};
    earlyspread_labels = {'POLOF1', 'POLOF2', 'POLOF3', ...
        'POLMST1', 'POLMST2' ...
        'POLG12', 'POLG13', 'POLG14', 'POLG15', 'POLG16', ...
        'POLG21', 'POLG22', 'POLG23',' POLG24', 'POLG29', 'POLG30', 'POLG31', 'POLG32'};
    latespread_labels = {'POLG4', 'POLG5', 'POLG6', ...
        'POLPST1', 'POLPST2', 'POLPST3', 'POLPST4'};

    resection_labels = {'G18','G19', 'G20', 'G26', 'G27', 'G28', 'G29', 'G30', ...
        'TT1', 'TT2', 'TT3', 'TT4', 'TT5', 'TT6', ...
        'AST1', 'AST2', 'AST3', 'AST4', ...
        'MST1', 'MST2', 'MST3', 'MST4'};

    center = 'nih';
    success_or_failure = 1;
elseif strcmp(patient_id, 'pt17')
    included_channels = [1:19 21:37 42:43 46:51];

%     if strcmp(seizure_id, 'sz2') % get rid of G7,6,4 with high frequency noises
%         included_channels = [1:19 21 23:25 28:37 42:43 46:51 53];
%     end


    onset_electrodes = {'POLTT', 'POLTT2'};
    earlyspread_labels = {'POLPST1', 'POLPST2', 'POLPST3', 'POLTT3'};
    latespread_labels = {'POLMST1', 'POLMST2', 'POLAST1'};
    resection_labels = {'G27', 'G28', 'G29', 'G30', ...
        'TT', 'TT2', 'TT3', 'TT4', 'TT5', 'TT6', ...
        'AST1', 'AST2', 'AST3', 'AST4', ...
        'MST1', 'MST2', 'MST3', 'MST4'
        };

    frequency_sampling = 2000;

    center = 'nih';
    success_or_failure = 1;
end