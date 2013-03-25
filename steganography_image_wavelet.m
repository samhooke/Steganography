%{
% From: http://ijcsmc.com/docs/papers/February2013/V2I2201316.pdf
% "A COMPARATIVE STUDY OF IMAGE STEGANOGRAPHY IN WAVELET DOMAIN", 2013

% Fusion embedding
1) Normalise image between 0 and 1
2) Choose value for alpha (between 0 and 0.1)
3) Reconstruct pixels to lie within (alpha, 1 - alpha)
4) Apply 2D Haar transform (or CDF97)
5) Looping through the frequency coefficients
    5.1) Select bit from secret message
    5.2) Embed by adding alpha if 1, or subtracting alpha if 0
6) Perform inverse transform to reform image
%}

%{
% Fusion extraction
1) Apply 2D Haar transform (or CDF97)
2) Looping through the frequency coefficients
    2.1) 
%}

%
clear all;
close all;
clc;
clf;

cd('C:\Users\Muffin\Documents\GitHub\Steganography');

%@@ Image used as carrier for encoding message
carrier_image_filename = 'input\lena.jpg';
output_image_filename = 'output\lena_haar.jpg';

%@@ Message string to encode into carrier image
secret_msg_str = 'Test post; please ignore!';

%@@ Alpha value for encoding
alpha = 0.05;

%@@ Wavelet transformation
mode = 'db1'; % 'haar'

%@@ Which channel to use (1=r, 2=g, 3=b)
channel = 3;

im_max = 255;
secret_msg_bin = str2bin(secret_msg_str);
secret_msg_bin_len = length(secret_msg_bin);

% Load carrier
im = imread(carrier_image_filename);

% Take just one channel
imb = im(:,:,channel);

% Normalise
imb = double(imb) / im_max;

 % Preprocess
imb(imb < alpha) = alpha;
imb(imb > 1 - alpha) = 1 - alpha;

% Perform wavelet transform
[ll lh hl hh] = dwt2(imb, mode);

[w h] = size(hh);


% For debugging, take a copy of the transform before stego
imb_wavelet_original = [ll, lh; hl, hh];

secret_msg_pos = 1;
for x = 1:w
    for y = 1:h
        % Choose bit to encode
        if secret_msg_pos <= secret_msg_bin_len
            bit = secret_msg_bin(secret_msg_pos);
            secret_msg_pos = secret_msg_pos + 1;
        else
            bit = 0;
        end;
        
        % Encode the bit
        if bit == 1
            hh(x,y) = hh(x,y) + alpha;
        else
            hh(x,y) = hh(x,y) - alpha;
        end;
    end;
end;

% For debug, take a copy of the transform after stego
imb_wavelet_stego = [ll, lh; hl, hh];

% Inverse wavelet transform
imb_stego = idwt2(ll, lh, hl, hh, mode);

% Denormalise
imb_stego = uint8(imb_stego * im_max);

% Construct the output stego image by copying the original image
% and replacing the selected channel
im_stego = im;
im_stego(:,:,channel) = imb_stego;

subplot(2,2,1);
imshow(im, [0 255]);
title('Original image');
subplot(2,2,2);
imshow(imb_wavelet_original);
title('Original wavelet transform');
subplot(2,2,3);
imshow(imb_wavelet_stego);
title('Stego wavelet transform');
subplot(2,2,4);
imshow(im_stego);
title('Stego image');

imwrite(im_stego, output_image_filename, 'quality', 100);

% ---=== Time to extract! ===---

im_original = imread(carrier_image_filename);
im_stego = imread(output_image_filename);


imb_original = im_original(:,:,channel);
imb_stego = im_stego(:,:,channel);

[llo lho hlo hho] = dwt2(imb_original, mode);
[lls lhs hls hhs] = dwt2(imb_stego, mode);

hh = hhs - hho;
[w h] = size(hh);

extracted_msg_pos = 1;
for x = 1:w
    for y = 1:h
        if hh(x,y) > 0
            extracted_msg_bin(extracted_msg_pos) = 1;
        else
            extracted_msg_bin(extracted_msg_pos) = 0;
        end;
        extracted_msg_pos = extracted_msg_pos + 1;
    end;
end;

extracted_msg_str = bin2str(extracted_msg_bin);
fprintf('Extracted message: %s\n', extracted_msg_str);


%%


%%

% Get rid of junk
clear all;
close all;
clc;

im = double(rgb2gray(imread('lena512.jpg')));

mode = 'db1';

[ll lh hl hh] = dwt2(im, mode);%dwt2(im, 'db1');

%{
hhmax = max(max(hh));
hhmin = min(min(hh));
hhavg = hhmax--1;%(hhmax+hhmin);
hh(hh < hhavg) = 0;
%}

frequency_coefficients = [7 6; 5 2];
persistence = 50;

%msg = str2bin('Test post; please ignore!');
msg = str2bin(repmat('ASDF', 1, 128/4));
hh = steg_encode_dct(msg, hh, frequency_coefficients, persistence);
%hl = steg_encode_dct(1-msg, hl, frequency_coefficients, persistence);
%hh = steg_encode_dct(msg, hh, frequency_coefficients, persistence);


abcd = [ll, lh; hl, hh];
im2 = idwt2(ll, lh, hl, hh, mode);

fun_min = 0;
fun_max = 255;%fun_min+10;

subplot(2,2,1);
imshow(super_contrast_fun(im, fun_min, 255-fun_max), [0 255]);
title('original');
subplot(2,2,2);
imshow(abcd, [0 255]);
title('haar transform');

subplot(2,2,3);
imshow(super_contrast_fun(im2, fun_min, 255-fun_max), [0 255]);


%imshow(im2, [0 255]);
%{
a = 0.5;
im2min = double(min(im2(:)))+100;
im2max = double(max(im2(:)))-100;
c = 1;
im2c = (im2-im2min)/(im2max-im2min) * c;
%imshow(im2.^a, [0 255^a]);
imshow(im2c, [0 c]);
%}

title('reconstructed');
subplot(2,2,4);
imshow((im-im2).^2, [0 255]);
title('difference');

q = 94;
imwrite(uint8(im), 'haar_original.jpg', 'Quality', q);
imwrite(uint8(abcd), 'harr_deconstructed.jpg', 'Quality', 75);
imwrite(uint8(im2), 'haar_reconstructed.jpg', 'Quality', q);

im2 = imread('haar_reconstructed.jpg');

[ll2 lh2 hl2 hh2] = dwt2(im2, mode);
message_extracted = bin2str(steg_decode_dct(hh2, frequency_coefficients));
fprintf('Extracted (%d bytes): %s\n', length(message_extracted), message_extracted);

%%
clc;
clear;

fun_min = 0;
fun_max = fun_min+10;

im = double((imread('haar_original.jpg')));
im2 = double((imread('haar_reconstructed.jpg')));

for thing = 1:2:20
    variable_name = 10;
    thingy = thing * variable_name;
    subplot(2,10,thing + 0);
    imshow(super_contrast_fun(im, thingy, 255 - (thingy + variable_name)), [0 255]);
    title('thing + 0');
    subplot(2,10,thing + 1);
    imshow(super_contrast_fun(im2, thingy, 255 - (thingy + variable_name)), [0 255]);
    title('thing + 1');
end