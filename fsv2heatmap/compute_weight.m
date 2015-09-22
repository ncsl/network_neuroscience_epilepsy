function weight = compute_weight(point,mu,cov_mat_inv1, cov_mat_inv2, cov_mat_inv3, cov_mat_inv4)

%This functions takes in a 2D PC point of an electrode.the mean of the patient type (e.g. temporal lobe) 
%and outputs the heatmap weight

%center of PC grid - origin for 4 quadrants
center = [-250, -25];

%hard coded scale factors
mf1 = 2e-2; mf2 = 2.5*mf1; mf3 = 4*mf2; mf4 = 1e-3*mf3; 

%heavyside functions evaluated at point to determine which quadrant point lies in
h1x = heaviside(center(1)-point(1));
h1y = heaviside(center(2)-point(2));

h2x = heaviside(point(1)-center(1));
h2y = heaviside(center(2)-point(2));

h3x = heaviside(point(1)-center(1));
h3y = heaviside(point(2)-center(2));

h4x = heaviside(center(1)-point(1));
h4y = heaviside(point(2)-center(2));

%compute weight of point
weight = exp(-mf1*(point-mu)*cov_mat_inv1*(point-mu)')*h1x*h1y + ...
         exp(-mf2*(point-mu)*cov_mat_inv2*(point-mu)')*h2x*h2y + ...
         exp(-mf3*(point-mu)*cov_mat_inv3*(point-mu)')*h3x*h3y + ...
         exp(-mf4*(point-mu)*cov_mat_inv4*(point-mu)')*h4x*h4y;


