function corrected = py_spelling(sentence)
% py_spelling() Performs basic spelling correction on a sentence
%    NOTE: This calls the Python file 'correct.py'
% INPUTS
%    sentence - String of words separated by spaces
% OUTPUTS
%    corrected - A copy of `sentence` with spelling mistakes fixed

corrected = python('spelling.py', sentence);

end

