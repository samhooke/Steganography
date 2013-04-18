clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_wdct.jpg'];

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Whether to force the image to be greyscale.
%@@ If not greyscale, select which colour channel to use (1=r, 2=g, 3=b)
use_greyscale = true;
channel = 3;

%@@ Output image quality
output_quality = 100;

%@@ Transform function
mode = 'db1';

%@@ Coefficients
frequency_coefficients = [7 6; 5 2];

%@@ Persistence
%@@ [Default: 25 if use_greyscale = true, otherwise 100]
if use_greyscale
    persistence = 25;
else
    persistence = 100;
end

% Load image, generate message if necessary
im = imload(carrier_image_filename, use_greyscale);
[w h ~] = size(im);
msg_length_max = w / 16 * h / 16; % One bit per 8x8, in one quarter
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

if use_greyscale
    imc = im;
else
    imc = im(:,:,channel);
end

[imc_stego, im_wavelet] = steg_wdct_encode(imc, secret_msg_bin, mode, frequency_coefficients, persistence);

if use_greyscale
    im_stego = imc_stego;
else
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

% Display images
subplot(2,2,1);
imshow(uint8(im), [0 255]);
title('original');
subplot(2,2,2);
imshow(im_wavelet, [0 255]);
title('haar transform');
subplot(2,2,3);
imshow(uint8(im_stego), [0 255]);
title('reconstructed');
subplot(2,2,4);
imshow((imc-imc_stego).^2, [0 255]);
title('difference');

% Write
imwrite(uint8(im_stego), output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Read and take chosen channel
im_stego = imload(output_image_filename, use_greyscale);

if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

% Extract message
[extracted_msg_bin] = steg_wdct_decode(imc_stego, mode, frequency_coefficients);

% Print statistics
steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin);