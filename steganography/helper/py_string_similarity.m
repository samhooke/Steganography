function ratio = py_string_similarity(s1, s2)
% py_string_similarity() Returns similarity ratio between two strings
%    NOTE: This calls the Python file 'difference.py'
% INPUTS
%    s1 - First string to compare
%    s2 - Second string to compare
% OUTPUTS
%    ratio - Ratio between 0 and 1 indicating similarity.
%            1 = strings are identical
%            0 = strings are distinct

% DOS limits command line calls to 32768 bytes
limit = 3000;
if length(s1) > limit
    s1 = s1(1:limit);
end
if length(s2) > limit
    s2 = s2(1:limit);
end

s = [s1, ' ', s2];
ratio = str2double(python('difference.py', s)) / 100;

end

