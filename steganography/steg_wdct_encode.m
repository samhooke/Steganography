function [im, im_wavelet] = steg_wdct_encode(im, secret_msg_bin, mode, frequency_coefficients)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

persistence = 50;
[ll lh hl hh] = dwt2(im, mode);
hh = steg_dct_encode(secret_msg_bin, hh, frequency_coefficients, persistence);
im_wavelet = [ll, lh; hl, hh];
im = idwt2(ll, lh, hl, hh, mode);

end

