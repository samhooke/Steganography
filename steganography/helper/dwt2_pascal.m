function [ll, lh, hl, hh] = dwt2_pascal(im, mode)
% dwt2_pascal() Performs 2D-DWT using wavelet() by Pascal Getreuer
%   Should act the same as Matlab's dwt2() but with more modes

ext = 'asym';

im = wavelet(mode, 1, im, ext, 2);
im = wavelet(mode, 1, im, ext, 1);
[w, h] = size(im);
w2 = w/2;
h2 = h/2;
ll = im(1:w2, 1:h2);
lh = im(1:w2, h2+1:h);
hl = im(w2+1:w, 1:h2);
hh = im(w2+1:w, h2+1:h);

end