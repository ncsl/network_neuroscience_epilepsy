function weights = compute_weights(num_electrodes, num_seizures, test_pc, origin, mf, inv_cov_mat)

e_count = 0;
gaussian = zeros(num_electrodes, num_seizures);

for k = 1:num_seizures
    electrodes_in_event = test_pc((e_count+1):(e_count + num_electrodes), :);
    e_count = e_count + num_electrodes;
    
    for j=1:length(electrodes_in_event)
        gaussian(j, k) = electrode_weight(electrodes_in_event(j,:), origin, mf, inv_cov_mat);
    end
end

weights = sum(gaussian,2) / num_seizures;

end

