steganography_init();

%@@ Image used as carrier for encoding message
carrier_image_filename = 'input\lena.jpg';
output_image_filename = 'output\lena_dct.jpg';

%@@ Message string to encode into carrier image
%@@ Leave blank to automatically generate a message
secret_msg_str = '';

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Output image quality
output_quality = 75;

% Load image, generate message if necessary
im = imread(carrier_image_filename);
[w h] = size(im);
msg_length_max = w / (8 * 8) * h / (8 * 8);
if secret_msg_str == ''
    secret_msg_str = generate_test_message(msg_length_max);
end;
secret_msg_bin = str2bin(secret_msg_str);

% Take chosen channel from the image
imc = im(:,:,channel);

% Encode on the one channel
frequency_coefficients = [3 6; 5 2];
[imc_stego bits_written bits_unused] = steg_dct_encode(secret_msg, imc, frequency_coefficients, 25);

% Put the channels back together
im_stego = im;
im_stego(:,:,channel) = imc;

% Write and read
imwrite(im_stego, output_image_filename, 'Quality', output_quality);
im_stego = imread(output_image_filename);

% Take chosen channel from the image
imc = im(:,:,channel);

% Decode
[retrieved_msg] = steg_dct_decode(imc_stego, frequency_coefficients);

% Verify and compare difference
msg_match = isequal(secret_msg(1:200), retrieved_msg(1:200));
difference = (imc - imc_stego) .^ 2;
difference_sum = sum(difference);

% Display images
subplot(1,3,1);
imshow(im);
title('Carrier');
subplot(1,3,2);
imshow(im_stego);
title('Stego image');
subplot(1,3,3);
imshow(difference);
title('Difference');

% Print statistics
fprintf('Difference: %d\n', sum(difference_sum));
disp(['Encoded message: ', bin2str(secret_msg)]);
disp(['Decoded message: ', bin2str(retrieved_msg)]);