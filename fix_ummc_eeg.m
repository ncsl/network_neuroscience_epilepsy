%this function modifies all UMMC eeg files one by one
% Inputs: 
% - filename: is the csv filename of the eeg data to interpolate
% - delimiter: the delimiter (e.g. ',')
% - stepsize: the size to interpolate by (e.g. 0.5 for going from
% 500Hz->1000 Hz
% - addFlank: boolean to add flank or not
<<<<<<< HEAD
function fix_ummc_eeg(filename, delimiter, stepsize, addFlank)
    M = dlmread(filename, delimiter);
=======
function fix_ummc_eeg(eegfilename, patfilename, delimiter, stepsize, addLeftFlank, addRightFlank)
    %%- MODIFY EEG FILES
    M = dlmread(eegfilename, delimiter);
>>>>>>> 7e52329b0d2f8576055f2de5d988a798a4a8bf5d
    [m,n] = size(M); % m = time points, n = # channels
    
    % interpolate to 1000Hz
    xq = 1:stepsize:m;
    Mi = interp1(1:m, M, xq);
<<<<<<< HEAD
    
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
=======
    size(Mi)
    if addLeftFlank > 0
        A = Mi(1,:);
        B = ones(addLeftFlank,1);
        temp = kron(A,B);
        Mi = [temp; Mi];
        
        size(A)
        size(B)
        size(temp)
        size(Mi)
    end
    if addRightFlank > 0
        % append to the end
        A = Mi(end,:);
        B = ones(addRightFlank, 1);
        temp = kron(A, B);
        Mi = [Mi; temp];
    end
    size(Mi)
    dlmwrite(eegfilename, Mi, delimiter);
    disp('Done eeg file');
    
    %%- modify patient file
    %% Initialize variables.
    filename = patfilename;
    startRow = 2;

    %% Format string for each line of text:
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%s%{MM/dd/yyyy}D%{HH:mm:ss}D%{HH:mm:ss}D%{HH:mm:ss}D%f%f%s%[^\n\r]';

    %% Open the text file.
    fileID = fopen(filename,'r');

    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

    %% Close the text file.
    fclose(fileID);

    %% Allocate imported array to column variable names
    patient_id = dataArray{:, 1};
    date1 = dataArray{:, 2};
    recording_start = dataArray{:, 3};
    onset_time = dataArray{:, 4};
    offset_time = dataArray{:, 5};
    recording_duration = dataArray{:, 6};
    num_channels = dataArray{:, 7};
    included_channels = dataArray{:, 8};
    
    if (addLeftFlank > 0)
        onset_time = onset_time + seconds(addLeftFlank/1000);
        offset_time = offset_time + seconds(addLeftFlank/1000);
        recording_duration = recording_duration + (addLeftFlank/1000);
    end
    if (addRightFlank > 0)
        recording_duration = recording_duration + (addRightFlank/1000);
    end
    
    % just do a display to let you know what to change things to
    disp('New onset_time is: '); onset_time
    disp('New offset_time is: '); offset_time
    disp('New recording_duration is: '); recording_duration
>>>>>>> 7e52329b0d2f8576055f2de5d988a798a4a8bf5d
end