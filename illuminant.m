clear;
clc;
close all;

% load image
img = imread('data/1/1_l1c1.png');

% convert image RGB to YCbCr
img_ycbcr = rgb2ycbcr(img);
% edge detection using canny edge
BW = edge(img_ycbcr(:,:,1), 'canny');
subplot(121);
imshow(img_ycbcr(:,:,1));
title('Y Luminance');
subplot(122);
imshow(BW);
title('Canny Filter');

% Divide image into 16 blocks
imgSplit = createImagePatch(img, 4, 4);
bwSplit = createImagePatch(BW, 4, 4);

% computing edge level percentage
edgeLevel = [];
for i = 1:size(bwSplit)
    for j = 1:size(bwSplit)
        edgeLevel = [edgeLevel, calcEdgeLevel(bwSplit{i,j})];
    end
end
% sort into ascending order
[edgeLevelSort, index] = sort(edgeLevel);