clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_fusion.jpg'];

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Whether to force the image to be greyscale.
%@@ If not greyscale, select which colour channel to use (1=r, 2=g, 3=b)
use_greyscale = true;
channel = 3;

%@@ Output image quality
output_quality = 90;

%@@ Alpha value for encoding
alpha = 0.05;

%@@ Wavelet transformation
mode = 'db1';

% Load image, generate message if necessary
im = imload(carrier_image_filename, use_greyscale);
[w h ~] = size(im);
msg_length_max = w / 2 * h / 2; % One bit per pixel, in one quarter
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

[imc_stego, im_wavelet_original, im_wavelet_stego] = steg_fusion_encode(imc, secret_msg_bin, alpha, mode);

if use_greyscale
    im_stego = imc_stego;
else
    im_stego = im;
    im_stego(:,:,channel) = imc_stego;
end

% Output
subplot(2,2,1);
imshow(uint8(im), [0 255]);
title('Original image');
subplot(2,2,2);
imshow((im_wavelet_original));
title('Original wavelet transform');
subplot(2,2,3);
imshow((im_wavelet_stego));
title('Stego wavelet transform');
subplot(2,2,4);
imshow(uint8(im_stego));
title('Stego image');

imwrite(uint8(im_stego), output_image_filename, 'quality', output_quality);

% Decode
% ======

im_stego = imload(output_image_filename, use_greyscale);
im_original = imload(carrier_image_filename, use_greyscale);

if use_greyscale
    imc_stego = im_stego;
    imc_original = im_original;
else
    imc_stego = im_stego(:,:,channel);
    imc_original = im_original(:,:,channel);
end
    
[extracted_msg_bin] = steg_fusion_decode(imc_stego, imc_original, mode);

extracted_msg_str = bin2str(extracted_msg_bin);

% Print statistics
steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin);