clear;
clc;
close all;

img = imread('examples/1_l1c1.png');

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

%% Create block matrix of C
matDiag1 = [-1 0; 0 -1];
matDiag2 = [1 0; 0 1];
newMatDiag = cat(2, matDiag1, matDiag2);
cellC = {newMatDiag};
cellC = repmat(cellC, [1 220]);
blockC = blkdiag(cellC{:});
 
% blockC = [blockC zeros(size(blockC,1),1)];
blockC = [blockC zeros(size(blockC,1),3)];

%% Hestenes-Powell multiplier method

% Initialization
% Compute error function for initialization
v = inv(blockM' * blockM) * blockM' * b;
error = norm((blockM*v) - b,2);
epsilon = 0.01;
lambda = 1;
options = optimset('PlotFcns',@optimplotfval);
x0 = v;
j = 1;
while (norm(blockC*v,2) >= epsilon)
    sigma = j^2;
    f = @(v,lambda,sigma)norm((blockM*v) - b,2) + lambda*norm(blockC*v) + sigma*norm(blockC*v,2) / 2;
    fun = @(v)f(v,lambda,sigma);
    result = fminsearch(fun, x0, options);
    lambda = lambda + sigma*norm(blockC*v);
    v = result;
    j = j + 1;
end