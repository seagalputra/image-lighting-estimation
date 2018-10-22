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
[height, width] = size(img);

newImg = imgPadding(img);
[resVectorDirection, magnitudeNormal, actualNormal] = estSurfNorm(newImg);

imshow(img);
hold on;
quiver(actualNormal(:,1), actualNormal(:,2), actualNormal(:,3), actualNormal(:,4));
axis on;