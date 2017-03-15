%UMMC001_sz2
% delimiter = ',';
% M = dlmread('UMMC001_sz2_eeg.csv', delimiter);
% [m,n] = size(M);
% 
% %interpolate to make 1KHz from 500Hz
% xq = 1:0.5:m;
% Mi = interp1(1:m, M, xq);
% %add left flank to make 61 seconds pre seizure onset - just to bekron
% %safe..have to add 48 seconds or 48000 rows in beginning of EEG
% % A = Mi(1,:);
% % B = ones(48000,1);
% % temp = kron(A,B);
% % Mi = [temp; Mi];
% dlmwrite('UMMC001_sz2_eeg.csv',Mi,delimiter)
% clear all

%UMMC004_sz1
% delimiter = ',';
% filename = 'UMMC004_sz1_eeg.csv';
% stepsize = 0.25;
% addFlank = 0;
% fix_ummc_eeg(filename, delimiter, stepsize, addFlank);

%
delimiter = ',';
filename = './output/eeg/UMMC005_sz2/UMMC005_sz2_eeg.csv';
stepsize = 1;
addFlank = 10000;
fix_ummc_eeg(filename, delimiter, stepsize, addFlank);


%UMMC001_sz3
delimiter = ',';
M = dlmread('UMMC001_sz3_eeg.csv', delimiter);
[m,n] = size(M);

%interpolate to make 1KHz from 500Hz
xq = 1:0.5:m;
Mi = interp1(1:m, M, xq);
%add left flank to make 61 seconds pre seizure onset - just to bekron
%safe..have to add 48 seconds or 48000 rows in beginning of EEG
% A = Mi(1,:);
% B = ones(48000,1);
% temp = kron(A,B);
% Mi = [temp; Mi];
dlmwrite('UMMC001_sz3_eeg.csv',Mi,delimiter)
clear all

%UMMC002_sz1
M = dlmread('UMMC002_sz1_eeg.csv', delimiter);
[m,n] = size(M);
%interpolate to make 1KHz from 500Hz
xq = 1:0.5:m;
Mi = interp1(1:m, M, xq);
dlmwrite('UMMC002_sz1_eeg.csv',Mi,delimiter)
clear all

%UMMC002_sz2
M = dlmread(UMMC002_sz2_eeg.csv, delimiter);
[m,n] = size(M);
%interpolate to make 1KHz from 500Hz
xq = 1:0.5:m;
Mi = interp1(1:m, M, xq);
%add left flank to make 61 seconds pre seizure onset - just to bekron
%safe..have to add 48 seconds or 48000 rows in beginning of EEG
A = Mi(1,:);
B = ones(48000,1);
temp = kron(A,B);
Mi = [temp; Mi];
dlmwrite(UMMC002_sz2_eeg.csv,Mi,delimiter)
clear all

%UMMC002_sz3
% M = dlmread(UMMC002_sz3_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 500Hz
% xq = 1:0.5:m;
% Mi = interp1(1:m, M, xq);
% %add left flank to make 61 seconds pre seizure onset - just to bekron
% %safe..have to add 44 seconds or 44000 rows in beginning of EEG
% A = Mi(1,:);
% B = ones(44000,1);
% temp = kron(A,B);
% Mi = [temp; Mi];
% dlmwrite(UMMC002_sz2_eeg.csv,Mi,delimiter)
% clear all
% 
% 
% %%UMMC003_sz1
% M = dlmread(UMMC003_sz1_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 250Hz
% xq = 1:0.25:m;
% Mi = interp1(1:m, M, xq);
% dlmwrite(UMMC003_sz1_eeg.csv,Mi,delimiter)
% clear all
% 
% %%UMMC003_sz2
% M = dlmread(UMMC003_sz2_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 250Hz
% xq = 1:0.25:m;
% Mi = interp1(1:m, M, xq);
% %add left flank to make 61 seconds pre seizure onset - just to bekron
% %safe..have to add 15 seconds or 15000 rows in beginning of EEG
% A = Mi(1,:);
% B = ones(15000,1);
% temp = kron(A,B);
% Mi = [temp; Mi];
% dlmwrite(UMMC003_sz2_eeg.csv,Mi,delimiter)
% clear all
% 
% 
% %%UMMC003_sz3
% M = dlmread(UMMC003_sz3_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 250Hz
% xq = 1:0.25:m;
% Mi = interp1(1:m, M, xq);
% dlmwrite(UMMC003_sz3_eeg.csv,Mi,delimiter)
% clear all
% 
% 
% %%UMMC004_sz1
% M = dlmread(UMMC004_sz1_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 250Hz
% xq = 1:0.25:m;
% Mi = interp1(1:m, M, xq);
% dlmwrite(UMMC004_sz1_eeg.csv,Mi,delimiter)
% clear all
% 
% %%UMMC004_sz2
% M = dlmread(UMMC004_sz2_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 250Hz
% xq = 1:0.25:m;
% Mi = interp1(1:m, M, xq);
% dlmwrite(UMMC004_sz2_eeg.csv,Mi,delimiter)
% clear all
% 
% %%UMMC004_sz3
% M = dlmread(UMMC004_sz3_eeg.csv, delimiter);
% [m,n] = size(M);
% %interpolate to make 1KHz from 250Hz
% xq = 1:0.25:m;
% Mi = interp1(1:m, M, xq);
% dlmwrite(UMMC004_sz3_eeg.csv,Mi,delimiter)
% clear all
% 
% 
% %%UMMC005_sz2
% M = dlmread(UMMC005_sz2_eeg.csv, delimiter);
% [m,n] = size(M);
% %add left flank to make 61 seconds pre seizure onset - just to bekron
% %safe..have to add 10 seconds or 10000 rows in beginning of EEG
% A = M(1,:);
% B = ones(10000,1);
% temp = kron(A,B);
% M = [temp; M];
% dlmwrite(UMMC005_sz2_eeg.csv,M,delimiter)
% clear all
