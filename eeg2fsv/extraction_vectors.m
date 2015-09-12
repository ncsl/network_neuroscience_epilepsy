function extraction_vectors(svdVectorPath, svdVectorFile, nChannels)

% Reads the singular vectors for each computed adjacency
% matrix and extracts one specific singular vector. The
% sequence of extracted vectors is stored in a *.mat file.

singular_vec_to_extract = 1;

% convert sparse representation into the full matrix
tmp = read_svd_matrix(sprintf('%s/%s', svdVectorPath, svdVectorFile), nChannels);

% extract and store the leading eigenvector for each adj. mat. and store it.
snap1_gamma = zeros(size(tmp,2), size(tmp,1));
for q=1:size(tmp,1), snap1_gamma(:,q) = tmp(q,:,singular_vec_to_extract)'; end

% save the struct arrays into a *.mat file
% fsv - first singular vector
save(sprintf('%s/fsv_pwr1.mat', svdVectorPath), 'snap1_gamma');

end