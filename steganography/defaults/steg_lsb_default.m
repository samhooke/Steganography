function [secret_msg_bin] = steg_lsb_default(w, h, use_greyscale)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

msg_length_max = w * h; % One bit per pixel
msg_length_max = msg_length_max / 8; % Convert to bytes
secret_msg_str = generate_test_message(msg_length_max);
secret_msg_bin = str2bin(secret_msg_str);

end