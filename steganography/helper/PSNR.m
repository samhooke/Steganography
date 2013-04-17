function psnr = PSNR(a, b)
% PSNR() Peak Signal to Noise Ratio
% INPUTS
%    a - Image 1
%    b - Image 2 (same size as 1)
% OUTPUTS
%    psnr - Resulting PSNR between a and b

psnr = 20 * log10(255 / (sqrt(mean2((a - b).^2))));

end