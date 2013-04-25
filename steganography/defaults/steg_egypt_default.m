function [secret_msg_bin, secret_msg_binimg, secret_msg_w, secret_msg_h, mode, block_size, pixel_size, is_binary] = steg_egypt_default(w, h, use_greyscale, msg_desired)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Set defaults
block_size = 4;
pixel_size = 3;
is_binary = true;

if use_greyscale
    %mode = 'haar';
    mode = 'idk';
else
    mode = 'idk';
end

% Generate secret
secret_msg_w = 36;
secret_msg_h = 36;
secret_msg_str = generate_test_message(((secret_msg_w / pixel_size) * (secret_msg_h / pixel_size)) / 8);

if ~strcmp(msg_desired, '')
    [secret_msg_str] = replace_with_custom_message(secret_msg_str, msg_desired);
end

secret_msg_bin = str2bin(secret_msg_str);
secret_msg_binimg = bin2binimg(secret_msg_bin, secret_msg_w / pixel_size, secret_msg_h / pixel_size, pixel_size, 255);

end