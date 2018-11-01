clear;
clc;
close all;

% Using image demos in MATLAB folder
img = imread('toysnoflash.png');

% convert image to grayscale if image is in RGB color channel
if (size(img, 3) == 3)
    img = rgb2gray(img);
end
img = imcrop(img);

% maintain image in 1:1 size ratio
img = aspectRatio(img, 9);

save('image.mat');
