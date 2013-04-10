function r = rmse2_lazy(a, b)
% rmse2() Calculates the lazy root mean squared error for 2D data
%   It is lazy because the mean is not calculated, nor the square root
% INPUTS
%   a - First set of values
%   b - Second set of values
%       a and b must be of the same size
% OUTPUTS
%   r - Lazy root mean squared error

r = sum(sum((a - b).^2));

end