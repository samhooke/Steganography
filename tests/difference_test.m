clear all;
clc;

steganography_init();

a = '11111111111111111111111111111111';
b = '11000110100101110011001001101110';
s = [a, ' ', b];
r = python('difference.py', s);
disp(r);