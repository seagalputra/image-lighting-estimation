function [imgCropped, posRect] = cropImg(img)
%CROPIMG Select region of image
%   Select some region in the image. Don't worry, it's just normal croping
%   function.

imshow(img);
hRect = imrect();
posRect = hRect.getPosition();
posRect = round(posRect);
imgCropped = img(posRect(2) + (0:posRect(4)), posRect(1) + (0:posRect(3)));

end

