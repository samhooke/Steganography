function message_bin = steg_lsb_decode(steg)
% steg_lsb_decode Extracts binary data from least significant bits
% INPUTS
%   steg        - Image to extract message from.
% OUTPUTS
%   message_bin - Extracted message.

message_bin = mod(steg,2);
message_bin = reshape(message_bin, [], length(length(message_bin)))';

end

