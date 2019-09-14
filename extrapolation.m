function int_boundary = extrapolation(img_gray, x, y, nx, ny, offset)
for i = 1:size(x,2)
    int_profile = improfile(img_gray, [x(i) x(i)-nx(i)], [y(i) y(i)+ny(i)], offset);
    % find intensity at boundary point using interp1
    int_boundary(i) = interp1(int_profile, 0, 'linear', 'extrap');
end
end

