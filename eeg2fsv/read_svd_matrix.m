function A = read_svd_matrix(filename,nch)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function: A = read_svd_matrix(filename,nch)
%
% Description: It accesses the file named "filename", reads data from it,
%              and format the data into a sequence of square matrices, each
%              with "nch" rows (columns).
%             
% Input:    filename - Name of the file where the matrices are stored. It
%                      must be a string of characters.
%
%           nch      - Number of rows (columns) of each square matrix. It
%                      must be a positive integer. 
%
% Output:   A - 3D array that stores the sequence of matrices extracted
%               from the input file.
%			
%
%
% Author: S. Santaniello
%
% Ver.: 1.0 - Date: 11/16/2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%--------------------------------------------------------------------------
% check if the correct number and type of data has been passed
%--------------------------------------------------------------------------
if (nargin<2), error('Error: no enough input'); end

if (isempty(filename) || ~ischar(filename))
    error('Error: name of the source file not valid');
end

% open the file
fid = fopen(filename,'rb');
if (fid < 0)
    error('Error: file not opened correctly or not valid');
end

if (~isreal(nch) || isempty(nch) || length(nch)>1 || nch<1)
    error('Error: number of rows not valid');
end
nch = round(nch);

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% main loop
%--------------------------------------------------------------------------
% step 1: extract the matrices
ndata = nch*nch;
fseek(fid,0,'bof');
data =fread(fid,[ndata inf],'single');
fclose(fid);

% step 2: reshape each matrix into a 2-D array
A = zeros(size(data,2),nch,nch);

% for each matrix...
for i=1:size(data,2)
    tmp = reshape(data(:,i),nch,nch);
    A(i,:,:) = tmp;
    clear tmp
end
%--------------------------------------------------------------------------
