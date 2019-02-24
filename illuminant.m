clear;
clc;
close all;

% 1. Load and Prepare Image
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

% 2. Region Selection
% computing edge level percentage and avg gray value every local region
edgeLevel = [];
avgGray = [];
for i = 1:length(imgSplit)
    edgeLevel = [edgeLevel, calcEdgeLevel(bwSplit{i})];
    avgGray = [avgGray, mean(imgSplit{i}(:))];
end
% sort into ascending order
[edgeLevelSort, indexEdge] = sort(edgeLevel);
% rearrange every local region based on Eq.(2)
newImgSplit = imgSplit(indexEdge);
% sort average gray value and obtain first eight values
[avgGraySort, indexGray] = sort(avgGray);
B = avgGraySort(1:8);
indexB = indexGray(1:8);
% select region that meet condition
C = {};
for i = 1:length(newImgSplit)
    avgGrayImg = mean(newImgSplit{i}(:));
    if (ismember(avgGrayImg, B) == 0 && length(C) ~= 3)
        C{end+1} = newImgSplit{i};
    end
end
% TODO: 3. Illuminant Direction Estimation