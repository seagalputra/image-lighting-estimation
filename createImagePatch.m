function imgSplit = createImagePatch(img, rows, cols)
%CREATEIMAGEPATCH Create patch from image in N x N size
%   Detailed explanation goes here

if nargin < 2
    rows = 4;
    cols = 4;
end

tempImgSplit = splitImage(img, rows, cols);

% re-arrange cell into 1-row
imgSplit = {};
for i = 1:size(tempImgSplit)
    for j = 1:size(tempImgSplit)
        imgSplit{end+1} = tempImgSplit{i,j};
    end
end
end

function split = splitImage(img, rows, cols)
% Split image into M rows and N cols
imgSize = size(img);
split = mat2tiles(img, ceil(imgSize(1:2)./[rows cols]))';
end