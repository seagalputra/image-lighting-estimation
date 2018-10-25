function newImg = aspectRatio(img, n)
%ASPECTRATIO Maintain image into 1:1 aspect ratio
%   Need to maintain image into square ratio for split image in n chunks 

sizeImg = size(img);
overPixel = mod(sizeImg, n);
newImg = img(1:sizeImg(1) - overPixel(1), 1:sizeImg(2) - overPixel(2));
end

