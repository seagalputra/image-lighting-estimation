% Implementation of paper 
% "Illuminant Direction Estimation for a Single Image Based on 
% Local Region Complexity Analysis and Average Gray Value"

clear;
clc;
close all;

% 1. Load and Prepare Image
% load image
% img = imread('examples/1_l4c2.png');
img = imread('examples\CroppedYale\yaleB02\yaleB02_P00A+085E-20.pgm');
imshow(img);
[imgSplit, bwSplit] = preprocessImage(img);

% 2. Region Selection
[imgC, edgeLevel, indexC] = regionSelect(imgSplit, bwSplit);

% 3. Illuminant Direction Estimation
% calculate surface normal using neighborhood method
[Lx, Ly, degree, lightDirection] = estLighting(imgC, edgeLevel, indexC);
PhiTheta = azel2phitheta([85; -20]);
disp(PhiTheta);