function im = idwt2_pascal(ll, lh, hl, hh, mode)
% idwt2_pascal() Performs 2D-IDWT using wavelet() by Pascal Getreuer
%   Should act the same as Matlab's idwt2() but with more modes

ext = 'asym';

im = [ll, lh; hl, hh];

im = wavelet(mode, -1, im, ext, 2);
im = wavelet(mode, -1, im, ext, 1);

end