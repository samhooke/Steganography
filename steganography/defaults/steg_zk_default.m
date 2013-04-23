function [secret_msg_bin, frequency_coefficients, variance_threshold, minimum_distance_encode, minimum_distance_decode] = steg_zk_default(w, h, use_greyscale)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

frequency_coefficients = [4 6; 5 2; 6 5];
variance_threshold = 1; % Higher = more blocks used
minimum_distance_encode = 200; % Higher = more robust; more visible
minimum_distance_decode = 10;

msg_length_max = w / 8 * h / 8; % One bit per 8x8
msg_length_max = msg_length_max / 8; % Convert to bytes
secret_msg_str = generate_test_message(msg_length_max);
secret_msg_bin = str2bin(secret_msg_str);

end