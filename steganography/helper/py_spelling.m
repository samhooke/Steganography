function corrected = py_spelling(sentence)
% py_spelling() Performs basic spelling correction on a sentence
%    NOTE: This calls the Python file 'correct.py'
% INPUTS
%    sentence - String of words separated by spaces
% OUTPUTS
%    corrected - A copy of `sentence` with spelling mistakes fixed

% DOS limits command line call length. Ensure that this is not passed.
if length(sentence) < 0
    % Command is short enough, so pass through command line
    corrected = python('spelling.py', base64encode(sentence));
else
    % Command is too long, so pass through a temporary file
    filename = 'output\spelling_temp.txt';
    fid = fopen(filename, 'w');
    fprintf(fid, '%s', base64encode(sentence));
    fclose(fid);
    corrected = base64decode(python('spelling_long.py', filename));
end

end

