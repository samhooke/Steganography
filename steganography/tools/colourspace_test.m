clear all;
close all;
clc;

im_rgb = imread('input/lena.jpg');

im_hsv = rgb2hsv(im_rgb);
im_rgb2 = hsv2rgb(im_hsv);
im_rgb3 = uint8(im_rgb2);

subplot(2,2,1);
imshow(im_rgb);
title('rgb(1)');
subplot(2,2,2);
imshow(im_hsv);
title('rgb(1) -> hsv(2)');
subplot(2,2,3);
imshow(im_rgb2);
title('hsv(2) -> rgb(3)');
subplot(2,2,4);
imshow(im_rgb3);
title('rgb(3) to uint8');