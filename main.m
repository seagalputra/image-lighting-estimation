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

%% Fit circle from image
img_stats = regionprops('table', bw, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
center = img_stats.Centroid;
diameter = mean([img_stats.MajorAxisLength(1) img_stats.MinorAxisLength(1)], 2);
radius = diameter/2;

% TODO: fit arbitrary object from single image and obtain the surface
% normal
% Set a points using radius and center of circle
[x, y, nx, ny, theta] = fit_circular(center, radius);

%% Split points in some plane that consist of several points
% define how many points is include one plane
n_points = 3;
x_points = mat2cell(x, 1, repmat(n_points,1,size(x,2)/n_points));
y_points = mat2cell(y, 1, repmat(n_points,1,size(y,2)/n_points));
% before calculating the light source direction, split into several plane
N = [nx', ny'];
N = mat2cell(N,repmat(n_points,1,size(N,1)/n_points),2);

%% Obtain intensity using extrapolation technique opposite the surface normal
% using improfile to obtain intensity opposite the surface normal (every
% point).
offset = 15;
int_boundary = extrapolation(img_gray, x, y, nx, ny, offset);

%% Do the algorithm for estimating light direction
% infinite light source
% define error function and matrix M consist of normals in every plane
% solving least square
L = infinite_light(N, int_boundary);

% TODO: implement local light source estimation

%% Plot and show every figure
figure(1);
imshow(img);
hold on;

plot(x, y, 'r.');
% plot surface normal every points
for i = 1:length(theta)
    line( [x(i) x(i)+nx(i)], [y(i) y(i)+ny(i)] );
end
hold on;

% plot every plane
for i = 1:size(x_points,2)
    plot(x_points{i}, y_points{i});
end
hold on;

% plot light direction from center object
figure(2);
length = 5000;
imshow(img);
hold on;
line([center(1,1) center(1,1)+L(1)*length], [center(1,2) center(1,2)+L(2)*length], 'Color', 'red', ...
    'LineWidth', 3);
