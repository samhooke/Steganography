function [secret_msg_str] = replace_with_custom_message(secret_msg_str, msg_desired)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

len_max = length(secret_msg_str);
msg_temp = repmat('_', 1, len_max);
len_desired = min(len_max, length(msg_desired));
msg_temp(1:len_desired) = msg_desired(1:len_desired);
secret_msg_str = msg_temp;

end

