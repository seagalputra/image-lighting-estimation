% Implementation of paper 
% "Illuminant Direction Estimation for a Single Image Based on 
% Local Region Complexity Analysis and Average Gray Value"

clear;
clc;
close all;

% 1. Load and Prepare Image
% load image
img = imread('examples/1_l1c1.png');
[imgSplit, bwSplit] = preprocessImage(img);

% 2. Region Selection
[imgC, edgeLevel, indexC] = regionSelect(imgSplit, bwSplit);

% 3. Illuminant Direction Estimation
% calculate surface normal using neighborhood method
C = [-1 0 1 0 0; 0 -1 0 1 0];
for i = 1:length(imgC)
    vectorDirection{i} = estSurfNorm(imgC{i});
    % removing edge pixel in image and obtain intensity of image
    temp = double(imgC{i});
    temp(1,:) = []; temp(size(imgC{i},1)-1,:) = []; temp(:,1) = []; temp(:,size(imgC{i},2)-1) = [];
    imgIntensity{i} = reshape(temp.',[],1);
end

% define function for computing lighting direction v
v = @(M,C,b) pinv(M.'*M + eig(C.'*C))*M.'*b;

for j = 1:length(imgC)
    if j == 3
        % create block diagram M
        tempM = blkdiag(vectorDirection{j}, vectorDirection{j-2});
        oneM = ones(length(tempM),1);
        M = [tempM oneM];
        % append intensity of image
        b = [imgIntensity{j}; imgIntensity{j-2}];
        % computing L(j,j-2)
        direction{j} = v(M,C,b);
    else
        % create block diagram M
        tempM = blkdiag(vectorDirection{j}, vectorDirection{j+1});
        oneM = ones(length(tempM),1);
        M = [tempM oneM];
        % append intensity of image
        b = [imgIntensity{j}; imgIntensity{j+1}];
        % computing L(j,j+1)
        direction{j} = v(M,C,b);
    end
end
% Computing weight of L(1,2); L(2,3) and L(3,1)