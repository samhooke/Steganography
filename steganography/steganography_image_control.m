clc;
clear variables;
[dir_input, dir_output, dir_results] = steganography_init();

%@@ Input image and output location
carrier_image_filename = 'peppers.jpg';
output_image_filename = 'stegoimage_control.jpg';

%@@ Whether to force the image to be greyscale.
%@@ If not greyscale, select which colour channel to use (1=r, 2=g, 3=b)
use_greyscale = true;
channel = 3;

%@@ How many test iterations to do
%@@ To test from 100% to 0% quality, set to 101
iteration_total = 101;

% Name of folder to store test results in
if use_greyscale
    test_name = ['Control_', carrier_image_filename, '_grey'];
else
    test_name = ['Control_', carrier_image_filename];
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

% Load image
im = uint8(imload([dir_input, carrier_image_filename], use_greyscale));

if use_greyscale
    imc = im;
else
    % Take chosen channel from the image and encode
    imc = im(:,:,channel);
end

imc_stego = imc;

if use_greyscale
    im_stego = imc_stego;
else
    % Put the channels back together, and write
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

% Write image
imwrite(uint8(im_stego), [dir_output, output_image_filename], 'Quality', output_quality);

% Decode
% ======

% Read image and take chosen channel
im_stego = uint8(imload([dir_output, output_image_filename], use_greyscale));

if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

% Print statistics
[length_bytes, msg_similarity_py, msg_similarity, im_psnr] = steganography_statistics(imc, imc_stego, [], [], 0, 0);

% Log data if running multiple tests
if iteration_total > 1
    iteration_data(((iteration_current - 1) * 7) + 1:((iteration_current - 1) * 7) + 1 + 6) = [output_quality, msg_similarity_py * 100, msg_similarity * 100, im_psnr, 0, 0, length_bytes];
    imwrite(uint8(im_stego), sprintf('%s%d.jpg', dir_results_full, output_quality));
end
    
end

% Save data log to file
if iteration_total > 1
    test_data_save(output_csv_filename, iteration_data');
    fprintf('Saved results at: %s\n', output_csv_filename);
end