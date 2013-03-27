clear all;
close all;
clc;

cd('C:\Users\Muffin\Documents\GitHub\Steganography\');

im_original = imread('input\lena.jpg');

im_original = imresize(im_original, 0.125);

subplot(3,3,1);
imshow(im_original);
title('RGB (original)');

im_hsv = rgb2hsv(im_original);
im_ycbcr = rgb2ycbcr(im_original);

subplot(3,3,2);
imshow(im_hsv);
title('RGB -> HSV');
subplot(3,3,3);
imshow(im_ycbcr);
title('RGB -> YCbCr');

im_hsv2 = hsv2rgb(im_hsv);
im_ycbcr2 = ycbcr2rgb(im_ycbcr);

subplot(3,3,5);
imshow(im_hsv2);
title('RGB -> HSV -> RGB');
subplot(3,3,6);
imshow(im_ycbcr2);
title('RGB -> YCbCr -> RGB');

im_hsv3 = uint8(im_hsv2 * 255); % Needs 255 for some reason?
im_ycbcr3 = uint8(im_ycbcr2);

subplot(3,3,8);
imshow(im_hsv3);
title('RGB -> HSV -> RGB -> uint8 * 255');
subplot(3,3,9);
imshow(im_ycbcr3);
title('RGB -> YCbCr -> RGB -> uint8');

imwrite(im_hsv2, 'output\lena_colourspace_hsv2.png');
imwrite(im_hsv3, 'output\lena_colourspace_hsv3.png');
imwrite(im_ycbcr2, 'output\lena_colourspace_ycbcr2.png');
imwrite(im_ycbcr3, 'output\lena_colourspace_ycbcr3.png');