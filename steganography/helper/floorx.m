function [y] = floorx(y, x)
% floorx() Rounds y down to the nearest x
%   e.g. floorx(360, 16) = 352
% INPUTS
%    y - Number to round
%    x - What to round y near to
% OUTPUTS
%    y - Rounded down y

y = floor(y / x) * x;

end

