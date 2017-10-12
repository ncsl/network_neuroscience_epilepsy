%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m-file: read_labels_JHU.m
%
% Description: It stores in a struct array the following info for each
%              subject in the repository:
%              subject   - id of the subject;
%              onset     - labels of the onset channels;
%              resection - labels of the resection channels;
%
%              The struct array is stored in a .mat file. Note that, for
%              those subjects for which the number of raw channels varies
%              across the days, only the map of the channels during the day
%              of seizures is stored.
%
%
%
% Author: B. Chennuri
%   
% Ver.: 1.0 - Date: 05/28/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
filename = 'infolabels_JHU.mat';
if exist(filename,'file')
    delete(filename);
end

% fill in the struct array
labels(1).subject  = 'jh101';
labels(1).onset    = {'POLLAT1', 'POLLAT2', 'POLLAT6', 'POLLAT7',...
                    'POLLAH6'};
labels(1).resection = {};


labels(2).subject  = 'jhu102';
labels(2).onset    = {'POLRAT1', 'POLRAT2', 'POLLBT1', 'POLLBT2', 'POLLBT3', ...
                'POLLAT3'};
labels(2).resection = {};

labels(3).subject  = 'jhu103';
labels(3).onset   = {'POLRTG48', 'POLRTG40', 'POLRAD1', 'POLRAD2', 'POLRAD3', ...
                    'POLRAD4', 'POLRAD5', 'POLRAD6', 'POLRAD7', 'POLRAD8', ...
                    'POLRHD1', 'POLRHD2', 'POLRHD3', 'POLRHD4', 'POLRHD5', ...
                    'POLRHD6', 'POLRHD7', 'POLRHD8', 'POLRHD9'};
labels(3).resection = {}; 


labels(4).subject  = 'jhu104';
labels(4).onset   = {'POLLAT1', 'POLLAT2', ...
    'POLMBT5', 'POLMBT6', 'POLMBT4', 'POLPBT4'};
labels(4).resection    = {};


labels(5).subject  = 'jhu105';
labels(5).onset   = {'POLRPG4', 'POLRPG5', 'POLRPG12', 'POLRPG13', 'POLG14',...
            'POLRPG20','POLRPG21', ...
            'POLAPD1', 'POLAPD2', 'POLAPD3', 'POLAPD4', 'POLAPD5', 'POLAPD6', 'POLAPD7', 'POLAPD8', ...
            'POLPPD1', 'POLPPD2', 'POLPPD3', 'POLPPD4', 'POLPPD5', 'POLPPD6', 'POLPPD7', 'POLPPD8', ...
            'POLASI3', 'POLPSI5', 'POLPSI6'};
labels(5).resection    = {};

labels(6).subject  = 'jhu106';
labels(6).onset   = {'POLPBT1', 'POLPBT2', 'POLPBT3', 'POLPTO2', 'POLPTO3', ...
            'POLPTO4', 'POLLHD7', 'POLLHD8'};
labels(6).resection    = {};


labels(7).subject  = 'jhu107';
labels(7).onset   = {'POLRAT3', 'POLRAT4', 'POLRATI13', 'POLRATI14', ...
        'POLRATI15', 'POLRATI16', 'POLRATI5', 'POLRATI6', 'POLRATI7', 'POLRATI8'};
labels(7).resection    = {};


% store the struct array in a .mat file
save(filename,'labels');

fprintf('The End\n');