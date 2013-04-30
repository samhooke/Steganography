function [bin_final] = hamming_decode_c2(bin)
% hamming_decode_c2() Perform hamming decoding in chunks of 2

bin_final = zeros(1, length(bin) / 2);

for i = 1:4:length(bin)
    bin_final((i-1)/2+1:(i-1)/2+1+1) = hamming_decode(bin(i:i+3));
end

end

