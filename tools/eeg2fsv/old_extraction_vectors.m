%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m-file: extraction_vectors.m
%
% Description: It reads the singular vectors for each computed adjacency
%              matrix and extracts one specific singular vector. Then, the
%              sequence of extracted vectors is stored in a *.mat file.
%
%
%
% Author: S. Santaniello
% Modified by: B. Chennuri
%
% Ver.: 4.0 - Date: 12/18/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
addpath(genpath('/home/bhaskar/Documents/MATLAB/read_data'));


% size of the adjacency matrices to be used. Options are:
%
%   sq = square matrices;
%   ns = non-square matrices
siz = 'sq';

% type of adjacency matrix to be used. Options are:
%
%   chr = coherence-based matrix;
%   pwr = power spectrum-based matrix
feat = 'pwr';

% specific singular vector to be extracted for each matrix
svec = 1;

% load the list of subjects and the correspondent time references (in s)
id = {'PY12N005', 'PY12N008', 'PY12N010', 'PY12N012', 'PY13N001',...
    'PY13N003', 'PY13N004', 'PY13N010', 'PY13N011', 'PY14N004', 'PY14N005'};


% for each subject...
for i=1:length(id)
    
    % print out useful info on the screen
    fprintf('Subject %s...\n',id{i});
    
    % set the number of recording channels actually used for the
    % computation of the SVD.
    switch id{i}
        case 'PY04N007', nchmax = 86;
        case 'PY04N008', nchmax = 40;
        case 'PY04N012', nchmax = 82;
        case 'PY04N013', nchmax = 83;
        case 'PY04N015', nchmax = 92;
        case 'PY05N004', nchmax = 94;
        case 'PY05N005', nchmax = 110;
        case 'PY11N003', nchmax = 117;
        case 'PY11N004', nchmax = 112;
        case 'PY11N006', nchmax = 65;
        case 'PY12N005', nchmax = 105; events = [1,7];
        case 'PY12N008', nchmax = 87; events = [1:4,6];
        case 'PY12N010', nchmax = 109; events = [1,3:8,10,11];
        case 'PY12N012', nchmax = 109; events = [2,3,4];
        case 'PY13N001', nchmax = 128; events = [3,5:7,12];
        case 'PY13N003', nchmax = 140; events = [1,3];
        case 'PY13N004', nchmax = 141; events = [1,3,5:11];
        case 'PY13N010', nchmax = 114; events = [1,2,4,5];
        case 'PY13N011', nchmax = 84; events = [1,2];
        case 'PY14N004', nchmax = 67; events = [2,3];
        case 'PY14N005', nchmax = 88; events = [1:4,6:16];
    end
    
    path0 = sprintf('/media/ExtHDD01/%s/adj_pwr/svd_vectors',id{i});
    
    listing = dir(sprintf('/media/ExtHDD01/%s/adj_pwr/svd_vectors', id{i}));
    
    % for each file...
    tmp_events = [];
    count = 1;
    for j = 1:numel(listing)
        % for each frequency band of interest....
        for dd = {'gamma'} %{'alpha','beta','gamma'}
            
            if ~isempty(strfind(listing(j).name, sprintf('%s', cell2mat(dd))))
                tmp_events =  cat(2, tmp_events, j);
            end
        end
    end

    for j = tmp_events(events)
        % read the source singular vectors
        tmp = read_svd_matrix(sprintf('%s/%s',path0,listing(j).name),nchmax);
        data = zeros(size(tmp,2),size(tmp,1));
        for q=1:size(tmp,1), data(:,q) = tmp(q,:,svec)'; end
        
        % store the extracted vectors into a struct
        eval([sprintf('snap%d_%s',count, cell2mat(dd)), ' = data;']);
        
        % save the struct arrays into a *.mat file
        if(~exist(sprintf('/home/bhaskar/Dropbox/EZTrack/Hopkins patients data/fsv_%s%s.mat', feat,id{i}),'file'))
            save(sprintf('/home/bhaskar/Dropbox/EZTrack/Hopkins patients data/fsv_%s%s.mat', feat,id{i}), sprintf('snap%d_%s',count, cell2mat(dd)));
        else
            save(sprintf('/home/bhaskar/Dropbox/EZTrack/Hopkins patients data/fsv_%s%s.mat', feat,id{i}),sprintf('snap%d_%s',count, cell2mat(dd)),'-append');
        end
        
        count = count + 1;
        clear data tmp snap*        
    end
    clear nchmax tmp_events
end
fprintf('The End\n');
