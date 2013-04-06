steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = 'input\lena.jpg';
output_image_filename = 'output\lena_lsb2.png';
output_mode = 'lossless'; % Fails on 'lossy'
output_quality = 100;

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

% Load image, generate message if necessary
im = imread(carrier_image_filename);
[w h] = size(im);
msg_length_max = w / 8 * h / 8;
if secret_msg_str == ''
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

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