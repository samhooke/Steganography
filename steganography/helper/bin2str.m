function s = bin2str(a)
% bin2str() Converts binary into a string
% INPUTS
%    a - Input binary. Length must be multiple of 8
% OUTPUTS
%    s - Output string

b = char(a(:)'+'0')';
b = reshape(b, 8, length(a(:))/8)';
s = char(bin2dec(b))';

end

