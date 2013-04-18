clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_lsb.jpg'];

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

% Load image, generate message if necessary
im = uint8(imload(carrier_image_filename, use_greyscale));
[w h ~] = size(im);
msg_length_max = w * h; % One bit per pixel
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

imc_stego = steg_lsb_encode(imc, secret_msg_bin);

if use_greyscale
    im_stego = imc_stego;
else
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end
    
% Compare carrier and stego image
subplot(1,2,1);
imshow(uint8(im), [0 255]);
title('Carrier');
subplot(1,2,2);
imshow(uint8(im_stego), [0 255]);
title('Stego');

% Write
imwrite(uint8(im_stego), output_image_filename);

% Decode
% ======

im_stego = uint8(imload(output_image_filename, use_greyscale));

if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

extracted_msg_bin = steg_lsb_decode(imc_stego);

% Print statistics
steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin);