% Function: threshold_inclusion
% By: Adam Li
% Description:
% 
% Pass in the weights of EZTrack results and the thresholds to pass back an
% array of included_indices X thresholds.
% 
% Input:
% - weights:
% - thresholds: 
%
% Output:
% - included_indices: is a 2D matrix with indices (0's and 1's) X
% thresholds
%
function included_indices = threshold_inclusions(weights, thresholds)
    included_indices = zeros(length(weights), length(thresholds));
    for i=1:length(thresholds)
        threshold = thresholds(i);
       
        indices = find(weights > threshold);
        
        included_indices(indices, i) = 1;
    end
end