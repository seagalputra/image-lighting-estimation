function edgeLevel = calcEdgeLevel(img)

% assume that image is in binary image
sizeBw = size(img);
A = nnz(img);
edgeLevel = A / sum(sizeBw);
end