clear;
clc;
im_original = rgb2gray(imread('input\lena.jpg'));

mode = 'haar';

% Pascal 2D-DWT
im_wavelet_pascal = wavelet_pascal(mode, 1, im_original, 'sym', 1);
im_wavelet_pascal = wavelet_pascal(mode, 1, im_wavelet_pascal, 'sym', 2);

% Matlab 2D-DWT
[ll lh hl hh] = dwt2(im_original, mode);
im_wavelet_matlab = [ll, lh; hl, hh];

% Show
subplot(2,2,2);
imshow(im_wavelet_matlab, [0 255]);
title('Matlab DWT');
subplot(2,2,1);
imshow(im_wavelet_pascal, [0 255]);
title('Pascal DWT');

% Pascal 2D-IDWT
im_wavelet_pascal_i = wavelet_pascal(mode, -1, im_wavelet_pascal, 'sym', 1);
im_wavelet_pascal_i = wavelet_pascal(mode, -1, im_wavelet_pascal_i, 'sym', 2);

% Matlab 2D-IDWT
im_wavelet_matlab_i = idwt2(ll, lh, hl, hh, mode);

% Show
subplot(2,2,3);
imshow(im_wavelet_matlab_i, [0 255]);
title('Matlab IDWT');
subplot(2,2,4);
imshow(im_wavelet_pascal_i, [0 255]);
title('Pascal IDWT');