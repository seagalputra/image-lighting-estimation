clear;
clc
close all;

% img = imread('sphere2.bmp');
% img = rgb2gray(img);

img = imread('datasets/4/4_l1c2.png');
% img = imread('datasets/32/32_l5c1.png');
img = cropImg(img);

newImg = imgPadding(img);
[resVectorDirection, magnitudeNormal, actualNormal] = estSurfNorm(newImg);

imshow(img);
hold on;
quiver(actualNormal(:,1), actualNormal(:,2), actualNormal(:,3), actualNormal(:,4));
axis on;