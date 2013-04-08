clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
secret_image_filename = [dir_input, 'peppers.jpg'];
output_image_filename = [dir_output, 'lena_egypt.jpg'];

%@@ Output image quality
output_quality = 100;

%@@ Wavelet transformation
mode = 'db1';

%{
C = im_carrier
S = im_secret
G = im_stego
(1) Perform 2D-DWT on C and S to obtain 4 subimages for each:
    (CLL1, CLH1, CHL1, CHH1) and (SLL1, SLH1, SHL1, SHH1)

(2) Take SLL1, CLL1 and SHL1. Part them into blocks of 4x4 pixels such that:
        SLL1 = {BSi ; 1 <= i  < ns}
        CLL1 = {BCk1; 1 <= k1 < nc}
        CHL1 = {BHk2; 1 <= k2 < nc}
    BSi is ith block in SLL1
    BCk1 is k1th block in CLL1
    BHk2 is k2th block in CHL1
    ns is number of 4x4 blocks in SLL1
    nc is number of 4x4 blocks in CLL1 or CHL1 (they are the same size)

(3) For each block BSi in SLL1, find the best matched block BCk1 of minimum
    error in CLL1. Search using root mean squared error (RMSE).
    Key K1 consists of addresses k1 of the best matched blocks in CLL1.

(4)  Calculate the error block, EBi, between BCk1 and BSi as follows:
        EBi = BCk1 - BSi

(5) For each error block EBi, find the best matched block BHk2 of minimum
    error in CHL1. Search using root mean squared error (RMSE).
    Key K2 consists of addresses k2 of the best matched blocks in CHL1.

(6) Repeat (3) to (5) until all error blocks are embedded in CHL1.

(7) Apply 2D-IDWT to (CLL1, CLH1, CHH1, CHL1) to obtain G.
%}

% Load images as greyscale, for simplicity in this first implementation
im_carrier = rgb2grayscale(imread(carrier_image_filename));
im_secret = rgb2grayscale(imread(secret_image_filename));

% Calculate the 4 subimages for C and S
[cll1 clh1 chl1 chh1] = dwt2(im_carrier, mode);
[sll1 slh1 shl1 shh1] = dwt2(im_secret, mode);


chh1 = steg_dct_encode(secret_msg_bin, chh1, frequency_coefficients, persistence);
im_wavelet = [cll1, clh1; chl1, chh1];
im = idwt2(cll1, clh1, chl1, chh1, mode);

% Decode
% ======

%{

%}