function vertices = boundary_img(BW, gaps)
% trace a boundary
bw_index = find(BW);
% set first index for initial point to trace
[row, cols] = ind2sub(size(BW), bw_index(1));
boundary_idx = bwtraceboundary(BW, [row cols], 'N');
% to make point between pixel image, use a gap value.
idx = [];
for i = 1:size(boundary_idx,1)
    if (mod(i,gaps) == 0)
        idx = [idx; boundary_idx(i,:)];
    end
end
vertices = [idx(:,2) idx(:,1)];
end

