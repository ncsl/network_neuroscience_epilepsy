function inv_cov_mat = inverse_covariance_matrix(all_points, ax_mf, mf)

cov_mat = cov(all_points);

% Function 1 for SR
inv_cov_mat1 = cov_mat^-1;
inv_cov_mat1(1,1) = ax_mf(1,1)*inv_cov_mat1(1,1);
inv_cov_mat1(2,2) = ax_mf(1,2)*inv_cov_mat1(2,2);

% Function 2 for FR
inv_cov_mat2 = inv_cov_mat1;
inv_cov_mat2(1,1) = ax_mf(2,1)*inv_cov_mat2(1,1);
inv_cov_mat2(2,2) = ax_mf(2,2)*mf(1)*inv_cov_mat2(2,2)/mf(2);

% Function 3 for SNR
inv_cov_mat3 = inv_cov_mat2;
inv_cov_mat3(1,1) = ax_mf(3,1)*mf(2)*inv_cov_mat3(1,1)/mf(3);
inv_cov_mat3(2,2) = ax_mf(3,2)*inv_cov_mat3(2,2);

% Function 4 FNR
inv_cov_mat4 = inv_cov_mat3;
inv_cov_mat4(1,1) = ax_mf(4,1)*mf(1)*inv_cov_mat1(1,1)/mf(4);
inv_cov_mat4(2,2) = ax_mf(4,2)*mf(3)*inv_cov_mat3(2,2)/mf(4);

inv_cov_mat = cat(3, inv_cov_mat1, inv_cov_mat2, inv_cov_mat3, inv_cov_mat4);

end