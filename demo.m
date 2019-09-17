% This is a demo for estimating light direction from single image using
% object boundary
clear; clc; close all;

img = imread('data/f1.JPG');
% convert RGB image into Grayscale
img_gray = rgb2gray(img);

%% Obtain boundary for arbitrary object
gaps = 10; % how many gaps between point to use

% segment image using k-means clustering
% [bw, mask] = segment_image(img);
% segment image using YCbCr color space
[bw, mask] = color_threshold(img);
bw = imfill(bw, 'holes');
% create bounding box and area using binary mask
props = regionprops(bw, 'BoundingBox', 'Area');
% find region with largest area
% TODO: find center object with largest area
box_props = [];
for i = 1:length(props)
    if (props(i).Area > 100)
        box_props = [box_props; props(i).BoundingBox];
    end
end
% draw rectangle
imshow(img);
for i = 1:size(box_props,1)
    % crop object in image
    obj{i} = imcrop(img, box_props(i,:));
    rectangle('Position', [box_props(i,1), box_props(i,2), box_props(i,3), box_props(i,4)], ...
        'EdgeColor', 'r', 'LineWidth', 2);
end

%% Fit circle from image
% find center of object
[center, radius] = circular(bw);

% Set a points using radius and center of circle
[x, y, nx, ny, theta] = fit_circular(center(1,:), radius);

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
