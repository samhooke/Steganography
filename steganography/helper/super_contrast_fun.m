function im = super_contrast_fun(im, x_min, x_max)
% Fun
immin = double(min(im(:)))+x_min;
immax = double(max(im(:)))-x_max;
im = (im - immin) / (immax - immin) * 255;
end

