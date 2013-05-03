function [bin_send] = hamming_encode_chunk(bin)
% hamming_encode_c2() Perform hamming encoding in chunks of 3

len = floor(length(bin)/3);
bin_send = zeros(6, len);
bin = bin(1:len*3);
bin = reshape(bin, 3, len);
for i = 1:len
    bin_send(:,i) = hamming_encode(bin(:,i)')';
end
bin_send = reshape(bin_send, 1, 6 * len);

end