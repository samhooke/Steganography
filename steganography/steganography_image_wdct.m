steganography_init();

%@@ Input image and output location
carrier_image_filename = 'input\lena.jpg';
output_image_filename = 'output\lena_haar.jpg';
output_quality = 97;

%@@ Message string to encode into carrier image
msg = 'Test post; please ignore!/\/\/\/';
secret_msg_str = repmat(msg, 1, 128/length(msg));

%@@ Transform function
mode = 'db1';

%@@ Colour channel
channel = 2;

%@@ Coefficients
frequency_coefficients = [7 6; 5 2];

secret_msg_bin = str2bin(secret_msg_str);
im = double(imread(carrier_image_filename));
imc = im(:,:,channel);

[imc_stego, im_wavelet] = steg_wdct_encode(imc, secret_msg_bin, mode, frequency_coefficients);

im_stego = im;
im_stego(:,:,channel) = imc_stego;

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

% Write and read
imwrite(uint8(im_stego), output_image_filename, 'Quality', output_quality);
im_stego = double(imread(output_image_filename));
imc_stego = im_stego(:,:,channel);

% Extract message
[extracted_msg_bin] = steg_wdct_decode(imc_stego, mode, frequency_coefficients);
extracted_msg_str = bin2str(extracted_msg_bin);
fprintf('Extracted (%d bytes): %s\n', length(extracted_msg_str), extracted_msg_str);