% This is a demo for estimating light direction from single image using
% object boundary (for arbitrary shape object)
clear; clc; close all;

addpath('line_curvature');

img = imread('data/f1.JPG');
% convert RGB image into Grayscale
img_gray = rgb2gray(img);

%% Obtain boundary for arbitrary object
gaps = 10; % how many gaps between point to use
n_points = 4; % how many points in a surface (should be even integer)
offset = 15; % offset to obtain intensity
len = 10; % length to plot line

% SEGMENTATION PARAMETER
seg_choice = 1;
n_colors = 3;
num_replicates = 3;
size_threshold = 500;

disp('Perform image segmentation...');
if (seg_choice == 1)
    % segment image using k-means clustering
    disp('(using k-means clustering)');
    bw = kmeans_seg(img, n_colors);
elseif (seg_choice == 2)
    disp('(using YCbCr color space)');
    % segment image using YCbCr color space
    bw = color_threshold(img);
end

% create bounding box and area using binary mask
% filter with largest area
bw = bwareaopen(bw, size_threshold);
[center, radius, box_props] = bwprops(bw);

%% Draw bounding box
figure(1);
imshow(bw);
for i = 1:size(box_props,1)
    % crop object in image
    obj{i} = imcrop(bw, box_props(i,:));
    gray{i} = imcrop(img_gray, box_props(i,:));
    rectangle('Position', [box_props(i,1), box_props(i,2), box_props(i,3), box_props(i,4)], ...
        'EdgeColor', 'r', 'LineWidth', 2);
end

%% Calculate light source direction for every object
figure(2);
imshow(img);
hold on;
disp('Estimate lighting direction...');
for i = 1:size(obj,2)
    % find points at boundary object and calculate surface normal
    vertices = boundary_img(obj{i}, gaps);
    N = LineNormals2D(vertices);
    x = vertices(:,1)';
    y = vertices(:,2)';
    nx = N(:,1)';
    ny = N(:,2)';
    
    % before calculating the light source direction, split normal surface
    % into several plane
    result = fix(size(N,1)/n_points);
    remainder = mod(size(N,1),n_points);
    size_points = repmat(result,1,n_points);
    size_points(end) = size_points(end) + remainder;
    N = mat2cell(N,size_points,2);
    
    % obtain intensity at boundary image using improfile and extrapolation
    int_boundary = extrapolation(gray{i}, x, y, nx, ny, offset);

    % calculate light source direction by solving least-square problem
    L = infinite_light(N, int_boundary);
    
    % TODO: implement local light source estimation
    
    % plot surface normal every points
    % plot(x, y, 'r.');
    % for j = 1:size(x,2)
    %     line( [x(j) x(j)+nx(j)], [y(j) y(j)+ny(j)] );
    % end
    % hold on;
    % plot light source direction from center object
    line([center(i,1) center(i,1)+L(1)*len], [center(i,2) center(i,2)+L(2)*len], 'Color', 'red', ...
        'LineWidth', 2);
end