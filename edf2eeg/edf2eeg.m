function edf2eeg(edf_path, output_path, trim_fn)

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
labels2csv(trim_fn(labels), [output_path '/' name '_labels.csv']);

eeg_file = [output_path '/' name '_eeg.csv'];
without_event_channel = trim_fn(eeg');
dlmwrite(eeg_file, without_event_channel, 'delimiter', ',', 'precision', '%.7f');

display(sprintf('Converted edf file in %fs\n', toc));

end