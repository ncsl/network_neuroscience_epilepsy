% %UMMC002_sz2
% patient = 'UMMC002_sz2';
% fs = 500;
% dataDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/');
% metaDir = fullfile('./data/patients');
% delimiter = ',';
% eegfilename = fullfile(dataDir, patient, strcat(patient, '_eeg.csv'));
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*48;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);

% %UMMC002_sz3
% patient = 'UMMC002_sz3';
% fs = 500;
% dataDir = fullfile('./output/eeg/');
% metaDir = fullfile('./data/patients');
% delimiter = ',';
% eegfilename = fullfile(dataDir, patient, strcat(patient, '_eeg.csv'));
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*44;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);

% %UMMC003_sz2
% patient = 'UMMC003_sz2';
% fs = 250;
% dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
% metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
% delimiter = ',';
% eegfilename = strcat(patient, '_eeg.csv');
% eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*15;
% addRightFlank = 0;
% fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);
% clear all

% % %UMMC004_sz2
patient = 'UMMC004_sz2';
fs = 250;
dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
delimiter = ',';
eegfilename = strcat(patient, '_eeg.csv');
eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
patfilename = fullfile(metaDir, strcat(patient, '.csv'));
stepsize = 1;
addLeftFlank = 0;
addRightFlank = fs*2;
fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);

% % % %UMMC005_sz2
% patient = 'UMMC005_sz2';
% fs = 1000;
% dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
% metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
% delimiter = ',';
% eegfilename = strcat(patient, '_eeg.csv');
% eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*10;
% addRightFlank = 0;
% fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);

% % % %UMMC006_sz3
% patient = 'UMMC006_sz3';
% fs = 250;
% dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
% metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
% delimiter = ',';
% eegfilename = strcat(patient, '_eeg.csv');
% eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*39;
% addRightFlank = fs*16;
% fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);

% % %UMMC007_sz1
% patient = 'UMMC007_sz1';
% fs = 1000;
% dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
% metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
% delimiter = ',';
% eegfilename = strcat(patient, '_eeg.csv');
% eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*1;
% addRightFlank = fs*1;
% fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);

% % %UMMC007_sz2
% patient = 'UMMC007_sz2';
% fs = 1000;
% dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
% metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
% delimiter = ',';
% eegfilename = strcat(patient, '_eeg.csv');
% eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*1;
% addRightFlank = fs*9;
% fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);


% % %UMMC007_sz3
% patient = 'UMMC007_sz3';
% fs = 1000;
% dataDir = fullfile('/Users/adam2392/Documents/eztrack/output/eeg/', patient);
% metaDir = fullfile('/Users/adam2392/Documents/eztrack/data/patients');
% delimiter = ',';
% eegfilename = strcat(patient, '_eeg.csv');
% eegDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/', patient);
% patfilename = fullfile(metaDir, strcat(patient, '.csv'));
% stepsize = 1;
% addLeftFlank = fs*1;
% addRightFlank = fs*1;
% fix_ummc_eeg(dataDir, eegDir, eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank, fs);


%% DONE
% %pt11sz1
% delimiter = ',';
% eegfilename = './output/eeg/pt11sz1/pt11sz1_eeg.csv';
% patfilename = './data/patients/pt11sz1.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

%pt11sz3
% delimiter = ',';
% eegfilename = './output/eeg/pt11sz3/pt11sz3_eeg.csv';
% patfilename = './data/patients/pt11sz3.csv';
% stepsize = 1;
% addLeftFlank = 0;
% addRightFlank = 3000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);


% %pt10sz1
% dataDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/');
% delimiter = ',';
% eegfilename = fullfile(dataDir, 'pt10sz1/pt10sz1_eeg.csv');
% patfilename = fullfile(dataDir, 'pt10sz1.csv');
% stepsize = 1;
% addLeftFlank = 21000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% %pt10sz2
% delimiter = ',';
% eegfilename = fullfile(dataDir, 'pt10sz2/pt10sz2_eeg.csv');
% patfilename = fullfile(dataDir, 'pt10sz2.csv');
% stepsize = 1;
% addLeftFlank = 9000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);


% % pt8sz1
% dataDir = fullfile('/Volumes/ADAM LI/eztrack/output/eeg/');
% delimiter = ',';
% eegfilename = fullfile(dataDir, 'pt8sz1/pt8sz1_eeg.csv');
% patfilename = fullfile(dataDir, 'pt8sz1/pt8sz1.csv');
% stepsize = 1;
% addLeftFlank = 21000;
% addRightFlank = 18000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% % pt8sz2
% delimiter = ',';
% eegfilename = fullfile(dataDir, 'pt8sz2/pt8sz2_eeg.csv');
% patfilename = fullfile(dataDir, 'pt8sz2.csv');
% stepsize = 1;
% addLeftFlank = 21000;
% addRightFlank = 10000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% % pt8sz3
% delimiter = ',';
% eegfilename = fullfile(dataDir, 'pt8sz3/pt8sz3_eeg.csv');
% patfilename = fullfile(dataDir, 'pt8sz3.csv');
% stepsize = 1;
% addLeftFlank = 21000;
% addRightFlank = 22000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU107sz1
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz1/JH107sz1_eeg.csv';
% patfilename = './data/patients/JH107sz1.csv';
% stepsize = 1;
% addLeftFlank = 6000;
% addRightFlank = 3000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU107sz2
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz2/JH107sz2_eeg.csv';
% patfilename = './data/patients/JH107sz2.csv';
% stepsize = 1;
% addLeftFlank = 0;
% addRightFlank = 000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU107sz3
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz3/JH107sz3_eeg.csv';
% patfilename = './data/patients/JH107sz3.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU107sz4
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz4/JH107sz4_eeg.csv';
% patfilename = './data/patients/JH107sz4.csv';
% stepsize = 1;
% addLeftFlank = 6000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% %JHU107sz5
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz5/JH107sz5_eeg.csv';
% patfilename = './data/patients/JH107sz5.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 1000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU107sz6
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz6/JH107sz6_eeg.csv';
% patfilename = './data/patients/JH107sz6.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 39000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank); 

%JHU107sz7
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz7/JH107sz7_eeg.csv';
% patfilename = './data/patients/JH107sz7.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 3000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU107sz8
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz8/JH107sz8_eeg.csv';
% patfilename = './data/patients/JH107sz8.csv';
% stepsize = 1;
% addLeftFlank = 0;
% addRightFlank = 2000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

%JHU107sz9
% delimiter = ',';
% eegfilename = './output/eeg/JH107sz9/JH107sz9_eeg.csv';
% patfilename = './data/patients/JH107sz9.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 2000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);


% %JHU106sz1
% delimiter = ',';
% eegfilename = './output/eeg/JH106sz1/JH106sz1_eeg.csv';
% patfilename = './data/patients/JH106sz1.csv';
% stepsize = 1;
% addLeftFlank = 3000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU106sz2
% delimiter = ',';
% eegfilename = './output/eeg/JH106sz2/JH106sz2_eeg.csv';
% patfilename = './data/patients/JH106sz2.csv';
% stepsize = 1;
% addLeftFlank = 6000;
% addRightFlank = 2000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU106sz3
% delimiter = ',';
% eegfilename = './output/eeg/JH106sz3/JH106sz3_eeg.csv';
% patfilename = './data/patients/JH106sz3.csv';
% stepsize = 1;
% addLeftFlank = 6000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU106sz4
% delimiter = ',';
% eegfilename = './output/eeg/JH106sz4/JH106sz4_eeg.csv';
% patfilename = './data/patients/JH106sz4.csv';
% stepsize = 1;
% addLeftFlank = 4000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU106sz5
% delimiter = ',';
% eegfilename = './output/eeg/JH106sz5/JH106sz5_eeg.csv';
% patfilename = './data/patients/JH106sz5.csv';
% stepsize = 1;
% addLeftFlank = 2000;
% addRightFlank = 2000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU106sz6
% delimiter = ',';
% eegfilename = './output/eeg/JH106sz6/JH106sz6_eeg.csv';
% patfilename = './data/patients/JH106sz6.csv';
% stepsize = 1;
% addLeftFlank = 6000;
% addRightFlank = 1000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);


% %JHU105sz2
% delimiter = ',';
% eegfilename = './output/eeg/JH105sz2/JH105sz2_eeg.csv';
% patfilename = './data/patients/JH105sz2.csv';
% stepsize = 1;
% addLeftFlank = 19000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU105sz3
% delimiter = ',';
% eegfilename = './output/eeg/JH105sz3/JH105sz3_eeg.csv';
% patfilename = './data/patients/JH105sz3.csv';
% stepsize = 1;
% addLeftFlank = 6000;
% addRightFlank = 0;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% %JHU105sz4
% delimiter = ',';
% eegfilename = './output/eeg/JH105sz4/JH105sz4_eeg.csv';
% patfilename = './data/patients/JH105sz4.csv';
% stepsize = 1;
% % addLeftFlank = 6000;
% addRightFlank = 2000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);

% % %JHU105sz5
% delimiter = ',';
% eegfilename = './output/eeg/JH105sz5/JH105sz5_eeg.csv';
% patfilename = './data/patients/JH105sz5.csv';
% stepsize = 1;
% addLeftFlank = 0;% addLeftFlank = 6000;
% addRightFlank = 3000;
% fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);


% 
% %JHU104sz1
% % delimiter = ',';
% % eegfilename = './output/eeg/JH104sz1/JH104sz1_eeg.csv';
% % patfilename = './data/patients/JH104sz1.csv';
% % stepsize = 1;
% % addLeftFlank = 4000;
% % addRightFlank = 4000;
% % fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% %JHU104sz2
% % delimiter = ',';
% % eegfilename = './output/eeg/JH104sz2/JH104sz2_eeg.csv';
% % patfilename = './data/patients/JH104sz2.csv';
% % stepsize = 1;
% % addLeftFlank = 5000;
% % addRightFlank = 4000;
% % fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% % %JHU104sz3
% % delimiter = ',';
% % eegfilename = './output/eeg/JH104sz3/JH104sz3_eeg.csv';
% % patfilename = './data/patients/JH104sz3.csv';
% % stepsize = 1;
% % addLeftFlank = 5000;
% % addRightFlank = 0;
% % fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% 
% 
% % UMMC009_sz1
% % delimiter = ',';
% % filename = './output/eeg/UMMC009_sz1/UMMC009_sz1_eeg.csv';
% % stepsize = 1;
% % addLeftFlank = 0;
% % addRightFlank = 12000;
% % fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% % UMMC009_sz2
% % delimiter = ',';
% % filename = './output/eeg/UMMC009_sz2/UMMC009_sz2_eeg.csv';
% % stepsize = 1;
% % addLeftFlank = 4000;
% % addRightFlank = 4000;
% % fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);
% % 
% % % UMMC009_sz3
% % delimiter = ',';
% % filename = './output/eeg/UMMC009_sz3/UMMC009_sz3_eeg.csv';
% % stepsize = 1;
% % addLeftFlank = 5000;
% % addRightFlank = 4000;
% % fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);

%% NOT DONE


% % UMMC007_sz2
% delimiter = ',';
% filename = './output/eeg/UMMC007_Sz2/UMMC007_Sz2_eeg.csv';
% stepsize = 1;
% addLeftFlank = 4000;
% addRightFlank = 12000;
% fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% % UMMC007_sz3
% delimiter = ',';
% filename = './output/eeg/UMMC007_Sz3/UMMC007_Sz3_eeg.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 4000;
% fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);

% UMMC008_sz1
% delimiter = ',';
% filename = './output/eeg/UMMC008_Sz1/UMMC008_Sz1_eeg.csv';
% stepsize = 0.25;
% addLeftFlank = 0;
% addRightFlank = 4000;
% fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);

% UMMC008_sz2
% delimiter = ',';
% filename = './output/eeg/UMMC008_Sz2/UMMC008_Sz2_eeg.csv';
% stepsize = 1;
% addLeftFlank = 13000;
% addRightFlank = 4000;
% fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);
% 
% % UMMC008_sz3
% delimiter = ',';
% filename = './output/eeg/UMMC008_Sz3/UMMC008_Sz3_eeg.csv';
% stepsize = 1;
% addLeftFlank = 5000;
% addRightFlank = 4000;
% fix_ummc_eeg(filename, delimiter, stepsize, addLeftFlank, addRightFlank);

%UMMC003_sz2
% delimiter = ',';
% filename = './output/eeg/UMMC003_sz2/UMMC003_sz2_eeg.csv';
% stepsize = 0.25;
% addFlank = 30000;
% fix_ummc_eeg(filename, delimiter, stepsize, addFlank);
% 
% %UMMC003_sz3
% % delimiter = ',';
% % filename = './output/eeg/UMMC003_sz3/UMMC003_sz3_eeg.csv';
% % stepsize = 0.25;
% % addFlank = 0;
% % fix_ummc_eeg(filename, delimiter, stepsize, addFlank);
% 
% 
% %UMMC004_sz1

% delimiter = ',';
% filename = 'UMMC004_sz1_eeg.csv';
% stepsize = 0.25;
% addFlank = 0;
% fix_ummc_eeg(filename, delimiter, stepsize, addFlank);


%
% delimiter = ',';
% filename = './output/eeg/UMMC005_sz2/UMMC005_sz2_eeg.csv';
% stepsize = 1;
% addFlank = 10000;
% fix_ummc_eeg(filename, delimiter, stepsize, addFlank);
% 
% 

