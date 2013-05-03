clc;
clear variables;
[dir_input, dir_output, dir_results] = steganography_init();

%@@ Input image and output location
carrier_image_filename = 'peppers.jpg';
output_image_filename = 'stegoimage_wdct.jpg';

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

% Name of folder to store test results in
if use_greyscale
    test_name = ['WDCT_', carrier_image_filename, '_grey'];
else
    test_name = ['WDCT_', carrier_image_filename];
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
im = imload([dir_input, carrier_image_filename], use_greyscale);
[w h ~] = size(im);
msg_length_max = w / 16 * h / 16; % One bit per 8x8, in one quarter
msg_length_max = ceil(msg_length_max / 8); % Convert to bytes
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

if use_greyscale
    imc = im;
else
    imc = im(:,:,channel);
end

tic;
[imc_stego, im_wavelet] = steg_wdct_encode(imc, secret_msg_bin, mode, frequency_coefficients, persistence);
encode_time = toc;

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
imwrite(uint8(im_stego), [dir_output, output_image_filename], 'Quality', output_quality);

% Decode
% ======

% Read and take chosen channel
im_stego = imload([dir_output, output_image_filename], use_greyscale);

if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

% Extract message
tic;
[extracted_msg_bin] = steg_wdct_decode(imc_stego, mode, frequency_coefficients);
decode_time = toc;

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