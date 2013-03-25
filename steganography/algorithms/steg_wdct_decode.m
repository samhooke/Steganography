function [extracted_msg_bin] = steg_wdct_decode(im, mode, frequency_coefficients)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

[~, ~, ~, hh] = dwt2(im, mode);
extracted_msg_bin = steg_dct_decode(hh, frequency_coefficients);

end