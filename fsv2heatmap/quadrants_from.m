function quadrants = quadrants_from(X1, Y1, X2, Y2, X3, Y3, X4, Y4)
%quadrants_from:
%
% quadrants are represented as a position vector from the origin to a point.
%
%  Q4 | Q3
% ----|----
%  Q1 | Q2
%
% origin->point  [origin-x     origin-y	    point-x      point-y]
quadrants = zeros(4);
quadrants(1,:) = [max(X1(1,:)) max(Y1(:,1)) min(X1(1,:)) min(Y1(:,1))];
quadrants(2,:) = [min(X2(1,:)) max(Y2(:,1)) max(X2(1,:)) min(Y2(:,1))];
quadrants(3,:) = [min(X3(1,:)) min(Y3(:,1)) max(X3(1,:)) max(Y3(:,1))];
quadrants(4,:) = [max(X4(1,:)) min(Y4(:,1)) min(X4(1,:)) max(Y4(:,1))];

end

