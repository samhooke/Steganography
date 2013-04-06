function ratio = py_string_similarity(s1, s2)
% py_string_similarity() Returns similarity ratio between two strings
%    NOTE: This calls a Python file
% INPUTS
%    s1 - First string to compare
%    s2 - Second string to compare
% OUTPUTS
%    ratio - Ratio between 0 and 1 indicating similarity.
%            1 = strings are identical
%            0 = strings are distinct

s = [s1, ' ', s2];

% DOS limits command line call length. Ensure that this is not passed.
if length(s1) + length(s2) < 6000
    % Command is short enough, so pass through command line
    ratio = str2double(python('difference.py', s)) / 100;
else
    % Command is too long, so pass through a temporary file
    filename = 'output\difference_temp.txt';
    fid = fopen(filename, 'w');
    fprintf(fid, '%s', s);
    fclose(fid);
    ratio = str2double(python('difference_long.py', filename)) / 100;
end

end

