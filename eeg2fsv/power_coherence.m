function power_coherence(pathval,filename,num_channels,Fs,pos)

% Description: This function computes (i) the auto- and cross-power, (ii)
%              and the mean phase coherence among iEEG recordings from
%              independent channels. Power and coherence are evaluated in
%              specific frequency bands. The iEEG recordings are extracted
%              from a *.mat file whose name and home directory are provided
%              along with the data format. A pointer to the first sample to
%              be accessed and the # of independent channels to be used are
%              also provided. Frequency bands of interest are:
%               - delta: [ 0,  4) Hz;
%               - theta: [ 4,  8) Hz;
%               - alpha: [ 8, 13) Hz;
%               - beta:  [13, 30) Hz;
%               - gamma: [30, 90) Hz.
%
%             The sampling rate of the input is specified by the user.
%             Spectra and coherence values are computed over a sliding
%             window (2.5s-long, 1.5s-long overlap) with the Welch's method
%             i.e., each  window of data is divided into 1s-long sub-
%             sections (750ms overlap) and the power (coherence) is
%             averaged across the sub-sections. Power spectra and mean
%             coherence values fill band-specific connectivity matrices,
%             which are stored in *.bin file.
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
%           Fs           - Sampling frequency (in Hz). It must be positive.
%
%           pos          - pointer to the last second of data accessed
%                          (counted from 0), i.e., the first byte to-be-
%                          extracted is in position pos x num_channels x
%                          #-samples-per-second x #-bytes-per-sample + 1.
%                          It must be a nonnegative integer.
%
% Output:   no output returned.
%
%
%
% NOTE: Power spectra and coherence values estimated for a given window of
%       data in a given frequency band are stored in a 1-D array. Denoted
%       with 1... n the iEEG channels, the cross-power (coherence) between
%       each pair of channels is stored according to the following rule:
%
%        - array position: 1  2...  n n+1 n+2  2n-1 2n ... 3n-2... n(n+1)/2
%        - channel pair:  11 22... nn  12  13... 1n 23 ...   2n...   (n-1)n
%
%       Values estimated for consecutive windows are added to a 2-D array
%       by row.
%			
%
%
% Author: S. Santaniello
% Modified by: B. Chennuri
%
% Ver.: 5.0 - Date: 05/01/2015
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% validate inputs
%--------------------------------------------------------------------------
if (nargin<5)
    error('Error: no enough input')
end

if (isempty(pathval) || ~ischar(pathval) || ~isdir(pathval))
    error('Error: path is not a valid directory');
end

if (isempty(filename) || ~ischar(filename) || ~exist(sprintf('%s/%s.mat',pathval,filename),'file'))
    error('Error: name of the source file not valid or file not found');
end

% check if the file is corrupted and extract the length of the file (in number of bytes)
fid = load(sprintf('%s/%s.mat',pathval,filename));
lengthfile = length(fid.eeg);
if (lengthfile == 0)
    clear fid
    error('Error: file not open correctly'); 
end

if (isempty(num_channels) || ~isreal(num_channels) || length(num_channels)>1 || num_channels<1)
    error('Error: Invalid number of recording channels');
end
num_channels = round(num_channels);

if (isempty(Fs) || ~isreal(Fs) || length(Fs)>1 || Fs<1)
    error('Error: sampling frequency not valid');
end
Fs = round(Fs);


%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% initialize the environment variables
%--------------------------------------------------------------------------
% notch filter (stop frequency: 60Hz; stop-band: 4Hz)
% represented by a transfer function: polynomial / polynomial
% continuous second-order equations, in this case.
if (Fs==1000)
    % sampling frequency: 1000Hz). Note that the filter induces a transient
    % oscillation of about 400 samples which must be removed from the data
    dennotch = [1 -1.847737249430546 0.987291867964730];
    numnotch = [0.993645933982365 -1.847737249430546 0.993645933982365];
    Ns = 400;
elseif (Fs==200)
    % sampling frequency: 200Hz). Note that the filter induces a
    % transient oscillation of about 100 samples which must be removed
    % from the data 
    dennotch = [1 0.598862049930572 0.937958302720205];
    numnotch = [0.968979151360102 0.598862049930572 0.968979151360103];
    Ns = 100;
else
    error('Error: notch filter not available');
end

% max number of samples per channel to be extracted
% 2.5 represents the overlap of the sliding windows
nsamples = round(2.5*Fs);

% step size of the sliding horizon (in s)
stepwin = 1;

% frequency bands (in Hz) used during the computation of the connectivity matrices
% conventional frequencies corresponding to the bands below.
% EZTrack only uses gamma bands
bands = [0 4; 4 8; 8 13; 13 30; 30 90];

% labels associated with the frequency bands. Note that the positions in "bands" and "label_bands" match
label_bands = {'delta';'theta';'alpha';'beta';'gamma'};

% % set the number of bytes used for representing each data sample in the
% % *.mat file
% switch format_file
%     case 'short'
%         nbytes = 2;
%     case 'int'
%         nbytes = 4;
%     case 'single'
%         nbytes = 4;
%     case 'double'
%         nbytes = 8;
% end

% set the number of points of the fft
nfft = Fs;   %2^nextpow2(Fs);

% set the window function for the periodograms
% TODO: Sabatino chose these parameters in his research.
% Based on periodigrams and a modified FFT
convwin = 0.54-0.46*cos((2*pi*(1:nfft))/(nfft-1)); 
convwin = convwin(:);

% set the range of frequencies for the periodograms (Hz)
frq = (Fs/2).*linspace(0,1,nfft/2);

% set the step size for the sub-sections (number of samples)
stepsize = round(nfft/4);

% set the pointer to the last byte before the one to be accessed now
lastwindow = 0;

% open the log file
if ~exist(sprintf('%s/adj_log', pathval), 'dir')
    mkdir(sprintf('%s', pathval), 'adj_log');
end
fid0 = fopen(sprintf('%s/adj_log/%s_log.dat',pathval,filename),'w');
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% main loop
%--------------------------------------------------------------------------
tic
while (pos< fix((lengthfile - (nsamples-stepwin*Fs))/(stepwin*Fs)))
    
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
    tmpdata = fid.eeg(:, (lastwindow - tmpwindow) + 1:lastwindow + nsamples );
    tmpdata = filtfilt(numnotch,dennotch,tmpdata');
    data = tmpdata(tmpwindow + 1:end,:);
    clear tmpdata tmpbyte
    
   
    % step 2: pre-process the data. For each channel, subtract the mean
    %         value and divide by the standard deviation. Note that this
    %         step NORMALIZES the data
    data = data-repmat(mean(data,1),size(data,1),1);
    data = data./repmat(std(data,[],1),size(data,1),1);
    data(isnan(data)) = 0;
    
    % step 3: split the data into overlapping sub-sections
    nsections = ceil((size(data,1)-(nfft-stepsize))/stepsize);
    
    % step 4: compute the cross-power spectra
    CrossPwr = zeros(nfft/2,num_channels*(num_channels+1)/2);
%     CrossSpc = zeros(nfft/2,num_channels*(num_channels+1)/2);
    
    for i=1:nsections
        
        % ... extract the current sub-section
        datasec = data((i-1)*stepsize+1:min((i-1)*stepsize+nfft,size(data,1)),:);
        
        % ... avoid computation if the data are all zeros
        if (sum(sum(abs(datasec)))>0)
            
            % ... compute the fft. Note: size(X) = (nfft/2) x #-of-channels
            X = fft(repmat(convwin(1:min(nfft,size(datasec,1))),1,num_channels).*datasec,nfft); 
            X = X(1:nfft/2,:);

            % ... set temporary matrices for the computation of the cross-
            %     power spectra and coherences
            Y = zeros(nfft/2,num_channels*(num_channels-1)/2);
            Z = zeros(nfft/2,num_channels*(num_channels-1)/2);
            pointer = 0;
            for j=1:num_channels-1
                Y(:,pointer+1:pointer+num_channels-j) = X(:,j+1:num_channels);
                Z(:,pointer+1:pointer+num_channels-j) = repmat(X(:,j),1,num_channels-j);
                pointer = pointer+num_channels-j;
            end

            % ... compute auto- and cross-spectra
            CrossPwr = CrossPwr+[X.*conj(X) abs(Z.*conj(Y))];
%             CrossSpc = CrossSpc+[X Z].*conj([X Y]);
            clear X Y Z pointer j
        end
        clear datasec
    end
    CrossPwr = CrossPwr./nsections;
%     CrossSpc = CrossSpc./nsections;
        
    % step 5: compute the cross-coherence
%     CrossChr = ones(nfft/2,num_channels*(num_channels+1)/2);
%     Y = zeros(nfft/2,num_channels*(num_channels-1)/2);
%     pointer = 0;
%     for j=1:num_channels-1
%         Y(:,pointer+1:pointer+num_channels-j) = CrossSpc(:,j+1:num_channels).*repmat(CrossSpc(:,j),1,num_channels-j);
%         pointer = pointer+num_channels-j;
%     end
%     CrossChr(:,num_channels+1:end) = (CrossSpc(:,num_channels+1:end).*conj(CrossSpc(:,num_channels+1:end)))./Y;
%     clear Y CrossSpc pointer j nsections data

    % step 6: evaluate the cumulative power and the mean coherence in the
    %         each frequency band of interest and save in file
    if ~exist(sprintf('%s/adj_pwr', pathval), 'dir')
        mkdir(sprintf('%s', pathval), 'adj_pwr');
    end
    
%     if ~exist(sprintf('%s/adj_chr', pathval), 'dir')
%         mkdir(sprintf('%s', pathval), 'adj_chr');
%     end
    
    for k=5%1:size(bands,1)
        tmp = sum(CrossPwr(frq>=bands(k,1) & frq<bands(k,2),:),1);  tmp = tmp(:)';
        fid2 = fopen(sprintf('%s/adj_pwr/adj_pwr_%s_%s.dat',pathval,filename,label_bands{k}),'ab');
        fwrite(fid2,tmp,'single'); 
        fclose(fid2);
        clear tmp fid2
        
%         tmp = mean(CrossChr(frq>=bands(k,1) & frq<bands(k,2),:),1); tmp = tmp(:)';
%         fid2 = fopen(sprintf('%s/adj_chr/adj_chr_%s_%s.dat',pathval,filename,label_bands{k}),'ab');
%         fwrite(fid2,tmp,'double');
%         fclose(fid2);
%         clear tmp fid2
    end

    % step 7: update the pointer and save the results
    pos = pos+stepwin;
    lastwindow = Fs*pos;
    fprintf(fid0,'window of data #%d completed\n',pos);
    clear('-regexp','^Cross');
end


% save the CPU time required for the computation in the log file and close
% the log file
t = toc;
fprintf(fid0,'cpu time used: %f\n',t);
fclose(fid0);

end