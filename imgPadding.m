function newImg = imgPadding(img)
%IMGPADDING Create new image with black padding in outer image
%   Sometimes we need to create black padding in our image, especially for
%   perform convolution or neighborhood matrix definition. By creating
%   blank matrix with size (W+2)x(H+2), we can place our new image in that
%   blank matrix.

sizeImg = size(img);
newImg = zeros(sizeImg + 2);

for i = 1:sizeImg(1)
    for j = 1:sizeImg(2)
        newImg(i+1, j+1) = img(i, j);
    end
end

newImg = uint8(newImg);

end