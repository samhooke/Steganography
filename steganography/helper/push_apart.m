function [a, b] = push_apart(a, b, x)
% push_apart Ensures a gap of at least x between a and b
% INPUTS
%   a - First value
%   b - Second value
%   x - Distance to separate these values by
% OUTPUTS
%   a - First value, pushed
%   b - Second value, pushed

if (a > b)
    d = (x - (a - b)) / 2;
    a = a + d;
    b = b - d;
else
    d = (x - (b - a)) / 2;
    a = a - d;
    b = b + d;
end

end

