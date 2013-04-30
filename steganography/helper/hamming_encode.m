function [bin_send, nbp] = hamming_encode(bin)
% hamming_encode() Performs hamming coding on a given binary string
%   See also: hamming_decode()
% INPUTS
%   bin - Binary string, e.g. [1 0 0 1 0 1 1 0]
% OUTPUTS
%   bin_send - Hamming code to send

nbp = hamming_nbp(length(bin), false);
bin_send = insert_parity_bits(bin,nbp);

end