function binimg = bin2binimg(bin, bin_width, bin_height, pixel_size, pixel_amplitude)
% bin2binimg() Converts a binary string to a binary image
%    bin             - Binary to convert, of length bin_width * bin_height
%    bin_width       - How wide the output image should be
%    bin_height      - How high the output image should be
%    pixel_size      - How many pixels wide/high each pixel should be
%    pixel_amplitude - What value should represent binary 1

if length(bin) ~= bin_width * bin_height
    error('length(bin) must be equal to bin_width * bin_height');
else
    binimg = zeros(bin_width * pixel_size, bin_height * pixel_size);
    
    pixel_1 = ones(pixel_size, pixel_size);
    pixel_0 = zeros(pixel_size, pixel_size);
    
    pos = 0;
    for y = 0:bin_height-1
        for x = 0:bin_width-1
            %fprintf('%d,%d\n', x, y);
            pos = pos + 1;
            if bin(pos) == 1
                pixel = pixel_1;
            else
                pixel = pixel_0;
            end
            a = x * pixel_size;
            b = y * pixel_size;
            binimg(a+1:a+pixel_size, b+1:b+pixel_size) = pixel;
        end
    end
end

binimg = binimg * pixel_amplitude;

end