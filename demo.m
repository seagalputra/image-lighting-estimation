% This is a demo for estimating light direction from single image using
% object boundary
clear; clc; close all;

img = imread('data/4.JPG');
% convert RGB image into Grayscale
img_gray = rgb2gray(img);

%% Obtain boundary for arbitrary object
gaps = 10; % how many gaps between point to use
n_points = 3; % how many points in a surface
offset = 15; % offset to obtain intensity
length = 3000; % length to plot line

% segment image using k-means clustering
[bw, mask] = segment_image(img);

% segment image using YCbCr color space
% [bw, mask] = color_threshold(img);
% create bounding box and area using binary mask
% filter with largest area
[center, radius, box_props] = bwprops(bw);

imshow(img);
hold on;
% calculate light source direction for every object
for i = 1:size(center,1)
    % suppose the object is circular
    [x, y, nx, ny] = fit_circular(center(i,:), radius(i,:));
    
    % before calculating the light source direction, split normal surface
    % into several plane
    N = [nx', ny'];
    N = mat2cell(N,repmat(n_points,1,size(N,1)/n_points),2);
    x_points = mat2cell(x, 1, repmat(n_points,1,size(x,2)/n_points));
    y_points = mat2cell(y, 1, repmat(n_points,1,size(y,2)/n_points));
    
    % obtain intensity at boundary image using improfile and extrapolation
    int_boundary = extrapolation(img_gray, x, y, nx, ny, offset);

    % calculate light source direction by solving least-square problem
    L = infinite_light(N, int_boundary);
    
    % TODO: implement local light source estimation
    
    % plot surface normal every points
    plot(x, y, 'r.');
    for j = 1:length(theta)
        line( [x(j) x(j)+nx(j)], [y(j) y(j)+ny(j)] );
    end
    hold on;
    % plot light source direction from center object
    line([center(i,1) center(i,1)+L(1)*length], [center(i,2) center(i,2)+L(2)*length], 'Color', 'red', ...
        'LineWidth', 2);
end

% draw rectangle
% imshow(img);
% for i = 1:size(box_props,1)
%     % crop object in image
%     obj{i} = imcrop(img, box_props(i,:));
%     rectangle('Position', [box_props(i,1), box_props(i,2), box_props(i,3), box_props(i,4)], ...
%         'EdgeColor', 'r', 'LineWidth', 2);
% end