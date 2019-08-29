clear; clc; close all;

% load image and suppose image in binary image
img = imread('https://i.stack.imgur.com/0HVjj.png');
% convert image into grayscale
img = rgb2gray(img);
% obtain size of image
[size_rows, size_cols] = size(img);
% compute the gradient of image
[dx, dy] = imgradient(double(img));
% define the index of image
[x, y] = meshgrid(1:size_cols, 1:size_rows);
% showing image with their plot
imshow(img, 'border', 'tight');
hold on;
quiver(x,y,dx,dy);
