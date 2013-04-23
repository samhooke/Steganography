function [im2] = cs2cs(im, col_from, col_to)
% cs2cs() Change an image from one colour space to another
%   e.g. cs2cs(im, 'hsv', 'ycbcr');
% INPUTS
%    im       - Image to convert the colour space of
%    col_from - Current colour space
%    col_to   - Colour space to change to
%               Possible colour spaces are:
%               'rgb', 'hsv', 'ycbcr'
% OUTPUTS
%    im2 - Copy of im with colour space changed

col_from = lower(col_from);
col_to = lower(col_to);

switch col_from
    case 'rgb'
        switch col_to
            case 'rgb'
                im2 = im;
            case 'hsv'
                im2 = rgb2hsv(im);
            case 'ycbcr'
                im2 = rgb2ycbcr(im);
        end
    case 'hsv'
        switch col_to
            case 'rgb'
                im2 = hsv2rgb(im);
            case 'hsv'
                im2 = im;
            case 'ycbcr'
                im2 = rgb2ycbcr(hsv2rgb(im));
        end
    case 'ycbcr'
        switch col_to
            case 'rgb'
                im2 = ycbcr2rgb(im);
            case 'hsv'
                im2 = rgb2hsv(ycbcr2rgb(im));
            case 'ycbcr'
                im2 = im;
        end
end
    
end