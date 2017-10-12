function [included_channels, onset_electrodes, ...
    earlyspread_labels, latespread_labels, ...
    resection_labels, frequency_sampling, center, success_or_failure] ...
                = determineClinicalAnnotations(patient_id, seizure_id)
    frequency_sampling = 1000; % general default sampling frequency
    resection_labels = {};     % initialize resection labels
    success_or_failure = -1; % if 1, then success, if 0 then failure, if -1 not set
    
    
    included_channels = [];
    onset_electrodes = {};
    earlyspread_labels = {};
    latespread_labels = {};
    center = 'cc';
    
    ummcclinicalannotations;
    nihclinicalannotations; %- run through checking of nih clinical annotations
    laclinicalannotations;
   if strcmp(patient_id, 'EZT007')
        included_channels = [1:16 18:53 55:71 74:78 81:94];
        onset_electrodes = {'O7', 'E8', 'E7', 'I5', 'E9', 'I6', 'E3', 'E2',...
            'O4', 'O5', 'I8', 'I7', 'E10', 'E1', 'O6', 'I1', 'I9', 'E6',...
            'I4', 'O3', 'O2', 'I10', 'E4', 'Y1', 'O1', 'I3', 'I2'}; %pt1
        earlyspread_labels = {};
        latespread_labels = {};
        
        success_or_failure = 0;
        center = 'cc';
    elseif strcmp(patient_id, 'EZT004')
        included_channels = [1:7 9:10 12:22 24:49 51:60 62:73];
        
        if strcmp(seizure_id, 'seiz002')
            included_channels = [1:7 9:10 12:22 24:49 51:60 63:70 72];
        end
        
        onset_electrodes = {'C2', 'C3', 'B2', 'B3', 'E1', 'E2', 'E3',...
                        'U2', 'U3', 'W1', 'Z1', 'O7', 'O8', 'X1', 'X2', ...
                        'X3', 'Y1', 'Y2', 'Y3'};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
    elseif strcmp(patient_id, 'EZT005')
        included_channels = [1:21 23:60 63:88];
        onset_electrodes = {'U3', 'U4','U5', 'U6', 'U7', 'U8'}; 
        earlyspread_labels = {'L4', 'L5', 'C6', 'C9', 'S1', 'S2', ...
            'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'P1', 'P2', 'P3', ...
            'P4', 'P5', 'P6', 'P7', 'P8', 'W5', 'W6', 'W7', 'H5', 'H6', 'H7', ...
            'Y5', 'Y6', 'Y7', 'Y8','X6', 'X7', 'X8', 'M2', 'M3', 'M4', 'M5',...
            'N2', 'N3', 'N4', 'N5', 'N6'};
         latespread_labels = {};
         center = 'cc';
    elseif strcmp(patient_id, 'EZT006')
        included_channels = [1:14 17:35 38:42 45:76];
        onset_electrodes = {'N1','N2', 'Y2'};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
        
    elseif strcmp(patient_id, 'EZT008')
        included_channels = [1:3 5 7:9 11:93 95 97:98 100 102:105];
        onset_electrodes = {};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
    elseif strcmp(patient_id, 'EZT009')
        included_channels = [1:32 34:43 45:85];
        onset_electrodes = {'Q5', 'Q6', 'O4', 'O6', 'O7', 'Y1', 'Y2', 'Y3',...
            'X1', 'X2', 'X3', 'X4', 'X5'};
        earlyspread_labels = {'B5', 'B6', 'B7', 'B8', 'B9', 'C5', 'C6', ...
            'C7', 'C8', 'C9','E4', 'E5', 'E6', 'E7', 'E8', ...
            'B1', 'B2', 'C1', 'C2', 'E1', 'E2', 'E3'};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
    elseif strcmp(patient_id, 'EZT011')
        included_channels = [1:23 25:81];
        
        if strcmp(seizure_id, 'seiz001') % second removal
            included_channels = [1:23 25:63 65:81];
        end
        
        onset_electrodes = {'B1', 'B2'};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
        
    elseif strcmp(patient_id, 'EZT013')
        included_channels = [1:28 31:51 53 55:110];
        onset_electrodes = {'X5', 'X6', 'X7', 'L1', 'L2', 'S1', 'S2', ...
            'L3','L4', 'S3', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'F1', 'F2', 'F3', 'F4'};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
        
    elseif strcmp(patient_id, 'EZT019')
        % resections: A,B,C,E,I AND likely T
        included_channels = [1:5 7:22 24:79];
        onset_electrodes = {'I5', 'I6', 'B9', 'I9', 'T10', 'I10', 'B6', 'I4', ...
            'T9', 'I7', 'B3', 'B5', 'B4', 'I8', 'T6', 'B10', 'T3', ...
            'B1', 'T8', 'T7', 'B7', 'I3', 'B2', 'I2', 'T4', 'T2'}; 
%         ezone_labels = {'B2', 'B3', 'B4', 'C1', 'C2'};
%         ezone_labels = {'B3', 'B4', 'C2'}; % to run estimation alg win size testing
        earlyspread_labels = {'E1', 'E2', 'C3', 'X1', 'X2'};
        latespread_labels = {}; 
        resection_labels = {'A', 'B', 'C', 'E', 'I', 'X'}
        
        center = 'cc';
        
        success_or_failure = 1;
    elseif strcmp(patient_id, 'EZT020')
        included_channels = [1:18 20:40 42:49 55:60 63:79 81 83:86 88:124];
        onset_electrodes = {'B1', 'B2', 'B3', 'C1', 'C2', 'C3', ...
            'O2','O3'};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
        
    elseif strcmp(patient_id, 'EZT025')
        included_channels = [1:28 30:38 43:98];
        onset_electrodes = {};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
        
    elseif strcmp(patient_id, 'EZT026')
        included_channels = [];
        onset_electrodes = {'C1', 'C2', 'C3', 'E1', 'E2', 'E3', 'E4', ...
            'B1', 'B2','B3', 'V1', 'W1', 'O1', 'O2', ...
            'X1', 'X2', 'X3', 'X4'};
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {};
        
        center = 'cc';
    elseif strcmp(patient_id, 'EZT028')
        included_channels = [];
        onset_electrodes = {'P1','P2','P3','P4','P5','P6','P7',...
            'W1','W2'};
        earlyspread_labels = {'R4','R5','R6','R7','R8','X5','X6','X7',...
            'S3','S4','S5','S6','S7','S8'};
        latespread_labels = {'M2','M3','M4','M5','M6', 'Y8', 'Y9'};

        center = 'cc';
    elseif strcmp(patient_id, 'EZT030') % general seizures
        included_channels = [];
        onset_electrodes = {'Q11', 'L6', 'M9', 'N9', 'W9'};
        earlyspread_labels = {};
        latespread_labels = {};
        
        center = 'cc';
    elseif strcmp(patient_id, 'EZT037')
        % resections: A,B,C
        included_channels = [];
%         ezone_labels = {'C1', 'C2', 'I1', 'I2', 'I3', 'I4', 'I5', 'B1', 'B2', 'E1', 'E2', 'E3', 'E4', ...
%             'E5', 'E6', 'E7', 'E8', 'E9', 'E10'};
        onset_electrodes = {'A1', 'B1', 'B2'}; % clinical notes of onset
        earlyspread_labels = {};
        latespread_labels = {};
        resection_labels = {'A', 'B', 'C'};
        
        center = 'cc';
     elseif strcmp(patient_id, 'EZT045') % FAILURES 2 EZONE LABELS?
        included_channels = [1 3:14 16:20 24:28 30:65];
        onset_electrodes = {'X2', 'X1'}; %pt2
        earlyspread_labels = {};
         latespread_labels = {}; 
         
         center = 'cc';
     elseif strcmp(patient_id, 'EZT070')
        included_channels = [1:82 84:94];
        onset_electrodes = {'B8', 'B9', 'B10', 'T4', 'T5', 'T6', 'T7'};
        earlyspread_labels = {'B4', 'B5', 'B6', 'C1', 'C2', 'C3', 'C4'};
        latespread_labels = {'E4', 'U5', 'U6', 'U7', 'W5', 'W6', 'F7', 'F8', ...
            'F9', 'F10', 'X8', 'X9', 'S3', 'S4', 'S5', 'S6', 'R1', 'R2'};
        
        center = 'cc';
      elseif strcmp(patient_id, 'EZT090') % FAILURES
        included_channels = [1:25 27:42 44:49 51:73 75:90 95:111];
        onset_electrodes = {'N2', 'N1', 'N3', 'N8', 'N9', 'N6', 'N7', 'N5'}; 
        earlyspread_labels = {};
        latespread_labels = {};
         
        center = 'cc';
        
        success_or_failure = 1;
    elseif strcmp(patient_id, 'EZT108')
        included_channels = [];
        onset_electrodes = {'F2', 'V7', 'O3', 'O4'}; % marked ictal onset areas
        earlyspread_labels = {};
        latespread_labels = {};
        center = 'cc';
    elseif strcmp(patient_id, 'EZT120')
        included_channels = [];
        onset_electrodes = {'C7', 'C8', 'C9', 'C6', 'C2', 'C10', 'C1'};
        earlyspread_labels = {};
        latespread_labels = {};
        center = 'cc';
        
        success_or_failure = 1;
        
    elseif strcmp(patient_id, 'EZT121')
        included_channels = [];
        onset_electrodes = {'B1', 'B2', 'B3', 'B4', 'C2', 'C3'};
        earlyspread_labels = {};
        latespread_labels = {};
        center = 'cc';
        
        success_or_failure = 1;
    elseif strcmp(patient_id, 'EZT127')
        included_channels = [];
        onset_electrodes = {'C1', 'C2'};
        earlyspread_labels = {};
        latespread_labels = {};
        center = 'cc';
        
        success_or_failure = 1;
    elseif strcmp(patient_id, 'JH101')
        included_channels = [1:4 7:19 21:37 42:43 46 48:63 72 75:86 90:119 122:135];
        
        included_channels = [1:4 7:19 21:37 42:43 46 48:63]; % w/o LTG electrodes
%         onset_electrodes = {'POLLAD1', 'POLLAD2', 'POLLAD3', 'POLLAD4', 'POLLAD5', 'POLLAD6'};
        onset_electrodes = {'POLLAT1', 'POLLAT2', 'POLLAT6', 'POLLAT7', 'POLLAH6'};
        
        earlyspread_labels = {};
        latespread_labels = {};
        
        success_or_failure = 1;
        
        center = 'jhu';
    elseif strcmp(patient_id, 'JH102') % strip dual seizure patient
        included_channels = [1:12 14:36 41:42 45:62 66:123];
        onset_electrodes = {'POLRAT1', 'POLRAT2','POLLBT1', 'POLLBT2', 'POLLBT3', ...
                'POLLAT1', 'POLLAT2', 'POLLAT3'};
        
        if strcmp(seizure_id, 'sz3') || strcmp(seizure_id, 'sz6')
            onset_electrodes = {'POLLBT1', 'POLLBT2', 'POLLBT3', ...
                'POLLAT1', 'POLLAT2', 'POLLAT3'}; % uncertain still on lat/lbts
        end
        earlyspread_labels = {};
        latespread_labels = {};
        
        success_or_failure = 0;
        
        center = 'jhu';
    elseif strcmp(patient_id, 'JH103')
        included_channels = [1:4 7:12 15:23 25:33 47:63 65:66 69:71 73:110];
        
        %- aslp1
        if strcmp(seizure_id, 'aslp1')
            included_channels = [1:4 7:34 47:66 69:73 75:110];
        elseif strcmp(seizure_id, 'aw1')
            included_channels = [1:4 7:33 47:66 69:73 75:110]; % removed 34 (RHD10)
        end
        
        onset_electrodes = {'POLRAD1', 'POLRAD2', 'POLRAD3', 'POLRAD4', 'POLRAD5', ...
            'POLRAD6', 'POLRAD7', 'POLRHD1', 'POLRHD2', 'POLRHD3', 'POLRHD4', ...
            'POLRHD5', 'POLRHD6', 'POLRHD7', 'POLRHD8', 'POLRHD9'};
        earlyspread_labels = {'POLRTG48', 'POLRTG40'};
        latespread_labels = {};
        
        success_or_failure = 0;
        
        center = 'jhu';
    elseif strcmp(patient_id, 'JH104') % strip patient
        included_channels = [1:12 14:19 21:37 42:43 46:69 72:74];
        onset_electrodes = {'POLLAT1', 'POLLAT2', 'POLMBT5', 'POLMBT6', 'POLMBT4', 'POLPBT4'};
        earlyspread_labels = {'POLLPF5', 'POLLPF6', 'POLLFP2', 'POLLFP3', 'POLLFP4'};
        latespread_labels = {};
        
        success_or_failure = 0;
        
        center = 'jhu';
    elseif strcmp(patient_id, 'JH105')
        included_channels = [1:4 7:12 14:19 21:37 42 43 46:49 51:53 55:75 78:99]; % JH105
        
        if strcmp(seizure_id, 'aslp1')
            included_channels = [1:4 7:12 14:19 21:37 42:43 46:49 51:53 55:75 78:99];
        elseif strcmp(seizure_id, 'aw1')
            % removed 55 (RPG40)
            included_channels = [1:4 7:12 14:19 21:37 42:43 46:49 51:53 56:75 78:99];
        end
        
        onset_electrodes = {'POLRPG4', 'POLRPG5', 'POLRPG6', 'POLRPG12', 'POLRPG13', 'POLG14',...
            'POLRPG20','POLRPG21', ...
            'POLAPD1', 'POLAPD2', 'POLAPD3', 'POLAPD4', 'POLAPD5', 'POLAPD6', 'POLAPD7', 'POLAPD8', ...
            'POLPPD1', 'POLPPD2', 'POLPPD3', 'POLPPD4', 'POLPPD5', 'POLPPD6', 'POLPPD7', 'POLPPD8', ...
            'POLASI3', 'POLPSI5', 'POLPSI6'}; % JH105
        earlyspread_labels = {'POLLAT1' 'POLLAT2', 'POLLAT6', 'POLLAT7', 'POLLAT8'};
         latespread_labels = {};
         
         success_or_failure = 1;
         
         center = 'jhu';
    elseif strcmp(patient_id, 'JH106')
        included_channels = [1:4 7:12 14:19 21:37 42:75 77:80 82:102 104:133 138:147 150:181 184:196 198:213];
        
        % w/o LPT
        included_channels = [1:4 7:12 14:19 21:37 42:69 198:213];
        
        onset_electrodes = {'POLPBT1', 'POLPBT2', 'POLPBT3', 'POLPTO2', 'POLPTO3', ...
            'POLPTO4', 'POLLHD7', 'POLLHD8'};
        earlyspread_labels = {};
        latespread_labels = {};
        
        success_or_failure = 0;
        
        center = 'jhu';
    elseif strcmp(patient_id, 'JH107')
        included_channels = [1:7 9:19 21:31 34:37 42:43 45 47:83];
        
%         find(included_channels==5)
%         find(included_channels==6)
%         find(included_channels==43)
%         find(included_channels==45)
        included_channels = [1:4 7 9:19 21:31 34:37 42 47:83]; % removal of noise electrodes 1/27/17
        onset_electrodes = {'POLRAT3', 'POLRAT4', 'POLRATI13', 'POLRATI14', ...
            'POLRATI15', 'POLRATI16', 'POLRATI5', 'POLRATI6', 'POLRATI7', 'POLRATI8'};
        earlyspread_labels = {};
        latespread_labels = {};
        
        success_or_failure = 1;
        
        center = 'jhu';
    elseif strcmp(patient_id, 'JH108')
        included_channels = [1:4 7:12 14:16 18:19 21:37 42:43 46:47 51:69 72:147];
        
        included_channels = [1:4 7:12 14:16 18:19 21:37 42:43 46:47 51:69 72:82]; % w/o left hemisphere electrodes
        
        included_channels = [1:4 7:12 14:16 18:19 21:33 37 42:43 46:47 51:69 72:82]; % w/o left hemisphere electrodes & RPP electrodes
        onset_electrodes = {'POLRDI1', 'POLRDI2', 'POLRDI3', 'POLRDI4', 'POLRSI1', 'POLRSI2', 'POLRSI3', 'POLRSI4'};
        earlyspread_labels = {'POLRPP1', 'POLRPP2'};
        latespread_labels = {};
        
        success_or_failure = 0;
        
        center = 'jhu';
   end
end