clear;
clc;
close all;

%% Load image and convert to grayscale image

% Using image demos in MATLAB folder
img = imread('toysnoflash.png');

% convert image to grayscale if image is in RGB color channel
if (size(img, 3) == 3)
    img = rgb2gray(img);
end

img = imcrop(img);

% maintain image in 1:1 size ratio
sizeImg = size(img);
overPixel = mod(sizeImg, 9);
img = img(1:sizeImg(1)-overPixel(1),1:sizeImg(2)-overPixel(2));

%% Compute surface normal

newImg = imgPadding(img);
[resVectorDirection, magnitudeNormal, actualNormal] = estSurfNorm(newImg);

% imshow(img);
% hold on;
% quiver(actualNormal(:,1), actualNormal(:,2), actualNormal(:,3), actualNormal(:,4));
% axis on;

%% Divide image into k small planes every plane contains 9x9 pixels

sz = size(img);
chunkSize = [9 9];
sc = sz ./ chunkSize;

imgSplit = mat2cell(img, chunkSize(1) * ones(sc(1),1), chunkSize(2) * ones(sc(2),1));