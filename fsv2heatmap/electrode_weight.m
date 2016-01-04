function weight = electrode_weight(point, origin, mf, cov_mat_inv)

% This functions takes in a 2D PC point of an electrode.the mean of the patient type 
% (e.g. temporal lobe) and outputs the heatmap weight.

% heavyside functions evaluated at point to determine in which quadrant the point lies
h = [heaviside(origin(1)-point(1)) heaviside(origin(2)-point(2));
     heaviside(point(1)-origin(1)) heaviside(origin(2)-point(2));
     heaviside(point(1)-origin(1)) heaviside(point(2)-origin(2));
     heaviside(origin(1)-point(1)) heaviside(point(2)-origin(2));];

% compute weight of point
weight_fn = @(x) exp(-mf(x) * (point-origin) * cov_mat_inv(:,:,x) * (point-origin)') * h(x,1) * h(x,2);
weight = sum(arrayfun(weight_fn, 1:4));

end