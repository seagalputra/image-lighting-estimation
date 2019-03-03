function [imgSplit] = splitImage(img, n)
%SPLITIMAGE Split image in desirable chunks
%   Divide image into k small planes every plane contains nxn pixels
%   
%   newImg = splitImage(img, n)
%
%   input,
%       img : A M x N image data
%       n   : Desirable chunk size
%
%   output,
%       imgSplit : A cell array contain split uint8 image data

sz = size(img);
chunkSize = [n n];
sc = sz ./ chunkSize;
imgSplit = mat2cell(img, chunkSize(1) * ones(sc(1),1), chunkSize(2) * ones(sc(2),1));

end

