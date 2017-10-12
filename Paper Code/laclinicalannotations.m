if strcmp(patient_id, 'LA01')
    included_channels = [1:4 7:19 21:29 32:37 42:43 46:108 110:128];
    included_channels = [1 3 7:8 11:13 17:19 22:26 32 34:35 37 42 50:51 58 ... 
                        62:65 70:72 77:81 84:97 100:102 105:107 110:114 120:121 130:131];

    onset_electrodes = {'Y''1', 'X''4'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA02')
    included_channels = [1:4 7:19 21:37 46:47 50:101];
    included_channels = [1:4 7 9 11:12 15:18 21:28 30:34 47 50:62 64:67 ...
        70:73 79:87 90 95:99];
    onset_electrodes = {'L''2', 'L''3', 'L''4'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA03')
    included_channels = [1:3 6:33 36:68 77:163];
    included_channels = [1:3 6:33 36:68 77:163];
    onset_electrodes = {'L7'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA04')
    included_channels = [1:4 7:19 21:33 44:129];
    included_channels = [1:4 9:13 15:17 22 24:32 44:47 52:58 60 63:64 ...
        67:70 72:74 77:84 88:91 94:96 98:101 109:111 114:116 121 123:129];
    onset_electrodes = {'L''4', 'G''1'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA05')
    included_channels = [1:4 7:19 21:39 42:191];
    included_channels = [2:4 7:15 21:39 42:82 85:89 96:101 103:114 116:121 ...
        126:145 147:152 154:157 160:161 165:180 182:191];
    onset_electrodes = {'T''1', 'T''2', 'D''1', 'D''2'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA06')
    included_channels = [1:4 7:19 21:37 46:47 50:121];
    included_channels = [1:4 7:12 14:17 19 21:33 37 46:47 50:58 61:62 70:73 77:82 ...
        84:102 104:112 114:119];
    onset_electrodes = {'Q''3', 'Q''4', 'R''3', 'R''4'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA07')
    included_channels = [];
    onset_electrodes = {'T1', 'T3', 'R''8', 'R''9'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 1;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA08')
    included_channels = [1:4 7:19 21:37 42:43 46:149];
    included_channels = [1:2 8:13 15:19 22 25 27:30 34:35 46:48 50:57 ...
        65:68 70:72 76:78 80:84 87:93 100:102 105:108 110:117 123:127 130:131 133:137 ...
        140:146];
    onset_electrodes = {'Q2'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA09')
    included_channels = [1:4 7:19 21:39 42:191];
    included_channels = [3:4 7:17 21:28 33:38 42:47 51:56 58:62 64:69 ...
        73:80 82:84 88:92 95:103 107:121 123 126:146 150:161 164:169 179:181 ...
        183:185 187:191];
    onset_electrodes = {'P''1', 'P''2'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA10')
    included_channels = [1:4 7:19 21:37 46:47 50:185];
    included_channels = [1:4 7:13 17:19 23:32 36:37 46:47 50 54:59 62:66 68:79 82:96 ...
        99:106 108:113 117:127 135:159 163:169 172:173 176:179 181:185];
    onset_electrodes = {'S1', 'S2', 'R2', 'R3'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA11')
    included_channels = [1:4 7:19 21:39 42:191];
    included_channels = [3:4 7:16 22:30 33:39 42 44:49 53:62 64:87 91:100 ...
        102:117 120:127 131:140 142:191];
    onset_electrodes = {'D6', 'Z10'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA12')
    included_channels = [];
    onset_electrodes = {'S1', 'S2', 'R2', 'R3'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA13')
    included_channels = [];
    onset_electrodes = {'Y13', 'Y14'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA14')
    included_channels = [];
    onset_electrodes = {'X''1', 'X''2'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA15')
    included_channels = [1:4 7:19 21:39 42:95 97:112 114:132 135:187];
    included_channels = [1:4 9:12 15:19 21:27 30:34 36:38 43:57 62:66 ...
        68:71 76:85 89:106 108:112 114:115 118:124 127:132 135:158 ...
        161:169 171:186];
    onset_electrodes = {'R1', 'R2', 'R3'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA16')
    included_channels = [1:4 7:19 21:39 42:189];
    included_channels = [1:3 10:16 23:24 28 31:35 37:39 42:44 46:47 ...
        49:54 58:62 64:65 68:70 76:89 93:98 100:101 105:124 126 128:130 ...
        132:134 136:140 142:144 149:156 158:163 165:166 168:170 173:181 183:189];
    onset_electrodes = {'Q7', 'Q8'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'LA17')
    included_channels = [];
    onset_electrodes = {'X''1', 'Y''1'};
    earlyspread_labels = {};
    latespread_labels = {};
    resection_labels = {};
    
    success_or_failure = 0;
    center = 'laserablation';
elseif strcmp(patient_id, 'Pat2')
    included_channels = [1:4 7:19 21:37 46:47 50:100];

    %- took out supposed gray matter received from Zach April 2017
    included_channels = [1:4 7 9 11:12 15:18 21:28 30:34 47 50:62 64:67 70:73 79:87 90 95:99];
    onset_electrodes = {'POL L''2', 'POL L''3', 'POL L''4'};
    earlyspread_labels = {};
    latespread_labels = {};

    resection_labels = {};

    center = 'laserablation';
elseif strcmp(patient_id, 'Pat16')
    included_channels = [1:4 7:19 21:39 42:121 124:157 178:189];

    %- took out supposed gray matter received from Zach
    included_channels = [1:3 10:16 23:24 28 31:35 37:39 42:44 46:47 49:54 58:62 64:65 68:70 76:89 93:98 ...
        100:101 105:121 124 126 128:130 132:134 136:140 142:144 149:156 178:181 183:189];

    onset_electrodes = {'POL Q7', 'POL Q8'};
    earlyspread_labels = {};
    latespread_labels = {};

    resection_labels = {};

    center = 'laserablation';
end