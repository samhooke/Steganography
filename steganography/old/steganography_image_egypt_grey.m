clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
secret_image_filename = [dir_input, 'peppers_small.jpg'];
output_image_filename = [dir_output, 'lena_egypt_grey.jpg'];

%@@ Output image quality
output_quality = 75;

%@@ Wavelet transformation
%@@ [Default: idk]
mode = 'idk';

%@@ Block size
%@@ [Default: 4]
block_size = 4;

% Load images
im_carrier = double(rgb2gray(imread(carrier_image_filename)));
im_secret = double(rgb2gray(imread(secret_image_filename)));

% Perform Egypt encoding
[im_stego, key1, key2, im_wavelet_stego, im_wavelet_secret] = steg_egypt_encode(im_carrier, im_secret, mode, block_size);

% Write stego image to file
imwrite(uint8(im_stego), output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Load G
im_stego = double(imread(output_image_filename));

% Need to know the size of the secret image for extracting
[im_secret_width, im_secret_height] = size(im_secret);

% Perform Egypt decoding
[im_extracted, im_errors] = steg_egypt_decode(im_stego, im_secret_width, im_secret_height, key1, key2, mode, block_size);

% Calculate min & max values to ensure wavelet based images use same scale
wmin = min(min(min(min(im_wavelet_secret)), min(min(im_wavelet_stego))), min(min(im_errors)));
wmax = max(max(max(max(im_wavelet_secret)), max(max(im_wavelet_stego))), max(max(im_errors)));

% Output results
subplot(2,3,1);
imshow(im_wavelet_secret, [wmin wmax]);
title('Secret image (wavelet transformed)');
subplot(2,3,4);
imshow(im_wavelet_stego, [wmin wmax]);
title('Stego image (wavelet transformed)');

subplot(2,3,2);
imshow(uint8(im_stego), [0 255]);
title('Stego image');
subplot(2,3,5);
imshow(im_errors, [wmin wmax]);
title('Error blocks');

subplot(2,3,3);
imshow(im_secret, [0 255]);
title('Secret image - before');
subplot(2,3,6);
imshow(im_extracted, [0 255]);
title('Secret image - after');