% Small utility to convert old-style EZTrack .mat files to new csv format.

% To process multiple files for the same patient...
%
% files = {'PY12N008_07_21_2012_14-05-48_640sec'...
%          'PY12N008_07_21_2012_14-53-23_672sec',...
%          'PY12N008_07_22_2012_13-15-41_737sec',...
%          'PY12N008_07_23_2012_08-41-30_729sec'};


patient = 'convert';
path = [getenv('HOME') '/dev/eztrack/data/reference/' patient '/'];

files = {'PY13N011_08_20_2013_13-18-23_658sec',...
         'PY14N004_05_11_2014_10-20-35_734sec'};
     
parpool;
parfor i = 1:length(files)
    mat2eeg(path, files{i});
end
delete(gcp('nocreate'));
