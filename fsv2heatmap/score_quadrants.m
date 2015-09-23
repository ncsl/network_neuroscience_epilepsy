function heatcodes = score_quadrants(weights, all_points, origin, mf, inv_cov_mat, number_heatmap_colors)

% Set up the four quadrants
x1 = min(all_points(:,1)):origin(1);
x2 = origin(1):max(all_points(:,1));
y1 = min(all_points(:,2)):origin(2);
y2 = origin(2):max(all_points(:,2));

Z1 = quadrant(x1, y1, origin, mf(1), inv_cov_mat(:,:,1)); % SR
Z2 = quadrant(x2, y1, origin, mf(2), inv_cov_mat(:,:,2)); % FR
Z3 = quadrant(x2, y2, origin, mf(3), inv_cov_mat(:,:,3)); % SNR
Z4 = quadrant(x1, y2, origin, mf(4), inv_cov_mat(:,:,4)); % FNR

Z = [Z1; Z2; Z3; Z4];
clr_ind = linspace(min(Z), max(Z), number_heatmap_colors + 1);

heatcodes = zeros(size(weights));

for i = 1:number_heatmap_colors
    filter = (weights < clr_ind(i+1)) & (weights >= clr_ind(i));
    heatcodes(filter) = (number_heatmap_colors - i) + 1;
end

heatcodes(weights == clr_ind(end)) = 1;

end

