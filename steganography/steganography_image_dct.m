clc;
clear variables;
[dir_input, dir_output, dir_results] = steganography_init();

%@@ Name of folder to store test results in
test_name = 'DCT_grey';

%@@ How many test iterations to do
%@@ To test from 100% to 0% quality, set to 101
iteration_total = 101;

dir_results = [dir_results, test_name, '\'];
if iteration_total > 1
    if exist(dir_results, 'dir')
        error('Directory "%s" already exists!', dir_results);
    end
    mkdir(dir_results);
end
mkdir(dir_results);
iteration_data = zeros(7, iteration_total);
output_csv_filename = [dir_results, 'results.csv'];

for iteration_current = 1:iteration_total

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_dct.jpg'];

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Whether to force the image to be greyscale.
%@@ If not greyscale, select which colour channel to use (1=r, 2=g, 3=b)
use_greyscale = true;
channel = 3;

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
im = imload(carrier_image_filename, use_greyscale);

%%%im = rgb2hsv(im);

[w h ~] = size(im);
msg_length_max = w / 8 * h / 8; % One bit per 8x8
msg_length_max = msg_length_max / 8; % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

if use_greyscale
    imc = im;
else
    % Take chosen channel from the image and encode
    imc = im(:,:,channel);
end

tic;
[imc_stego bits_written bits_unused] = steg_dct_encode(secret_msg_bin, imc, frequency_coefficients, persistence);
encode_time = toc;

if use_greyscale
    im_stego = imc_stego;
else
    % Put the channels back together, and write
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

%%%im_stego = hsv2rgb(im_stego);

imwrite(uint8(im_stego), output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Read image and take chosen channel
im_stego = imload(output_image_filename, use_greyscale);

%%%im_stego = rgb2hsv(im_stego);

if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

% Decode
tic;
[extracted_msg_bin] = steg_dct_decode(imc_stego, frequency_coefficients);
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
    imwrite(uint8(im_stego), sprintf('%s%d.jpg', dir_results, output_quality));
end
    
end

% Save data log to file
if iteration_total > 1
    test_data_save(output_csv_filename, iteration_data');
end