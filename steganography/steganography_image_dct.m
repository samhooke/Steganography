clc;
clear variables;
[dir_input, dir_output, dir_results] = steganography_init();

%@@ Input image and output location
carrier_image_filename = 'peppers.jpg';
output_image_filename = 'stegoimage_dct.jpg';

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
    test_name = ['DCT_', carrier_image_filename, '_grey'];
else
    test_name = ['DCT_', carrier_image_filename];
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

%@@ Output image quality
if iteration_total == 1
    output_quality = 100;
else
    % If performing a test, try all qualities from 100 to 0
    output_quality = 100 - (iteration_current - 1);
end

%@@ Coefficients
frequency_coefficients = [3 6; 5 2];

%@@ Persistence
%@@ [Default: 25 if use_greyscale = true, otherwise 100]
if use_greyscale
    persistence = 25;
else
    persistence = 100;
end

% Load image
im = imload([dir_input, carrier_image_filename], use_greyscale);

%%%im = rgb2hsv(im);

[w h ~] = size(im);
msg_length_max = w / 8 * h / 8; % One bit per 8x8
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

if use_hamming
    % Hamming encode
    secret_msg_bin = secret_msg_bin(1:length(secret_msg_bin)/2);
    secret_msg_bin_raw = hamming_encode_chunk(secret_msg_bin);
else
    secret_msg_bin_raw = secret_msg_bin;
end

if use_greyscale
    imc = im;
else
    % Take chosen channel from the image and encode
    imc = im(:,:,channel);
end

tic;
[imc_stego bits_written bits_unused] = steg_dct_encode(secret_msg_bin_raw, imc, frequency_coefficients, persistence);
encode_time = toc;

if use_greyscale
    im_stego = imc_stego;
else
    % Put the channels back together, and write
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

%%%im_stego = hsv2rgb(im_stego);

imwrite(uint8(im_stego), [dir_output, output_image_filename], 'Quality', output_quality);

% Decode
% ======

% Read image and take chosen channel
im_stego = imload([dir_output, output_image_filename], use_greyscale);

%%%im_stego = rgb2hsv(im_stego);

if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

% Decode
tic;
[extracted_msg_bin_raw] = steg_dct_decode(imc_stego, frequency_coefficients);
if use_hamming
    % Hamming decode
    extracted_msg_bin = hamming_decode_chunk(extracted_msg_bin_raw);
else
    extracted_msg_bin = extracted_msg_bin_raw;
end
decode_time = toc;

% Verify and compare difference
msg_match = isequal(secret_msg_bin, extracted_msg_bin);
difference = (imc - imc_stego) .^ 2;
difference_sum = sum(difference);

% Display images
subplot(1,3,1);
imshow(uint8(im));
title('Carrier');
subplot(1,3,2);
imshow(uint8(im_stego));
title('Stego image');
subplot(1,3,3);
imshow(difference);
title('Difference');

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