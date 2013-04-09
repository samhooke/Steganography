function r = rmse(a, b)
% rmse() Calculates root mean squared error
% INPUTS
%   a - First set of values
%   b - Second set of values
%       a and b must be of the same length
% OUTPUTS
%   r - Root mean squared error

r = sqrt(mean((a - b).^2));

end