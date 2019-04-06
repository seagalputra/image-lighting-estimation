function [imgSplit, bwSplit] = preprocessImage(img)
%PREPROCESSIMAGE Load and convert RGB image into YCbCr color space

if size(img,3) ~= 3
    temp(:,:,1) = img;
    temp(:,:,2) = img;
    temp(:,:,3) = img;
    img = temp;
end

% convert image RGB to YCbCr
imgYcbcr = rgb2ycbcr(img);
Y = imgYcbcr(:,:,1);
% edge detection using canny edge
BW = edge(Y, 'canny');
% Divide image into 16 blocks
imgSplit = createImagePatch(Y, 4, 4);
bwSplit = createImagePatch(BW, 4, 4);
end

