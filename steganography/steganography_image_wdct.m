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

%@@ Colour channel
channel = 2;

%@@ Output image quality
output_quality = 97;

%@@ Transform function
mode = 'db1';

%@@ Coefficients
frequency_coefficients = [7 6; 5 2];

% Load image, generate message if necessary
im = imread(carrier_image_filename);
[w h ~] = size(im);
msg_length_max = w / 16 * h / 16; % One bit per 8x8, in one quarter
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

im = double(im);
imc = im(:,:,channel);

[imc_stego, im_wavelet] = steg_wdct_encode(imc, secret_msg_bin, mode, frequency_coefficients);

im_stego = im;
im_stego(:,:,channel) = imc_stego;

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
im_stego = double(imread(output_image_filename));
imc_stego = im_stego(:,:,channel);

% Extract message
[extracted_msg_bin] = steg_wdct_decode(imc_stego, mode, frequency_coefficients);
extracted_msg_str = bin2str(extracted_msg_bin);
fprintf('Extracted (%d bytes): %s\n', length(extracted_msg_str), extracted_msg_str);