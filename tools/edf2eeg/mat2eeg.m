function mat2eeg(path, name)

% Expects mat-file with variables: eeg, labels, time, date
load([path name '.mat']);

labels2csv(labels, [path '/' name '_labels.csv']);

eeg_file = [path '/' name '_eeg.csv'];
dlmwrite(eeg_file, eeg', 'delimiter', ',', 'precision', '%.7f');

end