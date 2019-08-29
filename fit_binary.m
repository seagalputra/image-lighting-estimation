clear; clc; close all;

% fit binary mask image
img = imread('https://i.stack.imgur.com/k03LQ.jpg');
img = rgb2gray(img);
% create binary image
bw = imbinarize(img);
% find indices non-zero value in binary image
[row, col] = find(bw);

% because there are two lines in images, so i need to split the points to
% each specific line
right = col<300;
col_right = col(right);
row_right = row(right);
col_left = col(~right);
row_left = row(~right);

% since the curve is close to vertical, it would be better to use x = f(y)
% rather than using y = f(x) and use 3 degree polynomial
point_right = polyfit(row_right, col_right, 3);
point_left = polyfit(row_left, col_left, 3);

% plot the fitted line
yy = linspace(1, size(bw,1), 50);
figure, imshow(bw, 'border', 'tight');
hold all;
plot(polyval(point_right, yy), yy, '.-', 'LineWidth', 1);
plot(polyval(point_left, yy), yy, '.-', 'LineWidth', 1);
