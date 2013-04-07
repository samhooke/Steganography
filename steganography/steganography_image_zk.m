clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_zk.jpg'];

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Output image quality
output_quality = 90;

%@@ Coefficients
frequency_coefficients = generate_allowed_coefficients();%;[4 6; 5 2; 6 5];%[4 3; 3 3; 3 4];

% Load image, generate message if necessary
im = imread(carrier_image_filename);
[w h ~] = size(im);
% NOTE: By definition the ZK implementation skips some blocks, so the below
% calculation for msg_length_max is a best case estimation.
msg_length_max = w / 8 * h / 8; % One bit per 8x8
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

% Take the chosen colour channel
imc = im(:,:,channel);

% Perform encoding
variance_threshold = 3; % Higher = more blocks used
minimum_distance_encode = 30; % Higher = more robust; more visible
minimum_distance_decode = 10;
[imc_stego, bits_written, bits_unused, invalid_blocks_encode, debug_invalid_encode] = steg_zk_encode(secret_msg_bin, imc, frequency_coefficients, variance_threshold, minimum_distance_encode);

% Create the stego image, replacing the chosen colour channel
im_stego = im;
im_stego(:,:,channel) = imc_stego;

% Write to file
imwrite(im_stego, output_image_filename, 'Quality', output_quality, 'Mode', 'lossless');

% Decode
% ======

im_stego = imread(output_image_filename);
imc_stego = im_stego(:,:,channel);

% Perform decoding
[extracted_msg_bin, invalid_blocks_decode, debug_invalid_decode] = steg_zk_decode(imc_stego, frequency_coefficients, minimum_distance_decode);
carrier_diff = (imc - imc_stego) .^ 2;

% Display images
subplot(2,3,1);
imshow(im);
title('Lena (carrier)');
subplot(2,3,2);
imshow(im_stego);
title('Lena (stego)');
subplot(2,3,3);
imshow(carrier_diff);
title('Lena (diff^2)');

subplot(2,3,4);
imshow(debug_invalid_encode);
title(sprintf('Invalid encode (%d)', invalid_blocks_encode));
subplot(2,3,5);
imshow(debug_invalid_decode);
title(sprintf('Invalid decode (%d)', invalid_blocks_decode));
subplot(2,3,6);
imshow(~(debug_invalid_encode - debug_invalid_decode));
title('Invalid diff');

% Print statistics
steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin);

%fprintf('Invalid blocks: (encode=%d) (decode=%d)', invalid_blocks_encode, invalid_blocks_decode);