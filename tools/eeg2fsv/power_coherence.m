function power_coherence(pathval, filename, num_channels, fs, sample_to_access)

% Description: This function computes the cross-power among iEEG recordings from
%              independent channels. Power spectra are evaluated in
%              specific frequency bands. The iEEG recordings are extracted
%              from a *.mat file whose name and home directory are provided
%              along with the data format. A pointer to the first sample to
%              be accessed and the # of independent channels to be used are
%              also provided.
%
%              The sampling rate of the input is specified by the user.
%              Spectra are computed over a sliding window (2.5s-long, 1.5s-long overlap) 
%              with Welch's method i.e., each  window of data is divided into 1s-long 
%              sub-sections (750ms overlap) and the power is averaged across the sub-sections. 
%              The frequency fs is used as the number of points of the fft.
%              Power spectra fill band-specific connectivity matrices, which are stored in *.dat file.
%             
% Input:    pathval      - Path to the directory where the destination and
%                          source files are stored. It must be a string of
%                          characters.
%
%           filename     - Name of the *.mat file where the iEEG recordings
%                          are extracted from. It must be a string of
%                          characters.
%
%           num_channels - Number of independent iEEG channels to be used.
%                          It must be a positive integer.
%
%           fs           - Sampling frequency (in Hz). It must be positive.
%
%           sample_to_access  - pointer to the last second of data accessed
%                             (counted from 0), i.e., the first byte to-be-
%                             extracted is in position pos x num_channels x
%                             #-samples-per-second x #-bytes-per-sample + 1.
%                             It must be a nonnegative integer.
%
% Output:   no output returned.
%
% NOTE: Power spectra estimated for a given window of data in a given frequency 
%       band are stored in a 1-D array. Denoted with 1... n the iEEG channels, 
%       the cross-power between each pair of channels is stored according to the 
%       following rule:
%
%        - array position: 1  2...  n n+1 n+2  2n-1 2n ... 3n-2... n(n+1)/2
%        - channel pair:  11 22... nn  12  13... 1n 23 ...   2n...   (n-1)n
%
%       Values estimated for consecutive windows are added to a 2-D array by row.
%
% Author: S. Santaniello
% Modified by: B. Chennuri
%
% Ver.: 5.0 - Date: 05/01/2015
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% validate inputs
%--------------------------------------------------------------------------
if (nargin < 5)
    error('Error: no enough input');
end

if (isempty(pathval) || ~ischar(pathval) || ~isdir(pathval))
    error('Error: path is not a valid directory');
end

eeg_filename = sprintf('%s/%s', pathval, filename);
if (isempty(filename) || ~ischar(filename) || ~exist(eeg_filename,'file'))
    error('Error: Could not open %s', eeg_filename);
end

% check if the file is corrupted and extract the length of the file (in number of bytes)
% eeg_file = load(eeg_filename);
eeg_file = csvread(eeg_filename);

% Given a file with 89 rows (channels) and 640000 columns (signals),
% eeg_file is now a 56960000x1 vector that we need to reshape.
cols = length(eeg_file) / num_channels;
eeg = reshape(eeg_file,cols,num_channels)';

file_length = length(eeg);
if (file_length == 0)
    error('Error: File missing eeg data'); 
end

% TODO: Remove the file if it exists.
if ~exist(sprintf('%s/adj_pwr', pathval), 'dir')
    mkdir(sprintf('%s', pathval), 'adj_pwr');
end

[~,basename,~] = fileparts(eeg_filename);

output_file = fopen(sprintf('%s/adj_pwr/adj_pwr_%s_gamma.dat', pathval, basename), 'wb');

% frequency bands (in Hz) used during the computation of the connectivity matrices
% conventional frequencies corresponding to the bands below:
% {'delta';'theta';'alpha';'beta';'gamma'};
bands = [0 4; 4 8; 8 13; 13 30; 30 90];
% EZTrack only uses the gamma band
gamma = bands(5,:);

if (isempty(num_channels) || ~isreal(num_channels) || length(num_channels)>1 || num_channels<1)
    error('Error: Invalid number of recording channels');
end
num_channels = round(num_channels);

if (isempty(fs) || ~isreal(fs) || length(fs)>1 || fs<1)
    error('Error: sampling frequency not valid');
end
fs = round(fs);

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% initialize the environment variables
%--------------------------------------------------------------------------
% notch filter (stop frequency: 60Hz; stop-band: 4Hz)
% represented by a transfer function: polynomial / polynomial
% continuous second-order equations, in this case.
if (fs==1000)
    % sampling frequency: 1000Hz). Note that the filter induces a transient
    % oscillation of about 400 samples which must be removed from the data
    dennotch = [1 -1.847737249430546 0.987291867964730];
    numnotch = [0.993645933982365 -1.847737249430546 0.993645933982365];
elseif (fs==200)
    % sampling frequency: 200Hz). Note that the filter induces a
    % transient oscillation of about 100 samples which must be removed
    % from the data 
    dennotch = [1 0.598862049930572 0.937958302720205];
    numnotch = [0.968979151360102 0.598862049930572 0.968979151360103];
else
    error('Error: notch filter not available');
end

% max number of samples per channel to be extracted
sliding_window_overlap = 2.5;
nsamples = round(sliding_window_overlap * fs);

% step size of the sliding horizon (in s)
stepwin = 1;

% set the window function for the periodograms
% TODO: Sabatino chose these parameters in his research
% based on periodigrams and a modified FFT.
convwin = 0.54 - 0.46 * cos((2*pi*(1:fs)) / (fs-1)); 
convwin = convwin(:);

% set the range of frequencies for the periodograms (Hz)
freq_range = (fs/2) .* linspace(0,1,fs/2);

% set the step size for the sub-sections (number of samples)
stepsize = round(fs/4);

% set the pointer to the last byte before the one to be accessed now
lastwindow = 0;

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% main loop
%--------------------------------------------------------------------------
tic
limit = fix((file_length - (nsamples-stepwin*fs)) / (stepwin*fs));

while (sample_to_access < limit)
    
    % step 0: check if the current pointer is the offset or not. If it is
    %         the offset then the transient response induced by the notch 
    %         filter cannot be attenuated. Otherwise, extract max 400 extra
    %         samples of data before the required samples
    if lastwindow
        tmpwindow = 400;
    else 
        tmpwindow = 0;
    end
    
    % step 1: extract the data and apply the notch filter. Note that column
    %         #i in the extracted matrix is filled by data samples from the
    %         recording channel #i.
    tmpdata = eeg(:, (lastwindow - tmpwindow) + 1:lastwindow + nsamples );
    tmpdata = filtfilt(numnotch,dennotch,tmpdata');
    data = tmpdata(tmpwindow + 1:end,:);
    
    % step 2: pre-process the data. For each channel, subtract the mean
    %         value and divide by the standard deviation. Note that this
    %         step NORMALIZES the data
    data = data - repmat(mean(data,1),size(data,1),1);
    data = data ./ repmat(std(data,[],1),size(data,1),1);
    data(isnan(data)) = 0;
    
    % step 3: split the data into overlapping sub-sections
    nsections = ceil((size(data,1)-(fs-stepsize))/stepsize);
    
    % step 4: compute the cross-power spectra
    cross_power = zeros(fs/2, num_channels*(num_channels+1)/2);
    
    for i=1:nsections
        % ... extract the current sub-section
        datasec = data((i-1) * stepsize+1:min((i-1) * stepsize+fs, size(data,1)),:);
        
        if (sum(sum(abs(datasec))) == 0)
            % ... avoid computation if the data are all zeros
            continue;
        end
            
        % ... compute the fft. Note: size(X) = (fs/2) x #-of-channels
        X = fft(repmat(convwin(1:min(fs, size(datasec,1))), 1, num_channels) .* datasec, fs); 
        X = X(1:fs/2, :);

        % ... set temporary matrices for the computation of the cross-power spectra
        Y = zeros(fs/2, num_channels * (num_channels-1)/2);
        Z = zeros(fs/2, num_channels * (num_channels-1)/2);
        pointer = 0;
        for j=1:num_channels-1
            Y(:,pointer+1:pointer+num_channels-j) = X(:,j+1:num_channels);
            Z(:,pointer+1:pointer+num_channels-j) = repmat(X(:,j),1,num_channels-j);
            pointer = pointer+num_channels-j;
        end

        cross_power = cross_power + [(X .* conj(X)) abs(Z .* conj(Y))];
    end
    cross_power = cross_power ./ nsections;

    % step 6: evaluate the cumulative power in the gamma band and save in file
    power = sum(cross_power((freq_range >= gamma(1) & freq_range < gamma(2)),:), 1);
    power = power(:)';
    fwrite(output_file, power, 'single'); 

    % step 7: update the pointer and save the results
    sample_to_access = sample_to_access + stepwin;
    lastwindow = fs * sample_to_access;
    display(sprintf('completed window #%d of #%d for %s\n', sample_to_access, limit, filename));
end

fclose(output_file);
display(sprintf('power_coherence finished in %fs', toc));

end