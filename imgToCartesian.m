%% generating random "image" data
% a = rand(100,100);
a = imread('examples/1_l4c2.png');
% initial axis
h = axes('position',[0 0 1 1]);
colormap bone
% plotting image
f1 = imagesc(a);
% add axis
h2 = axes('position',[0 0 1 1]);
t = 0:.01:2*pi;
% make polar plot
f2 = polar(h2,t,sin(2*t).*cos(2*t),'r');
% removing background of polar plot - so image shows through
ph = findall(h2,'type','patch');
set(ph, 'FaceColor', 'none')

%%
I = imread('coins.png');
[ny,nx] = size(I);

imshow(I);
hold on
% center
C = round([nx ny]/2);
plot(C(1),C(2),'*r');
% draw line
P1 = [1 nx];
P2 = [C(2) C(2)];
plot(P1,P2,'b');
P3 = [C(1) C(1)];
P4 = [1 ny];
plot(P3,P4,'b');