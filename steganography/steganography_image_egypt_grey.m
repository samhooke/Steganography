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

%}

% Decode
% ======

%{

%}