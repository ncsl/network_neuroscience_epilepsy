home = getenv('HOME');
eegHome = '/dev/eztrack/tools/data/edf';
patient = 'PY13N003';
file = '/PY13N003_02_12_2013_00-25-39_701sec.edf';
eegPath = [home eegHome patient file];

% TODO: Verify that the file exists.

[header, data] = edfread(eegPath);

% data = single(data);
% elec_labels = hdr.label;
% time = hdr.starttime;
% date = hdr.startdate;
% mat_path = [hd_path pat '/'];
% save([mat_path file_s '.mat'],'data','elec_labels','time','date','-v7.3')
% %delete_edf_command = sprintf(['rm' file_path]);
% if exist([hd_path pat '/' file_s '.mat'],'file') == 2
%     %if exist([hd_path pat '/' regexprep(files(i).name),'.edf','.mat'],'file') == 1
%     %s = system(delete_edf_command);
%     delete(file_path)
%     display([[hd_path pat '/' file_s '.mat'] ' has been created.'])
% else
%     display('.mat file doesnt exist. EDF not deleted.')
% 
% end

