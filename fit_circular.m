function [x, y, nx, ny, theta] = fit_circular(center, radius, size_point)

if (nargin < 3)
    size_point = 10;
end

theta = 0:size_point:359;
% get x and y points along the cirumference
x = radius * cosd(theta) + center(:,1);
y = radius * sind(theta) + center(:,2);
% because the object is circle, I unnecessary fit the point using curve
% fit. If I have an arbitrary object, I must fit those points using curve
% fit first before calculating a surface normal.
nx = radius * cosd(theta);
ny = radius * sind(theta);
end

