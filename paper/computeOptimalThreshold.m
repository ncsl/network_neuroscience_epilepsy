% reads in DOA excel files and computes the optimal threshold per patient
HOPPATS = {'PY04N007', 'PY04N008', 'PY04N012', 'PY04N013', 'PY04N015', ...
    'PY05N004', 'PY05N005', 'PY11N003', 'PY11N004', 'PY11N006', ...
    'PY12N005', 'PY12N008', 'PY12N010', 'PY12N012', 'PY13N001', ...
    'PY13N003', 'PY13N004', 'PY13N011', 'PY14N004', 'PY14N005'};

resultsDir = '/Users/adam2392/Dropbox/EZTrack/Hopkins patients data/results/';
resultsFile = '/Users/adam2392/Dropbox/EZTrack/Hopkins patients data/results/iEEG_all_CV_results_22-Jun-2015.mat';
data = load(resultsFile);

patients = fieldnames(data);
for iPat=1:length(patients)
    patient = patients{iPat};
    patData = data.(patient);
    
end