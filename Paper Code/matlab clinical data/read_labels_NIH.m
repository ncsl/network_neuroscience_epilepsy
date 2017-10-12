%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m-file: read_labels_NIH.m
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
if exist('infolabels_NIH.mat','file')
    delete('infolabels_NIH.mat');
end

% fill in the struct array
labels(1).subject  = 'pt1';
labels(1).onset    = {'PD1', 'PD2', 'PD3', 'PD4', 'AD1', 'AD2', 'AD3',...
    'AD4', 'ATT1', 'ATT2'};
labels(1).resection = {'ATT1', 'ATT2', 'ATT3', 'ATT4', 'ATT5', 'ATT6',...
    'ATT7', 'ATT8', 'AST1', 'AST2', 'AST3', 'AST4', 'PST1', 'PST2',...
    'PST3', 'PST4', 'AD1', 'AD2', 'AD3', 'AD4', 'PD1', 'PD2', 'PD3',...
    'PD4', 'PLT5', 'PLT6', 'SLT1'};


labels(2).subject  = 'pt2';
labels(2).onset    = {'PST1', 'PST2', 'PST3', 'PST4', 'AST1', 'AST2',...
    'MST1', 'MST2'};
labels(2).resection = {'G1', 'G2', 'G3', 'G4', 'G9', 'G10', 'G11',...
    'G12', 'G18', 'G19', 'G20', 'G26', 'G27', 'TT1', 'TT2', 'TT3',...
    'TT4', 'TT5', 'TT6', 'AST1', 'AST2', 'AST3', 'AST4', 'MST1',...
    'MST2', 'MST3', 'MST4'};

labels(3).subject  = 'pt3';
labels(3).onset   = {'OF1', 'OF2', 'OF3', 'OF4', 'OF5', 'OF6',...
    'MFF2', 'MFF3', 'IFP1', 'IFP2', 'IFP3', 'SFP1', 'SFP2', 'SFP3'};
labels(3).resection = {'FG1', 'FG2', 'FG9', 'FG10', 'FG17', 'FG18',...
    'FG25', 'SFP1', 'SFP2', 'SFP3', 'SFP4', 'SFP5', 'SFP6', 'SFP7',...
    'SFP7', 'SFP8', 'MFP1', 'MFP2', 'MFP3', 'MFP4', 'MFP5', 'MFP6',...
    'IFP1', 'IFP2', 'IFP3', 'IFP4', 'OF3', 'OF4'}; 


labels(4).subject  = 'pt6';
labels(4).onset   = {'LA1', 'LA2', 'LA3', 'LA4', 'LAH1', 'LAH2', 'LAH3',...
    'LAH4', 'LPH1', 'LPH2', 'LPH3', 'LPH4'};
labels(4).resection    = {};


labels(5).subject  = 'pt7';
labels(5).onset   = {'LFP3', 'MFP1', 'PT2', 'PT3', 'PT4', 'PT5', 'MT2',...
    'MT3', 'AT3', 'AT4', 'G29', 'G30', 'G39', 'G40', 'G45', 'G46'};
labels(5).resection    = {};


labels(6).subject  = 'pt8';
labels(6).onset   = {'MST3', 'MST4', 'G22', 'G23', 'G29', 'G30', 'G31',...
    'TO5', 'TO6'};
labels(6).resection    = {};


labels(7).subject  = 'pt10';
labels(7).onset   = {'TT1', 'TT2', 'TT3', 'TT4', 'TT5', 'TT6',... 
    'AST2', 'MST1', 'MST2'};
labels(7).resection    = {};


labels(8).subject  = 'pt11';
labels(8).onset   = {'RG24','RG32', 'RG39','RG40'};
labels(8).resection    = {};


labels(9).subject  = 'pt12';
labels(9).onset   = {'TT2', 'TT3', 'TT4', 'TT5', 'AST1', 'AST2'};
labels(9).resection    = {};


labels(10).subject  = 'pt13';
labels(10).onset   = {'FP1', 'FP2', 'FP9', 'FP10', 'FP17', 'FP18'};
labels(10).onset = {'G1', 'G2', 'G9', 'G10', 'G17', 'G18'};
labels(10).resection    = {};


labels(11).subject  = 'pt14';
labels(11).onset   = {'MST1', 'MST2', 'TT1', 'TT2', 'TT3', 'AST1', 'AST2'};
labels(11).resection    = {};


labels(12).subject  = 'pt15';
labels(12).onset   = {'TT1', 'TT2', 'TT3', 'TT4', 'MST1', 'MST2',...
    'AST1', 'AST2', 'AST3'};
labels(12).resection    = {};


labels(13).subject  = 'pt16';
labels(13).onset   = {'TT2', 'TT3', 'TT5', 'AST1'};
labels(13).resection    = {};


labels(14).subject  = 'pt17';
labels(14).onset   = {'TT1', 'TT2'};
labels(14).resection    = {};


% store the struct array in a .mat file
save('infolabels_NIH.mat','labels');

fprintf('The End\n');