function im = contrast_adjust(im, x_min, x_max)
% contrast_adjust Adjust the contrast of an image
%   Scales the intensity to lie between two values.
% INPUTS
%   im    - Image to adjust.
%   x_min - Lower bound (e.g. 0)
%   x_max - Upper bound (e.g. 255)
% OUTPUTS
%   im - Adjusted image.

immin = double(min(im(:)))+x_min;
immax = double(max(im(:)))-x_max;
im = (im - immin) / (immax - immin) * 255;

end