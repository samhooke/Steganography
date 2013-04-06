% Here are some tests of the very basic spellchecker in python, executed
% from Matlab. Sentences are corrected on a word-by-word basis. The system
% slows down noticably at as few as 100 words. The whole process is slow
% and clunky.

%% Test of spelling.py
clc;

% Command is short so pass directly
sentence = 'I am noot vry goood at speeeling';

corrected = python('spelling.py', base64encode(sentence));

disp(sentence);
disp(corrected);

%% Test of spelling_long.py
clc;

% Command is too long, so pass through a temporary file
sentence = repmat('I am noot vry goood at speeeling ', 1, 10);

filename = 'output\spelling_temp.txt';
fid = fopen(filename, 'w');
fprintf(fid, '%s', base64encode(sentence));
fclose(fid);

corrected = python('spelling_long.py', filename);

disp(sentence);
disp(corrected);