function im = imload(filename, greyscale)
% imload() Loads image, converts to double and optionally to greyscale
% INPUTS
%   filename  - File to open e.g. 'C:\img.png'
%   greyscale - true/false Whether to convert to greyscale

im = imread(filename);
if greyscale
    % Only convert to greyscale if it is not greyscale
    if numel(size(im)) == 3
        im = rgb2gray(im);
    end
end
im = double(im);

end

