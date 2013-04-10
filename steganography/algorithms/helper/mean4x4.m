function r = mean4x4(a)
% mean4x4() Works out the mean of a 4x4 matrix
%   It is faster than mean2()
% INPUTS
%   a - 4x4 matrix
% OUTPUTS
%   r - Mean of 4x4 matrix

r = a(1,1) + a(1,2) + a(1,3) + a(1,4) + a(2,1) + a(2,2) + a(2,3) + a(2,4) + a(3,1) + a(3,2) + a(3,3) + a(3,4) + a(4,1) + a(4,2) + a(4,3) + a(4,4);
r = r / 16;

end

