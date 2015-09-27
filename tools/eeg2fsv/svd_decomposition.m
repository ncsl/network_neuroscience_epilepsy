function svd_decomposition(pathval,filename,num_channels,included_chn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function: svd_decomposition(pathval,filename,num_channels,included_chn)
%
% Description: The singular value decomposition (SVD) is computed for every
%              matrix stored in any *.dat file in the directory "pathval"
%              whose name begins by "adj_" and contains "filename". The
%              singular values and vectors are stored in *.dat files in the
%              same directory "pathval". It is required that:
%               - matrices are all square, symmetric, and with same number
%                 of columns, which is passed in "num_channels";
%               - matrices are stored into 1-D arrays as described in the
%                 help file of "power_coherence.m";
%               - each element of the matrices is of type "float" and uses
%                 4 bytes (big endian).
%
%              Note that only the rows and columns indicated in "included_
%              chn" are extracted from the original matrix and used to
%              compute the SVD.
%             
% Input:    pathval      - Path to the directory where the destination and
%                          source files are stored. It must be a string of
%                          characters.
%
%           filename     - Label to be used for constructing the name of
%                          the input *.dat files where the matrices are
%                          stored. It must be a string of characters.
%
%           num_channels - Number of columns (and rows) of each matrix. It
%                          must be a positive integer. 
%
%           included_chn - Pointer to the columns (and rows) of each matrix
%                          that must be used to compute the SVD. It is a 1-
%                          D vector of integers between 1 and num_channels.
%                          It is optional. Default value is a vector of
%                          integers that span from 1 to num_channels.
%
% Output:   no output returned.
%			
%
%
% Author: S. Santaniello
% Modified by: B. Chennuri
% Ver.: 4.0 - Date: 05/01/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% validate inputs
%--------------------------------------------------------------------------
if (nargin<3)
    error('Error: no enough input')
end

if (isempty(pathval) || ~ischar(pathval) || ~isdir(pathval))
    error('Error: path is not a valid directory');
end

if (isempty(filename) || ~ischar(filename))
    error('Error: name of the source file not valid');
end

% extract the list of files stored in the directory
listfile = dir(pathval);

% find the files whose name begins with "adj_" and contains "filename"
locations = false(size(listfile));
for i=1:length(locations)
    locations(i) = (~isempty(strfind(listfile(i).name,'adj_')) &&...
                    ~isempty(strfind(listfile(i).name,'.dat')) &&...
                    ~isempty(strfind(listfile(i).name,filename)));
end

if (sum(locations)==0)
    error('Error: no file with the chosen name'); 
end

if (~isreal(num_channels) || isempty(num_channels) || length(num_channels)>1 || num_channels<1)
    error('Error: number of recording channels not valid');
end

num_channels = round(num_channels);

if (nargin<4)
    included_chn = 1:num_channels; 
else
    if (~isreal(included_chn) || isempty(included_chn) || length(included_chn)>num_channels || sum(included_chn<1 | included_chn>num_channels)>0)
        error('Error: pointer to the channels to be used not valid');
    end
    included_chn = round(included_chn(:)');
end

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% initialize the environment variables
%--------------------------------------------------------------------------
% set the pointer to those files that store valid matrices
position = find(locations==true);

% number of bytes per number (it corresponds to the type "float")
nbytes = 4;

% open the log file
if ~exist(sprintf('%s/svd_log', pathval), 'dir')
    mkdir(sprintf('%s', pathval), 'svd_log');
end
fid0 = fopen(sprintf('%s/svd_log/%s_log.dat',pathval,filename),'a');
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% main loop
%--------------------------------------------------------------------------
tic
% for each valid file...
for k=1:length(position)
    
    % check if the file is not corrupted and extract the length of the file
    % (in number of bytes)
    fid = fopen(sprintf('%s/%s',pathval,listfile(position(k)).name),'rb');
    fseek(fid,0,'eof');
    lengthfile = ftell(fid);
    if (lengthfile==-1)
        fclose(fid); clear fid
        error('Error: file %s not open correctly',listfile(position(k)).name); 
    else
        
        % set the pointer to the beginning of the file
        fseek(fid,0,'bof');
        
        % initialize the pointer to the last accessed byte in the file
        lastbyte = 0;
        
        % extract sequentially every matrix stored in the file
        while (lastbyte<lengthfile)
            
            % step 1: extract the 1-D array correspondent to the current
            %         matrix
            ndata = num_channels*(num_channels+1)/2;
            fseek(fid,lastbyte,'bof');
            data =fread(fid,ndata,'single');
            data(isnan(data)) = 0;

            % step 2: reshape the 1-D array into a 2-D array
            A = diag(data(1:num_channels));
            pointer = num_channels;
            for j=1:num_channels-1
                A(j,j+1:num_channels) = data(pointer+1:pointer+num_channels-j);
                A(j+1:num_channels,j) = A(j,j+1:num_channels)';
                pointer = pointer+num_channels-j;
            end
            
            % step 3: remove the rows and columns associated with the
            %         channels not carrying information
            A = A(included_chn,included_chn);

            % step 4: singular value decomposition
            A(isnan(A)) = 0;
            if (sum(sum(abs(A)))>0)
                [U,S,~] = svd(A);
% % %                 [U,S,V] = svd(A);
            else
                U = eye(size(A,1));
% % %                 V = eye(size(A,2));
                S = zeros(size(A));
            end                
            
            % step 5: save singular values and vectors in a *.dat file.
            %         Note that the singular vectors are stored by column
            %         (from the first to the last). Decrescent order is
            %         also used for the singular values.
            
            if ~exist(sprintf('%s/svd_vectors', pathval), 'dir')
                mkdir(sprintf('%s', pathval), 'svd_vectors');
            end
            fid2 = fopen(sprintf('%s/svd_vectors/svd_l_%s',pathval,listfile(position(k)).name(5:end)),'ab');
            fwrite(fid2,U(:),'single');
            fclose(fid2);
            
            % TODO: Only the vectors are used later, not the values.
            if ~exist(sprintf('%s/svd_values', pathval), 'dir')
                mkdir(sprintf('%s', pathval), 'svd_values');
            end
            fid2 = fopen(sprintf('%s/svd_values/svd_v_%s',pathval,listfile(position(k)).name(5:end)),'ab');
            fwrite(fid2,diag(S),'single');
            fclose(fid2);

            % step 6: update the pointer
            lastbyte = lastbyte+ndata*nbytes;
            clear A U S V data pointer j ndata
        end
        
        % close the current file
        fclose(fid);
        clear fid lastbyte
    end
    fprintf(fid0,'file %s - svd completed\n',listfile(position(k)).name);
    clear lengthfile
end

% save the CPU time required for the computation in the log file and close
% the log file
t = toc;
fprintf(fid0,'cpu time used: %f\n',t);
fclose(fid0);

end