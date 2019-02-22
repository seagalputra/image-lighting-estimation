function imgSplit = createImagePatch(img, rows, cols)
%CREATEIMAGEPATCH Create patch from image in N x N size
%   Detailed explanation goes here

if nargin < 2
    rows = 4;
    cols = 4;
end

imgSize = size(img);
imgSplit = mat2tiles(img, ceil(imgSize(1:2)./[rows cols]))';
end