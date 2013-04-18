clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_dct_grey.jpg'];

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

im = rgb2gray(im);

[w h ~] = size(im);
msg_length_max = w / 8 * h / 8; % One bit per 8x8
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

% Take chosen channel from the image and encode
[im_stego bits_written bits_unused] = steg_dct_encode(secret_msg_bin, im, frequency_coefficients, 25);

% Wwrite
imwrite(im_stego, output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Read image and take chosen channel
im_stego = imread(output_image_filename);

% Decode
[extracted_msg_bin] = steg_dct_decode(im_stego, frequency_coefficients);

% Verify and compare difference
msg_match = isequal(secret_msg_bin, extracted_msg_bin);
difference = (im - im_stego) .^ 2;
difference_sum = sum(difference);

% Display images
subplot(1,3,1);
imshow(im);
title('Carrier');
subplot(1,3,2);
imshow(im_stego);
title('Stego image');
subplot(1,3,3);
imshow(difference);
title('Difference');

% Print statistics
steganography_statistics(im, im_stego, secret_msg_bin, extracted_msg_bin);