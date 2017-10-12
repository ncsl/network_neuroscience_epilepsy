function [ D ] = DOA(EEZ, CEZ, ALL, metric, args)
% #########################################################################
% Function Summary: Computes statistic (DOA = Degree of Agreement) indicat-
% ing how well EEZ (from EpiMap) and CEZ (clinical ezone) agree. 
% 
% Inputs:
%   EEZ: cell with EpiMap's predicted ezone labels
%   CEZ: cell with clinically predicted ezone labels 
%   ALL: cell with all electrode labels
%   metric: (optional) string argument of
%       - Jaccard index
%       - Sorensen's coefficient
%       - DOA (default) from R01 grant
%   
% Output: 
%   DOA: (#CEZ intersect EEZ / #CEZ) / (#NOTCEZ intersect EEZ / #NOTCEZ)
%   Value between -1 and 1, Computes how well CEZ and EEZ match. 
%   < 0 indicates poor match.
% 
% Author: Kriti Jindal, NCSL 
% - Edited by: Adam Li
% Last Updated: 02.22.17
%   
% #########################################################################
    %% Argument Management
    % arg 4 is optional
    if nargin < 4
        metric = 'default';
    elseif nargin == 4
        if ~(strcmp(lower(metric), 'default') || strcmp(metric, 'jaccard') || ...
                strcmp(metric, 'sorensen') || strcmp(metric, 'tversky'))
            errormsg = 'Metric is incorrect.\n Enter "default", or "jaccard".';
            error('DOA:incorrectInput', errormsg);
        end
    end
    
    % if tversky index, make sure alpha and beta are defined
    if strcmp(metric, 'tversky') 
        if isfield(args, 'alpha') && isfield(args, 'beta')
            alpha = args.alpha;
            beta = args.beta;
        else
            errormsg = 'Must define alpha and beta constants >= 0 for Tversky Index.';
            error('DOA:provideParameters', errormsg);
        end
    end

    %% Compute Degree of Agreement
    % finds appropriate set intersections to plug into DOA formula 
    if strcmp(lower(metric), 'default')
        NotCEZ = setdiff(ALL, CEZ);
        CEZ_EEZ = intersect(CEZ, EEZ);
        NotCEZ_EEZ = intersect(NotCEZ, EEZ);

        term1 = length(CEZ_EEZ) / length(CEZ);
        term2 = length(NotCEZ_EEZ) / length(NotCEZ);

        D = term1 - term2;
    elseif strcmp(metric, 'jaccard')
        CEZ_EEZ = intersect(CEZ, EEZ); % set in intersection
        CEZandEEZ = union(CEZ, EEZ);   % set in union

        % find Jaccard index
        D = length(CEZ_EEZ) / length(CEZandEEZ);
    elseif strcmp(metric, 'sorensen')
        CEZ_EEZ = intersect(CEZ, EEZ);
        
        % find Sorensen coefficient
        D = 2*length(CEZ_EEZ) / (length(CEZ) + length(EEZ));
    elseif strcmp(metric, 'tversky')
        CEZ_EEZ = intersect(CEZ, EEZ);
        CEZEEZ_C = setdiff(CEZ, EEZ);
        EEZCEZ_C = setdiff(EEZ, CEZ);
        
        a = min(length(CEZEEZ_C), length(EEZCEZ_C));
        b = max(length(CEZEEZ_C), length(EEZCEZ_C));
        
        % compute tversky index
%         D = length(CEZ_EEZ) / (length(CEZ_EEZ) + alpha*length(CEZEEZ_C) + beta*length(EEZCEZ_C));
        D = length(CEZ_EEZ) / (length(CEZ_EEZ) + beta*(alpha*a + (1-alpha)*b));
    end
end