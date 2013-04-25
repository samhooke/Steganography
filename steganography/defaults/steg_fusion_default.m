function [secret_msg_bin, alpha, mode] = steg_fusion_default(w, h, use_greyscale, msg_desired)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

alpha = 0.05;
mode = 'db1';

msg_length_max = w / 2 * h / 2; % One bit per pixel, in one quarter
msg_length_max = msg_length_max / 8; % Convert to bytes
secret_msg_str = generate_test_message(msg_length_max);

if ~strcmp(msg_desired, '')
    [secret_msg_str] = replace_with_custom_message(secret_msg_str, msg_desired);
end

secret_msg_bin = str2bin(secret_msg_str);

end