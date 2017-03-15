clear all;
clc;

%%- READ IN FILE
delimiter = ',';
filename = './output/eeg/UMMC004_sz1/UMMC004_sz1_eeg.csv';
stepsize = 0.25; % get a certain specified frequency of the eeg data

M = dlmread(filename, delimiter); % read in the file data

% get points at specified steps
test = M(1:(1/stepsize):end, :);
[m,n] = size(test);

%%- INTERPOLATE BETWEEN THOSE STEPS 
% and output results
xq = 1:stepsize:m;
Mi = interp1(1:m, test, xq);
dlmwrite(filename, Mi, delimiter);

disp('done');