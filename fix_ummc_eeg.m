%this function modifies all UMMC eeg files one by one
% Inputs: 
% - filename: is the csv filename of the eeg data to interpolate
% - delimiter: the delimiter (e.g. ',')
% - stepsize: the size to interpolate by (e.g. 0.5 for going from
% 500Hz->1000 Hz
% - addFlank: boolean to add flank or not
function fix_ummc_eeg(filename, delimiter, stepsize, addFlank)
    M = dlmread(filename, delimiter);
    [m,n] = size(M); % m = time points, n = # channels
    
    % interpolate to 1000Hz
    xq = 1:stepsize:m;
    Mi = interp1(1:m, M, xq);
    
    %append to beginning
         if addFlank > 0
        A = Mi(1,:);
        B = ones(addFlank,1);
        temp = kron(A,B);
        Mi = [temp; Mi];
end
        % append to the end
        A = Mi(end,:);
        B = ones(addFlank, 1);
        temp = kron(A, B);
        Mi = [Mi; temp];
    end
    
    dlmwrite(filename, Mi, delimiter);
end