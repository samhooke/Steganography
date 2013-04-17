function [binstr] = binimg2bin(binimg, pixel_size, pixel_mid)
% binimg2bin() Converts a binary image to a binary string
%    If a "pixel" does not have a value either completely black or white, it
%    will infer its value based upon the average.
% INPUTS
%    binimg     - The image to convert to binary
%    pixel_size - How big each "pixel" is
%    pixel_mid  - Anything below this is 0, anything equal or above is 1

[binimg_width, binimg_height] = size(binimg);

binimg_width = binimg_width / pixel_size;
binimg_height = binimg_height / pixel_size;

binstr = zeros(1, binimg_width * binimg_height);

pos = 0;
for y = 0:binimg_height-1
    for x = 0:binimg_width-1
        %fprintf('%d,%d\n', x, y);
        pos = pos + 1;
        a = x * pixel_size;
        b = y * pixel_size;
        pixel = binimg(a+1:a+pixel_size, b+1:b+pixel_size);
        if mean2(pixel) >= pixel_mid
            binstr(pos) = 1;
        else
            binstr(pos) = 0;
        end
    end
end

end

