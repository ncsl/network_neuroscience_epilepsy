%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m-file: read_labels_UMMC.m
%
% Description: It stores in a struct array the following info for each
%              subject in the repository:
%               subject   - id of the subject;
%               onset     - labels of the channels used for SVD;
%               resection - labels of the focal channels;
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
if exist('infolabels_UMMC.mat','file')
    delete('infolabels_UMMC.mat');
end

% fill in the struct array
labels(1).subject  = 'UMMC001';
labels(1).onset   = {'GP12', 'GP13', 'GP18', 'GP19', 'GP20', 'GP21',...
    'GP27', 'GP28', 'GP29', 'GA7', 'GA14', 'GA21', 'GA22', 'F2'};
labels(1).resection    = {};


labels(2).subject  = 'UMMC002';
labels(2).onset   = {'AnT1', 'AnT2', 'AnT3', 'MesT1', 'MesT2', 'MesT3',...
    'MesT4', 'AT1', 'G17', 'G25'};
labels(2).onset = {'ATT1', 'ATT2', 'ATT3', 'MEST1', 'MEST2', 'MEST3', ...
    'MEST4', 'GRID17', 'GRID25'};
labels(2).resection    = {};


labels(3).subject  = 'UMMC003';
labels(3).onset   = {'MesT3', 'MesT4', 'MesT5', 'G4', 'G5', 'G10', 'G12', 'G18',...
    'G19', 'G20', 'G26', 'G27', 'G28', 'AT3'};
labels(3).onset = {'MEST3', 'MEST4', 'MEST5', 'GRID4', 'GRID5', 'GRID10', 'GRID12', 'GRID18', ...
    'GRID19', 'GRID20', 'GRID26', 'GRID27', 'GRID28', 'ANT3'};
labels(3).resection    = {};


labels(4).subject  = 'UMMC004';
labels(4).onset   = {'AT1', 'G1', 'G9', 'G10', 'G17', 'G18'};
labels(4).onset = {'AT1', 'GRID1', 'GRID9', 'GRID10', 'GRID17', 'GRID18'};
labels(4).resection    = {};


labels(5).subject  = 'UMMC005';
labels(5).onset   = {'AT1', 'AT2', 'AT3', 'AT4', 'AT5', 'AT6', 'G1',...
    'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8', 'G9', 'G10', 'G11', 'G12',...
    'G13', 'G14', 'G15', 'G16', 'G17', 'G19', 'G25', 'G27'};
labels(5).resection    = {};


labels(6).subject  = 'UMMC006';
labels(6).onset   = {'MT2', 'MT3', 'MT4', 'Mes1', 'Mes2', 'Mes3', 'Mes4',...
    'Mes5', 'MAT1', 'MAT2',...
    'Mes1', 'Mes2', 'Mes3', 'Mes4', 'MT2', 'G3', 'G11', 'G12', 'PT3'};
labels(6).onset = {'MT2', 'MT3', 'MT4', 'MEST1', 'MEST2', 'MEST3', 'MEST4', ...
    'MEST5', 'MT1', 'G3', 'G11', 'G12', 'POST3'};
labels(6).resection    = {};


labels(7).subject  = 'UMMC007';
labels(7).onset   = {'LMT1', 'LMT2', 'LMT3', 'LMT4', 'RMT1', 'RPT3',...
    'RPT4', 'RPT5', 'RAT1', 'RAT2', 'RAT3', 'RAT4', 'LPT3', 'LMT1',...
    'LMT2', 'LAT4', 'LAT5'};
labels(7).onset = {'LMES1', 'LMES2', 'LMES3', 'LMES4', 'RMES1', 'RPT3', ...
    'RPT4', 'RPT5', 'RANT1', 'RANT2', 'RANT3', 'RANT4', 'LPT3', ...
    'LANT4', 'LANT5'};
labels(7).resection    = {};


labels(8).subject  = 'UMMC008';
labels(8).onset   = {'G1', 'G2', 'G3', 'G4', 'G5', 'G9', 'G10', 'G11',...
    'G12', 'G13', 'G17', 'G18', 'G19', 'G20', 'G21','AT1', 'AT2', 'AT3',...
    'AT4', 'MT1', 'MT2', 'MT3', 'MT4'};
labels(8).onset = {'GRID1', 'GRID2', 'GRID3', 'GRID4', 'GRID5', 'GRID9', 'GRID10', 'GRID11',...
    'GRID12', 'GRID13', 'GRID17', 'GRID18', 'GRID19', 'GRID20', 'GRID21', 'AT1', 'AT2', 'AT3', ...
    'AT4', 'MT1', 'MT2', 'MT3', 'MT4'};
labels(8).resection    = {};


labels(9).subject  = 'UMMC009';
labels(9).onset   = {'G1', 'G3', 'G4', 'G5', 'G6', 'G7', 'G12', 'G13', ...
    'G14', 'G21', 'G29', 'AT1', 'AT2', 'AT3', 'PT1', 'PT2'};
% labels(9).onset = {'G4', 'G5', 'G6', 'G7', 'G12', 'G14', 'PT1', 'AT1'};
labels(9).resection    = {};



% store the struct array in a .mat file
save('infolabels_UMMC.mat','labels');

fprintf('The End\n');