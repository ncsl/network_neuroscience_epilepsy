function q = quadrant(x, y, origin, mf, inv_cov_mat)

[X, Y] = meshgrid(x,y);
surface = [X(:) Y(:)];
q = zeros(size(surface,1), 1);
for i = 1:length(q)
    % Compute the https://en.wikipedia.org/wiki/Multivariate_normal_distribution
    q(i) = exp(-mf * (surface(i,:) - origin) * inv_cov_mat * (surface(i,:) - origin)');
end

end

% To see all quadrants, invoke this with each combination:
% quadrants = quadrants_from(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
% keyboard