function bw = kmeans_seg(img, n_colors, num_replicates)

if (nargin < 3)
    num_replicates = 3;
end

% convert image into L*a*b color space
cform = makecform('srgb2lab');
lab_img = applycform(img, cform);

% classify the colors with K-Means
ab = double(lab_img(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

cluster_idx = kmeans(ab, n_colors, 'distance', 'sqEuclidean', ...
    'Replicates', num_replicates);
pixel_labels = reshape(cluster_idx, nrows, ncols);

% separate each label
binary_mask = cell(1,3);
for i = 1:n_colors
    mask = zeros([size(img,1) size(img,2)]);
    mask(pixel_labels == i) = 1;
    binary_mask{i} = mask;
end

% find the background using the mean of binary image
binary_mean = cellfun(@mean2, binary_mask);
[~, idx] = max(binary_mean);
initial_bw = ~binary_mask{idx};
bw = imfill(initial_bw, 'holes');
end