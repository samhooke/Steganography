steganography_init();

%@@ Image used as carrier for encoding message
carrier_image_filename = 'input/lena.jpg';

%@@ Message string to encode into carrier image
secret_msg_str = 'Test post; please ignore!';

carrier_original = rgb2gray(imread(carrier_image_filename));
secret_msg = str2bin(secret_msg_str);

% Perform encoding
variance_threshold = 3; % Higher = more blocks used
minimum_distance_encode = 30; % Higher = more robust; more visible
minimum_distance_decode = 10;
frequency_coefficients = generate_allowed_coefficients();%;[4 6; 5 2; 6 5];%[4 3; 3 3; 3 4];
[carrier_stego bits_written bits_unused invalid_blocks_encode debug_invalid_encode] = steg_zk_encode(secret_msg, carrier_original, frequency_coefficients, variance_threshold, minimum_distance_encode);

% Write to file and read it again
imwrite(carrier_stego, 'stego.jpg', 'Quality', 90); % 'Mode', 'lossless'
carrier_stego = imread('stego.jpg');

% Perform decoding
[retrieved_msg invalid_blocks_decode debug_invalid_decode] = steg_zk_decode(carrier_stego, frequency_coefficients, minimum_distance_decode);
carrier_diff = (carrier_original - carrier_stego) .^ 2;

%imwrite(carrier_diff, 'diff.jpg');
limit = 100;
secret_msg_binstr = char(secret_msg(1:limit)+'0');
retrieved_msg_binstr = char(retrieved_msg(1:limit)+'0');
msg_match = isequal(secret_msg(1:200), retrieved_msg(1:200));

% Display images
subplot(2,3,1);
imshow(carrier_original);
title('Lena (carrier)');
subplot(2,3,2);
imshow(carrier_stego);
title('Lena (stego)');
subplot(2,3,3);
imshow(carrier_diff);
title('Lena (diff^2)');

subplot(2,3,4);
imshow(debug_invalid_encode);
title(sprintf('Invalid encode (%d)', invalid_blocks_encode));
subplot(2,3,5);
imshow(debug_invalid_decode);
title(sprintf('Invalid decode (%d)', invalid_blocks_decode));
subplot(2,3,6);
imshow(~(debug_invalid_encode - debug_invalid_decode));
title('Invalid diff');

% Print statistics
disp(['Encoded message (bin): ', secret_msg_binstr]);
disp(['Decoded message (bin): ', retrieved_msg_binstr]);
disp(['Encoded message (str): ', bin2str(secret_msg)]);
disp(['Decoded message (str): ', bin2str(retrieved_msg)]);
if (msg_match)
    disp('SUCCESS: Messages match!');
else
    disp('FAILURE: Messages do not match.');
end

%fprintf('Invalid blocks: (encode=%d) (decode=%d)', invalid_blocks_encode, invalid_blocks_decode);