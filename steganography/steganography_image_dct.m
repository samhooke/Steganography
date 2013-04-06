clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_dct.jpg'];

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Output image quality
output_quality = 75;

%@@ Coefficients
frequency_coefficients = [3 6; 5 2];

% Load image, generate message if necessary
im = imread(carrier_image_filename);

im = rgb2hsv(im);

[w h ~] = size(im);
msg_length_max = w / 8 * h / 8; % One bit per 8x8
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

% Take chosen channel from the image and encode
imc = im(:,:,channel);
[imc_stego bits_written bits_unused] = steg_dct_encode(secret_msg_bin, imc, frequency_coefficients, 0.01);

% Put the channels back together, and write
im_stego = im;
im_stego(:,:,channel) = imc_stego;

im_stego = hsv2rgb(im_stego);

imwrite(im_stego, output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Read image and take chosen channel
im_stego = imread(output_image_filename);

im_stego = rgb2hsv(im_stego);

imc_stego = im_stego(:,:,channel);

% Decode
[extracted_msg_bin] = steg_dct_decode(imc_stego, frequency_coefficients);

% Verify and compare difference
msg_match = isequal(secret_msg_bin, extracted_msg_bin);
difference = (imc - imc_stego) .^ 2;
difference_sum = sum(difference);

% Display images
subplot(1,3,1);
imshow((im));
title('Carrier');
subplot(1,3,2);
imshow((im_stego));
title('Stego image');
subplot(1,3,3);
imshow(difference);
title('Difference');

% Print statistics
steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin);