function a = ranking(x, mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function: ranking
%
%Description: Ranking sorts and assigns positive integer values (1-n) to
%             first singular vectors as ranks either in ascending or
%             descending order. For vectors, ranking(X, mode) ranks the
%             elements of X according to mode. For matrices, ranking(X,
%             mode) ranks each column of X according to mode. This function
%             is invoked by electrode_PCspace.m and other related functions
%
%Input:       This function has two inputs
%             X = vector or matrix of fsv time series.
%             This must be a numeric input.
%             mode = 'ascend' or 'descend' to define the ranking. In ascend
%             mode the lowest component gets a rank of 1. In descend mode
%             the highest component gets a rank of 1.
%             This input must be a string
%
%Output:      Ouput is a ranked vector or matrix.
%
%Author:      Bhaskar Chennuri
%Version:     1.0
%Date:        10/10/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
[s, i] = sort(x, mode);
a = zeros(size(s));

for m = 1:size(a, 1) % loop through channels
   for n = 1:size(a, 2),  % loop through windows
       a(m, n) = find(i(:,n) == m ); 
   end
end

end