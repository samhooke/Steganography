steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = 'input\lena.jpg';
output_image_filename = 'output\lena_haar.jpg';

%@@ Message string to encode into carrier image
secret_msg_str = 'Test post; please ignore!';

%@@ Alpha value for encoding
alpha = 0.05;

%@@ Wavelet transformation
mode = 'db1';

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

im = imread(carrier_image_filename);
imb = im(:,:,channel);

[imb_stego, im_wavelet_original, im_wavelet_stego] = steg_fusion_encode(imb, str2bin(secret_msg_str), alpha, mode);

im_stego = im;
im_stego(:,:,channel) = imb_stego;

% Output
subplot(2,2,1);
imshow(im, [0 255]);
title('Original image');
subplot(2,2,2);
imshow(im_wavelet_original);
title('Original wavelet transform');
subplot(2,2,3);
imshow(im_wavelet_stego);
title('Stego wavelet transform');
subplot(2,2,4);
imshow(im_stego);
title('Stego image');

imwrite(im_stego, output_image_filename, 'quality', 100);

% Decode
% ======

im_stego = imread(output_image_filename);
im_original = imread(carrier_image_filename);

imb_stego = im_stego(:,:,channel);
imb_original = im_original(:,:,channel);

[extracted_msg_bin] = steg_fusion_decode(imb_stego, imb_original, mode);

extracted_msg_str = bin2str(extracted_msg_bin);

fprintf('Extracted message: %s\n', extracted_msg_str);
