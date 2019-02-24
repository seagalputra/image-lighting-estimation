function C = regionSelect(imgSplit,bwSplit)
%REGIONSELECT Select region in specified condition

% computing edge level percentage and avg gray value every local region
edgeLevel = [];
avgGray = [];
for i = 1:length(imgSplit)
    edgeLevel = [edgeLevel, calcEdgeLevel(bwSplit{i})];
    avgGray = [avgGray, mean(imgSplit{i}(:))];
end
% sort into ascending order
[~, indexEdge] = sort(edgeLevel);
% rearrange every local region based on Eq.(2)
newImgSplit = imgSplit(indexEdge);
% sort average gray value and obtain first eight values
avgGraySort = sort(avgGray);
B = avgGraySort(1:8);
% select region that meet condition
C = {};
for i = 1:length(newImgSplit)
    avgGrayImg = mean(newImgSplit{i}(:));
    if (ismember(avgGrayImg, B) == 0 && length(C) ~= 3)
        C{end+1} = newImgSplit{i};
    end
end

end