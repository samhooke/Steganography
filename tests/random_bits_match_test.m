clear;
clc;

% How many random bits per string to generate
num_bits = 1000000;

% Generate two random strings of bits, a and b
a = zeros(1, num_bits);
b = zeros(1, num_bits);
for i = 1:num_bits
    a(i) = round(rand);
    b(i) = round(rand);
end

x = xor(a, b);

bits_total = length(x);

% Bits that differ are 1s in the xor. Add them up to count how many
% Bits that match are = (total bits - bits that differ)
bits_diff = sum(x);
bits_match = bits_total - bits_diff;

% Rearranged the following: 1 - ((1 - bits_match / bits_total) * 2)
match = 2 * bits_match / bits_total - 1;

fprintf('Random string match: %.2f%%\n', match * 100);