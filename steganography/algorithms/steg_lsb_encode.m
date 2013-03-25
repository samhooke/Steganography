function steg = steg_lsb_encode(carrier, message_bin)
% steg_lsb_encode Encodes a message in the least significant bits of a
% carrier image
% INPUTS
%   carrier      - Image to hide message in. Should only have one colour
%                  channel.
%   message_bin  - The message, in the form of binary data.
% OUTPUTS
%   steg         - Image with encoded message.

if (length(message_bin(:)) > length(carrier(:)))
    error('secret is too large to fit within carrier');
else
    message_padded = zeros(length(carrier(:)), 1);
    message_padded(1:length(message_bin)) = message_bin;
    d = size(carrier);
    message_padded = logical(reshape(message_padded, d));

    steg = mod(message_padded, 2) + double(bitshift(carrier, -1) * 2);
end

end

