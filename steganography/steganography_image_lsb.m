% Get rid of junk
clear all;
close all;
clc;
clf;

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = 'input\lena.jpg';
output_image_filename = 'output\lena_lsb.png';
cd('C:\Users\Muffin\Documents\GitHub\Steganography');
output_mode = 'lossless'; % Fails on 'lossy'
output_quality = 100;

%@@ Message string to encode into carrier image
secret_msg_str = repmat('Mary had a little lamb, its fleece was white as snow...', 1, 100);

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

secret_msg_bin = str2bin(secret_msg_str);
im = imread(carrier_image_filename);

% Perform LSB steganography encoding on one channel
imc = im(:,:,channel);
imc_stego = steg_lsb_encode(imc, secret_msg_bin);
im_stego = im;
im_stego(:,:,channel) = imc_stego;

imshow(im_stego, [0 255]);

% Write and read
imwrite(im_stego, output_image_filename); %, 'Mode', output_mode, 'Quality', output_quality);
im_stego = imread(output_image_filename);
imc_stego = im_stego(:,:,channel);

% Decode
% ======
extracted_msg_bin = steg_lsb_decode(imc_stego);
extracted_msg_str = bin2str(extracted_msg_bin);
disp(extracted_msg_str);