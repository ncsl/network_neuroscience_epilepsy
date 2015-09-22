function weight = compute_weight(point, origin, mf, cov_mat_inv1, cov_mat_inv2, cov_mat_inv3, cov_mat_inv4)

% This functions takes in a 2D PC point of an electrode.the mean of the patient type 
% (e.g. temporal lobe) and outputs the heatmap weight.

% heavyside functions evaluated at point to determine in which quadrant the point lies
h = [heaviside(origin(1)-point(1)) heaviside(origin(2)-point(2));
     heaviside(point(1)-origin(1)) heaviside(origin(2)-point(2));
     heaviside(point(1)-origin(1)) heaviside(point(2)-origin(2));
     heaviside(origin(1)-point(1)) heaviside(point(2)-origin(2));];

% compute weight of point
weight = exp(-mf(1)*(point-origin)*cov_mat_inv1*(point-origin)')*h(1,1)*h(1,2) + ...
         exp(-mf(2)*(point-origin)*cov_mat_inv2*(point-origin)')*h(2,1)*h(2,2) + ...
         exp(-mf(3)*(point-origin)*cov_mat_inv3*(point-origin)')*h(3,1)*h(3,2) + ...
         exp(-mf(4)*(point-origin)*cov_mat_inv4*(point-origin)')*h(4,1)*h(4,2);

end