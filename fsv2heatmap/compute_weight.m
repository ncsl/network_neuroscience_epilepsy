function weight = compute_weight(point, origin, mf, cov_mat_inv1, cov_mat_inv2, cov_mat_inv3, cov_mat_inv4)

%This functions takes in a 2D PC point of an electrode.the mean of the patient type (e.g. temporal lobe) 
%and outputs the heatmap weight

%heavyside functions evaluated at point to determine which quadrant point lies in
h1x = heaviside(origin(1)-point(1));
h1y = heaviside(origin(2)-point(2));

h2x = heaviside(point(1)-origin(1));
h2y = heaviside(origin(2)-point(2));

h3x = heaviside(point(1)-origin(1));
h3y = heaviside(point(2)-origin(2));

h4x = heaviside(origin(1)-point(1));
h4y = heaviside(point(2)-origin(2));

%compute weight of point
weight = exp(-mf(1)*(point-origin)*cov_mat_inv1*(point-origin)')*h1x*h1y + ...
         exp(-mf(2)*(point-origin)*cov_mat_inv2*(point-origin)')*h2x*h2y + ...
         exp(-mf(3)*(point-origin)*cov_mat_inv3*(point-origin)')*h3x*h3y + ...
         exp(-mf(4)*(point-origin)*cov_mat_inv4*(point-origin)')*h4x*h4y;


