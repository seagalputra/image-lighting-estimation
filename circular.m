function [center, radius] = circular(BW)

img_stats = regionprops('table', BW, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
center = img_stats.Centroid;
diameter = mean([img_stats.MajorAxisLength(1) img_stats.MinorAxisLength(1)], 2);
radius = diameter/2;
end

