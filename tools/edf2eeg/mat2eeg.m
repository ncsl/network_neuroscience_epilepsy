function mat2eeg(path, name)

% Expects mat-file with variables: eeg, labels, time, date
load([path name '.mat']);

labels_file = [path '/' name '_labels.csv'];
labels_table = cell2table(labels','VariableNames',{'label'});
writetable(labels_table, labels_file);

eeg_file = [path '/' name '_eeg.csv'];
csvwrite(eeg_file, eeg);

end