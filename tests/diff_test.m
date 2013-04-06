clear all;
clc;

steganography_init();

a = '11111111';
b = '11101111';
s = [a, ' ', b];
r = python('diff.py', s);
disp(s);
disp(r);