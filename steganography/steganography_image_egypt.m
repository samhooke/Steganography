clc;
clear variables;
[dir_input, dir_output, dir_results] = steganography_init();

%@@ Input image and output location
carrier_image_filename = 'peppers.jpg';
output_image_filename = 'stegoimage_egypt.jpg';

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Whether to force the image to be greyscale.
%@@ If not greyscale, select which colour channel to use (1=r, 2=g, 3=b)
use_greyscale = true;
channel = 3;

%@@ How many test iterations to do
%@@ To test from 100% to 0% quality, set to 101
iteration_total = 101;

%@@ Whether to use hamming coding (halves capacity, increases robustness)
use_hamming = false;

% Name of folder to store test results in
if use_greyscale
    test_name = ['Egypt_', carrier_image_filename, '_grey'];
else
    test_name = ['Egypt_', carrier_image_filename];
end

% Create directory for results if running iteration test
if iteration_total > 1
    [dir_results_full, ~] = create_directory_unique([dir_results, test_name]);
    iteration_data = zeros(7, iteration_total);
    output_csv_filename = [dir_results_full, test_name, '_results.csv'];
end

for iteration_current = 1:iteration_total

% Encode
% ======

%@@ Width and height in pixels of the secret image, which directly affects
%@@ the maximum capacity:
%@@   max capacity (in bits) = (secret_msg_w / pixel_size) * (secret_msg_h / pixel_size)
%@@   divide by 8 to get it in bytes
%@@ Must be multiples of both block_size and pixel_size
secret_msg_w = 96;
secret_msg_h = 96;

%@@ Output image quality
if iteration_total == 1
    output_quality = 100;
else
    % If performing a test, try all qualities from 100 to 0
    output_quality = 100 - (iteration_current - 1);
end

%@@ Wavelet transformation
%@@ [Default: 'idk' or sometimes 'haar']
mode = 'idk';

%@@ Block size: Size in pixels of the blocks that the secret binary image
%@@ is split up into. Generally, smaller values lead to more accuracy and
%@@ robustness, but slower calculation and larger keys.
%@@ [Default: usually between 1 and 32]
block_size = 4;

%@@ Square size: When converting the secret message into a binary image,
%@@ this controls the size in pixels of the squares used to represent each
%@@ bit. Generally, larger values lead to more robustness, but less
%@@ capacity.
%@@ [Default: 1 to 16]
square_size = 3;

% Set to true, because we are encoding secret binary data, not an image
is_binary = true;

% Load images
im = imload([dir_input, carrier_image_filename], use_greyscale);

[im_carrier_w im_carrier_h ~] = size(im);
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(((secret_msg_w / square_size) * (secret_msg_h / square_size)) / 8);
end;
secret_msg_bin = str2bin(secret_msg_str);

if use_hamming
    % Hamming encode
    secret_msg_bin_raw = zeros(1, length(secret_msg_bin));
    secret_msg_bin = secret_msg_bin(1:length(secret_msg_bin)/2);
    secret_msg_bin_hamming = hamming_encode_chunk(secret_msg_bin);
    secret_msg_bin_raw(1:length(secret_msg_bin_hamming)) = secret_msg_bin_hamming;
else
    secret_msg_bin_raw = secret_msg_bin;
end
    
if use_greyscale
    imc = im;
else
    imc = im(:,:,channel);
end

tic;
% Convert binary data to image
im_secret = bin2binimg(secret_msg_bin_raw, secret_msg_w / square_size, secret_msg_h / square_size, square_size, 255);

[imc_stego, key1, key2, im_wavelet_stego, im_wavelet_secret] = steg_egypt_encode(imc, im_secret, mode, block_size, is_binary);
encode_time = toc;

if use_greyscale
    im_stego = imc_stego;
else
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

% Write stego image to file
imwrite(uint8(im_stego), [dir_output, output_image_filename], 'Quality', output_quality);

% Decode
% ======

% Load G
im_stego = imload([dir_output, output_image_filename], use_greyscale);

% Perform Egypt decoding
if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

tic;
[im_extracted, im_errors] = steg_egypt_decode(imc_stego, secret_msg_w, secret_msg_h, key1, key2, mode, block_size, is_binary);

% Extract the binary data from the extracted image
extracted_msg_bin_raw = binimg2bin(im_extracted, square_size, 127);

if use_hamming
    % Hamming decode
    extracted_msg_bin = hamming_decode_chunk(extracted_msg_bin_raw);
else
    extracted_msg_bin = extracted_msg_bin_raw;
end
decode_time = toc;

% Take the raw extracted image, and make the values either 0 or 255
im_extracted_bin = im_extracted;
im_extracted_bin(im_extracted_bin < 127) = 0;
im_extracted_bin(im_extracted_bin >= 127) = 255;

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
imshow(im_extracted_bin, [0 255]);
title('Secret image - after');

% Print statistics
[length_bytes, msg_similarity_py, msg_similarity, im_psnr] = steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin, encode_time, decode_time);

% Log data if running multiple tests
if iteration_total > 1
    iteration_data(((iteration_current - 1) * 7) + 1:((iteration_current - 1) * 7) + 1 + 6) = [output_quality, msg_similarity_py * 100, msg_similarity * 100, im_psnr, encode_time, decode_time, length_bytes];
    imwrite(uint8(im_stego), sprintf('%s%d.jpg', dir_results_full, output_quality));
end
    
end

% Save data log to file
if iteration_total > 1
    test_data_save(output_csv_filename, iteration_data');
    fprintf('Saved results at: %s\n', output_csv_filename);
end