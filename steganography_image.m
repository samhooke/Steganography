%%
quality = 25;
imwrite(imread('stego.jpg'), 'stego_e1.jpg', 'Quality', quality); % 'Mode', 'lossless'
for loop = 1:10
    asdf = imread(sprintf('stego_e%d.jpg', loop));
    asdf(loop * 8,1) = 0;
    imwrite(asdf, sprintf('stego_e%d.jpg', loop + 1), 'Quality', quality); % 'Mode', 'lossless'
end

%% Wavelet
% dwt / idwt
clear;
clc;
clf;

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