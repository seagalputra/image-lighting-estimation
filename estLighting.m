function [Lx, Ly, degree, lightDirection] = estLighting(imgC, edgeLevel, indexC)
%ESTLIGHTING Summary of this function goes here
%   Detailed explanation goes here
C = [-1 0 1 0 0; 0 -1 0 1 0];
for i = 1:length(imgC)
    vectorDirection{i} = estSurfNorm(imgC{i});
    % removing edge pixel in image and obtain intensity of image
    temp = double(imgC{i});
    temp(1,:) = []; temp(size(imgC{i},1)-1,:) = []; temp(:,1) = []; temp(:,size(imgC{i},2)-1) = [];
    imgIntensity{i} = reshape(temp.',[],1);
end

% define function for computing lighting direction v
v = @(M,C,b) pinv(M.'*M + eig(C.'*C))*M.'*b;
% v = @(M,C,b) pinv(M.'*M + 10*(C.'*C))*M.'*b;

for j = 1:length(imgC)
    if j == 3
        % create block diagram M
        tempM = blkdiag(vectorDirection{j}, vectorDirection{j-2});
        oneM = ones(length(tempM),1);
        M = [tempM oneM];
        % append intensity of image
        b = [imgIntensity{j}; imgIntensity{j-2}];
        % computing L(j,j-2)
        direction{j} = v(M,C,b);
    else
        % create block diagram M
        tempM = blkdiag(vectorDirection{j}, vectorDirection{j+1});
        oneM = ones(length(tempM),1);
        M = [tempM oneM];
        % append intensity of image
        b = [imgIntensity{j}; imgIntensity{j+1}];
        % computing L(j,j+1)
        direction{j} = v(M,C,b);
    end
end
% Computing weight W(1,2), W(2,3) and W(3,1)
W = @(x,y) 1/(x+y);
edgeLevelC = edgeLevel(indexC);
for i = 1:length(imgC)
    if i == 3
        weight(i) = W(edgeLevelC(i),edgeLevelC(i-2));
    else
        weight(i) = W(edgeLevelC(i),edgeLevelC(i+1));
    end
    finalDirection{i} = weight(i)*direction{i};
end
lightDirection = cell2mat(finalDirection);
lightDirection = sum(lightDirection,2);
Lx = mean([lightDirection(1,1) lightDirection(3,1)]);
Ly = mean([lightDirection(2,1) lightDirection(4,1)]);
degree = atan2(-Lx,Ly)*180/pi;
end