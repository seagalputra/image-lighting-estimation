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
img = aspectRatio(img, 9);

%% Divide image into k small planes every plane contains 9x9 pixels 

imgSplit = splitImage(img, 9);

%% Compute surface normal

M = {};
b = [];
for i = 1:size(imgSplit, 1)
    for j = 1:size(imgSplit, 2)
        tempImg = imgPadding(imgSplit{i,j});
        [resVectorDirection, magnitudeNormal, actualNormal] = estSurfNorm(tempImg);
        vecDirection{i,j} = resVectorDirection;
        % Define vector b
        b = [b reshape(imgSplit{i,j}',[],1)];
        % Construct M matrix
        % M{end+1} = [resVectorDirection ones(81, 1)];
        M{end+1} = [resVectorDirection];
    end
end

%% Obtain lighting direction

% create block matrix of M
blockM = blkdiag(M{:});
blockM = [blockM ones(size(blockM,1),1)];

% create vector b
b = reshape(b,[],1);
b = double(b);

% computer error function
v = inv(blockM' * blockM) * blockM' * b;

error = norm((blockM*v) - b,2);