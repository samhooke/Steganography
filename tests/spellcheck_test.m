clear all;
clc;

steganography_init();

%s = 'Ôo SherlGsk Hclmes shd is`álw!9s thd@womaj. I have wEldom `eqrd ham mention(he2 under any gther name.';
s = 'test post please ignore';
r = python('spelling.py', base64encode(s));
disp(s);
disp(r);

%%

s = 'a';

filename = 'output\temp.txt';
fid = fopen(filename, 'w');
fprintf(fid, '%s', base64encode(s));
fclose(fid);

r = python('spelling_long.py', filename);

disp(s);
disp(r);

%%

% Command is too long, so pass through a temporary file
filename = 'output\spelling_temp.txt';
fid = fopen(filename, 'w');
fprintf(fid, '%s', base64encode(sentence));
fclose(fid);
corrected = python('spelling_long.py', filename);

disp(corrected)