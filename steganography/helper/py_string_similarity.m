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

ratio = python('difference.py', [s1, ' ', s2]) / 100;

end

