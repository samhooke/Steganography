% When carrying out steganography in the transform domain, it is very
% useful to know which frequency coefficients are the best to encode your
% secret message into. This code performs a brute force test, checking
% every single combination of frequency coefficients (up to a set limit),
% then reports back which are the most favourable.

% Get rid of junk
clear all;
close all;
clc;

%@@ Image used as carrier for encoding message
carrier_image_filename = 'input/lena.jpg';

%@@ Message string to encode into carrier image
secret_msg_str = 'Test post; please ignore!';

%@@ Width and height to search within the 8*8 matrix (1 <= x <= 8)
w_min = 1;
w_max = 2;
h_min = 1;
h_max = 2;

carrier_original = rgb2gray(imread(carrier_image_filename));
secret_msg_bin = str2bin(secret_msg_str);
counter = 1;
best_difference = Inf;
best_coefficients = [1 1; 1 1];

fprintf('---=== Test start ===---\n');
tic;
for coeff1x = 1:w_max
    for coeff1y = 1:h_max
        for coeff2x = 1:w_max
            for coeff2y = 1:h_max
                if ~(coeff1x == coeff2x && coeff1y == coeff2y) && (coeff1x >= w_min || coeff1y >= h_min || coeff2x >= w_min || coeff2y >= h_min)
                    % Choose coefficients
                    frequency_coefficients = [coeff1x coeff1y; coeff2x coeff2y];
                    fprintf('[%3d] Coeff: (%d,%d)(%d,%d)', counter, coeff1x, coeff1y, coeff2x, coeff2y);
                    counter = counter + 1;
                    
                    % Encode and decode
                    [carrier_stego bits_written bits_unused] = steg_dct_encode(secret_msg_bin, carrier_original, frequency_coefficients, 25);
                    imwrite(carrier_stego, 'stego_temp.jpg');
                    carrier_stego = imread('stego_temp.jpg');
                    [retrieved_msg] = steg_dct_decode(carrier_stego, frequency_coefficients);
                    
                    % Verify and compare difference
                    msg_match = isequal(secret_msg_bin(1:200), retrieved_msg(1:200));
                    difference = sum(sum((carrier_original - carrier_stego) .^ 2));
                    fprintf(' Match: %d Diff: %d\n', msg_match, difference);
                    
                    % Record best coefficients
                    if ((msg_match) && (difference < best_difference))
                        best_difference = difference;
                        best_coefficients = frequency_coefficients;
                    end
                end
            end
        end
    end
end

% Show statistics
duration = toc;
fprintf('---=== Test complete ===---\n');
fprintf('Completed in %f seconds\n', duration);
fprintf('Best coefficients are: (%d,%d)(%d,%d)\n', best_coefficients(1,1), best_coefficients(1,2), best_coefficients(2,1), best_coefficients(2,2));