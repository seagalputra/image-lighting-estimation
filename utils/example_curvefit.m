clear; clc; close all;

addpath('../line_curvature');
% Read image data.
img = imread('../examples/dataset_flash_light/blue_orange_00.jpg');
% Convert image into grayscale
imgGray = rgb2gray(img);

% Read annotation data.
annotation = imread('../examples/dataset_flash_light/blue_orange_00_contour1.png');
% Image annotation is in rgb format. Before converting to binary image,
% it's important to convert image into grayscale value.
annotation = rgb2gray(annotation);
bw = imbinarize(annotation);
% Get x y coordinates of all curve points
[y, x]= find(bw);

% Get coordinate of image using point interface
% imshow(imgGray);
% [x, y] = getpts;

% Fit the coordinates into polyfit to obtain coefficient of polynomial
% equation. (Assume the annotation always in curve)
p = polyfit(y,x,6);
% Generate sequence of number to fit into curve.
yy = linspace(1, size(bw,1), 100);
% yy = y;
% Evaluate every sequence of number into to get the another coordinate.
xx = polyval(p,yy);
% Calculate the suface normal for every coordinate that fit into polynomial
% equation.
v(:,1) = xx;
v(:,2) = yy;
N = LineNormals2D(v);
% Get instensity image along the contour
intensity = improfile(imgGray,y,x,size(x,1));
% Plot the image along with surface normal
figure;
imshow(annotation, 'border', 'tight');
hold on;
plot(xx,yy,'r.-', 'LineWidth', 1);
hold on;
% For surface normal
plot([v(:,1), v(:,1)+10*N(:,1)]', [v(:,2), v(:,2)+10*N(:,2)]');