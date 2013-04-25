function [secret_msg_bin, frequency_coefficients, persistence, mode] = steg_wdct_default(w, h, use_greyscale, msg_desired)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

mode = 'db1';
frequency_coefficients = [7 6; 5 2];

if use_greyscale
    persistence = 25;
else
    persistence = 100;
end

msg_length_max = floorx(w, 16) / 16 * floorx(h, 16) / 16; % One bit per 8x8, in one quarter
msg_length_max = msg_length_max / 8; % Convert to bytes
secret_msg_str = generate_test_message(msg_length_max);

if ~strcmp(msg_desired, '')
    [secret_msg_str] = replace_with_custom_message(secret_msg_str, msg_desired);
end

secret_msg_bin = str2bin(secret_msg_str);

end