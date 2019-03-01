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
imgC = regionSelect(imgSplit, bwSplit);

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
% Computing L(1,2)
% create block diagram M
M = blkdiag(vectorDirection{1}, vectorDirection{2});
oneM = ones(length(M),1);
M = [M oneM];
% append intensity of image in region 1 and 2
b = [imgIntensity{1}; imgIntensity{2}];
% solving equation
syms v lambda
f1 = (2*(M.'*M)*v) - (C.'*lambda) - (2*M.'*b) == 0;
f2 = C*v == 0;
% define error function and constraint function
% err1 = @(v) norm((M*v)-b)^2;
% err2 = @(v) norm(C*v)^2;
% A = [];
% b = [];
% Aeq = [];
% beq = [];