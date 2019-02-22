clear;
clc;
close all;

% load image
img = imread('examples/1_l1c1.png');

% convert image RGB to YCbCr
imgYcbcr = rgb2ycbcr(img);
Y = imgYcbcr(:,:,1);
% edge detection using canny edge
BW = edge(Y, 'canny');

% Divide image into 16 blocks
imgSplit = createImagePatch(Y, 4, 4);
bwSplit = createImagePatch(BW, 4, 4);

%  Region Selection
% computing edge level percentage and avg gray value
edgeLevel = [];
avgGray = [];
for i = 1:length(imgSplit)
    edgeLevel = [edgeLevel, calcEdgeLevel(bwSplit{i})];
    avgGray = [avgGray, mean(imgSplit{i}(:))];
end
% sort into ascending order
[edgeLevelSort, indexEdge] = sort(edgeLevel);
[avgGraySort, indexGray] = sort(avgGray);