clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
output_image_filename = [dir_output, 'lena_egypt.jpg'];

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Width and height in pixels of the secret image, which directly affects
%@@ the maximum capacity:
%@@   max capacity (in bits) = (secret_msg_w / pixel_size) * (secret_msg_h / pixel_size)
%@@   divide by 8 to get it in bytes
%@@ Must be multiples of both block_size and pixel_size
secret_msg_w = 36;
secret_msg_h = 36;

%@@ Output image quality
output_quality = 100;

%@@ Whether to force the image to be greyscale.
%@@ If not greyscale, select which colour channel to use (1=r, 2=g, 3=b)
use_greyscale = true;
channel = 3;

%@@ Wavelet transformation
%@@ [Default: 'idk' if use_greyscale = false, otherwise 'haar']
mode = 'idk';

%@@ Block size: Size in pixels of the blocks that the secret is split up
%@@ into. Smaller values lead to more accuracy and robustness, but slower
%@@ calculation and larger keys. If set as low as 1, then the image is
%@@ effectively the key, and the key is the encoded secret data.
%@@ 4 is generally the best value, because when put back through IDWT it
%@@ effectively becomes 8, making the block_size match JPEG encoding.
%@@ [Default: 4]
block_size = 4;

%@@ Pixel size: When converting the secret message into binary, and storing
%@@ it in the form of an image as black and white pixels, this controls how
%@@ big those pixels are, in pixels. Larger values lead to more robustness,
%@@ but less capacity.
%@@ [Default: 3]
pixel_size = 3;

% Set to true, because we are encoding secret binary data, not an image
is_binary = true;

% Load images
im_carrier = imload(carrier_image_filename, use_greyscale);

[im_carrier_w im_carrier_h ~] = size(im_carrier);
if isempty(secret_msg_str)
    secret_msg_str = generate_test_message(((secret_msg_w / pixel_size) * (secret_msg_h / pixel_size)) / 8);
end;
secret_msg_bin = str2bin(secret_msg_str);

im_secret = bin2binimg(secret_msg_bin, secret_msg_w / pixel_size, secret_msg_h / pixel_size, pixel_size, 255);

if use_greyscale
    imc_carrier = im_carrier;
else
    imc_carrier = im_carrier(:,:,channel);
end

[imc_stego, key1, key2, im_wavelet_stego, im_wavelet_secret] = steg_egypt_encode(imc_carrier, im_secret, mode, block_size, is_binary);

if use_greyscale
    im_stego = imc_stego;
else
    im_stego = im_carrier;
    im_stego(:,:,channel) = imc_stego;
end

% Write stego image to file
imwrite(uint8(im_stego), output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Load G
im_stego = imload(output_image_filename, use_greyscale);

% Perform Egypt decoding
if use_greyscale
    imc_stego = im_stego;
else
    imc_stego = im_stego(:,:,channel);
end

[im_extracted, im_errors] = steg_egypt_decode(imc_stego, secret_msg_w, secret_msg_h, key1, key2, mode, block_size, is_binary);

% Extract the binary data from the extracted image
extracted_msg_bin = binimg2bin(im_extracted, pixel_size, 127);

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
steganography_statistics(im_carrier, im_stego, secret_msg_bin, extracted_msg_bin);