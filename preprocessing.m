clear; clc; close all;

pause on;
%% Load image data
load('image_data.mat');

%% Correct nonuniform illumination
radius = 400;
n = 8;
img = apple{1};
% convert image to grayscale
gray = rgb2gray(img);
% remove foreground image using morphological opening
se = strel('disk', radius, n);
background = imopen(gray,se);
imshow(background);
%% Using gamma correction to enhance contrast image
gamma = 0.3;
size_threshold = 500;
K = 2;
num_replicate = 3;
for i = 1:size(apple,2)
    disp(['Image - ', num2str(i)]);
    J = imadjust(apple{i}, [], [], gamma);
    mask = kmeans_seg(J, K, num_replicate);
    mask = bwareaopen(mask, size_threshold);
    
    subplot(131);
    imshow(apple{i});
    subplot(132);
    imshow(J);
    subplot(133);
    imshow(mask);
    pause(3);
end