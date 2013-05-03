function [nbp] = hamming_nbp(l, inc_parity)
% nbp() Calculates number of parity bits for given message length
% INPUTS
%   l          - Length of the message
%   inc_parity - Whether the message already contains the parity bits in
%                its length. This is most likely false for encoding, and
%                true for decoding.
% OUTPUTS
%   nbp - How many parity bits the message should/does contain

if inc_parity == true
    nbp = ceil(log2(l));
else
    nbp = floor(log2(l + ceil(log2(l)))) + 1;
end

end