function edf2eeg(edf_path, output_path)

% TODO: Verify that edf_path exists.

[path,name,ext] = fileparts(edf_path);

tic
display(sprintf('Converting %s', edf_path));
[header, data] = edfread(edf_path);

eeg = single(data);
labels = header.label;
time = header.starttime;
date = header.startdate;

warning('off','MATLAB:MKDIR:DirectoryExists');
mkdir(output_path);

display(sprintf('Writing labels and eeg as csv to %s', output_path));
labels2csv(labels, [output_path '/' name '_labels.csv']);

eeg_file = [output_path '/' name '_eeg.csv'];
dlmwrite(eeg_file, eeg', 'delimiter', ',', 'precision', '%.7f');

display(sprintf('Converted edf file in %fs\n', toc));

% EZTrack originally required .mat files in eeg2fsv...
% save([output_path name '.mat'],'eeg','labels','time','date','-v7.3');
end