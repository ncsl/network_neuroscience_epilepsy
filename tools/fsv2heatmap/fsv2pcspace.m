function fsv2pcspace

eztrack_home = [getenv('HOME') '/dev/eztrack/tools'];

fsv_path = [eztrack_home '/output/fsv'];
patient_info = load([eztrack_home '/data/patient_info.mat']);
list_of_patients = {'PY04N007';'PY04N012';'PY04N013';'PY04N015';'PY05N005';'PY11N003';'PY11N006';...
                    'PY12N005';'PY12N008';'PY12N010';'PY12N012';'PY13N003';'PY13N011';'PY14N004';...
                    'PY14N005'};

all_patient_ids = fieldnames(patient_info);

% Get the index vector into the patient data that matches the list of patients.
[~,patient_indexes,~] = intersect(all_patient_ids, list_of_patients);

% step 1: Select one patient as a test and use the rest as a training set
% Building without PY12N008 so we can classify in a manner consistent with the
% retrospective study.
cellfind = @(string)(@(cell_contents)(strcmp(string, cell_contents)));
test_patient_id = find(cellfun(cellfind('PY12N008'), all_patient_ids), 1);

% step 2: passing the training set for PC analysis and projecting test set
% on the 2D space defined by training set
points = pcspace(fsv_path, patient_info, patient_indexes, test_patient_id);   

save([eztrack_home '/output/heatmap/points.mat'], '-struct', 'points');

end

