function [bin_send] = hamming_encode_c2(bin)
% hamming_encode_c2() Perform hamming encoding in chunks of 2

bin_send = zeros(1, length(bin) * 2);

for i = 1:2:length(bin)
    bin_send((i-1)*2+1:(i-1)*2+1+3) = hamming_encode(bin(i:i+1));
end

end

