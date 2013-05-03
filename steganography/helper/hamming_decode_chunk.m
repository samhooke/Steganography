function [bin_final] = hamming_decode_chunk(bin)
% hamming_decode_c2() Perform hamming decoding in chunks of 3

len = floor(length(bin)/6);
bin = bin(1:len*6);
bin = reshape(bin, 6, len);
bin_final = zeros(3, len);
for i = 1:len
    bin_final(:,i) = hamming_decode(bin(:,i)')';
end
bin_final = reshape(bin_final, 1, 3 * len);

end