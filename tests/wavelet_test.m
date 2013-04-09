clear;
clc;
im_original = double(rgb2gray(imread('input\lena.jpg')));

mode = 'haar';

% Pascal 2D-DWT
[ll_p lh_p hl_p hh_p] = dwt2_pascal(im_original, mode);
im_wavelet_pascal = [ll_p, lh_p; hl_p, hh_p];

% Matlab 2D-DWT
[ll_m lh_m hl_m hh_m] = dwt2(im_original, mode);
im_wavelet_matlab = [ll_m, lh_m; hl_m, hh_m];

% Show
subplot(2,2,1);
imshow(im_wavelet_matlab, [0 255]);
title('Matlab [im->DWT]');
subplot(2,2,2);
imshow(im_wavelet_pascal, [0 255]);
title('Pascal [im->DWT]');

% Pascal 2D-IDWT
im_wavelet_pascal_i = idwt2_pascal(ll_p, lh_p, hl_p, hh_p, mode);

% Matlab 2D-IDWT
im_wavelet_matlab_i = idwt2(ll_m, lh_m, hl_m, hh_m, mode);

% Show
subplot(2,2,3);
imshow(im_wavelet_matlab_i, [0 255]);
title('Matlab [im->DWT->IDWT]');
subplot(2,2,4);
imshow(im_wavelet_pascal_i, [0 255]);
title('Pascal [im->DWT->IDWT]');