function message_bin = steg_decode_lsb(steg)
% steg_decode_lsb Extracts binary data from least significant bits
% INPUTS
%   steg        - Image to extract message from.
% OUTPUTS
%   message_bin - Extracted message.

message_bin = mod(steg,2);

end

