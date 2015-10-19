function extract_vectors(patient_id, svd_vector_path, nchmax)

output_filename = sprintf('%s/fsv_pwr%s.mat', svd_vector_path, patient_id);
listing = dir([svd_vector_path '/*gamma.dat']);

for i = 1:length(listing)
    tmp = read_svd_matrix(sprintf('%s/%s',svd_vector_path, listing(i).name), nchmax);
    data = zeros(size(tmp,2), size(tmp,1));
    for q=1:size(tmp,1), data(:,q) = tmp(q,:,1)'; end

    % store the extracted vectors into a struct
    eval([sprintf('snap%d_gamma', i), ' = data;']);

    % save the struct arrays into a *.mat file
    if(~exist(output_filename, 'file'))
        save(output_filename, sprintf('snap%d_gamma', i));
    else
        save(output_filename, sprintf('snap%d_gamma', i), '-append');
    end
end

end
