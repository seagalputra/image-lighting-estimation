clear; clc; close all;

img = imread('data/1.JPG');
% crop image
% cropped_img = imcrop(img, [448, 830, 1229, 1229]);
% convert RGB image into Grayscale
img_gray = rgb2gray(img);

%% Segmentation for obtain ball object
[bw, mask] = segment_image(img);
% find boundary image
boundary_obj = boundarymask(bw);
figure(1);
imshow(img);
hold on;

%% Fit circle from image
img_stats = regionprops('table', bw, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
center = img_stats.Centroid;
diameter = mean([img_stats.MajorAxisLength(1) img_stats.MinorAxisLength(1)], 2);
radius = diameter/2;

% Set a points using radius and center of circle
% theta = 0:pi/50:2*pi; % define angles
theta = 0:10:359;
% get x and y points along the cirumference
x = radius * cosd(theta) + center(1,1);
y = radius * sind(theta) + center(1,2);
% because the object is circle, I unnecessary fit the point using curve
% fit. If I have an arbitrary object, I must fit those points using curve
% fit first before calculating a surface normal.
nx = radius * cosd(theta);
ny = radius * sind(theta);
% plot those points
plot(x, y, 'r.');
% this plot line plot from given point into another point.
for i = 1:length(theta)
    line( [x(i) x(i)+nx(i)], [y(i) y(i)+ny(i)] );
end
hold on;

%% Split points in some plane that consist of several points
% define how many points is include one plane
n_points = 3;
x_points = mat2cell(x, 1, repmat(n_points,1,size(x,2)/n_points));
y_points = mat2cell(y, 1, repmat(n_points,1,size(y,2)/n_points));
N = [nx', ny'];
N = mat2cell(N,repmat(n_points,1,size(N,1)/n_points),2);

% plot every plane
for i = 1:size(x_points,2)
    plot(x_points{i}, y_points{i});
end
hold on;

%% Obtain intensity using extrapolation technique opposite the surface normal
% define the error function and solve it using least-square
offset = 15;

% using improfile to obtain intensity opposite the surface normal (every
% point).
for i = 1:size(x,2)
    int_profile = improfile(img_gray, [x(i) x(i)-nx(i)], [y(i) y(i)+ny(i)], offset);
    % find intensity at boundary point using interp1
    int_boundary(i) = interp1(int_profile, 0, 'linear', 'extrap');
end

%% Do the algorithm for estimating light direction
% infinite light source
% define error function and matrix M consist of normals in every plane
% solving least square
lambda = 1;
M = blkdiag(N{:});
M = [M ones(size(M,1),1)];
b = int_boundary';
c = {[-1 0 1 0; 0 -1 0 1]};
c = repmat(c,1,size(N,1)/2);
block_c = blkdiag(c{:});
block_c = [block_c zeros(size(block_c,1),1)];
v = pinv((M'*M) + lambda*(block_c'*block_c))*M'*b;
v(end) = [];
% average the result of light estimation
Lx = [];
Ly = [];
for i = 1:size(v,1)
    if (mod(i,2) == 0)
        Ly = [Ly; v(i,:)];
    else
        Lx = [Lx; v(i,:)];
    end
end
L = [Lx, Ly];
L = mean(L);

% plot light direction from center object
figure(2);
length = 5000;
imshow(img);
hold on;
line([center(1,1) center(1,1)+L(1)*length], [center(1,2) center(1,2)+L(2)*length], 'Color', 'red', ...
    'LineWidth', 3);
