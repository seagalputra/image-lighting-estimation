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
C = regionSelect(imgSplit, bwSplit);

% TODO: 3. Illuminant Direction Estimation