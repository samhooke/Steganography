function [stego, bits_written, bits_unused] = steg_encode_dct(secret_bin, carrier, frequency_coefficients, persistence)
% steg_encode_dct Encodes binary data within the transform domain
% INPUTS
%   secret       - Stream of binary data to hide.
%   carrier      - Image within which to hide data.
%   persistence  - A higher value makes the hidden data more persistent
%                  i.e. Can survive more compression. 25 is recommended.
% OUTPUTS
%   stego        - Steganographically altered image.
%   bits_written - Number of written bits. If the same length as secret,
%                  then the process hid all data.
%   bits_unused  - Number of  of unused bits. If bigger than zero, then
%                  more data could have fit.

secret_bin_i = 1;
secret_length = numel(secret_bin);

% Tally the written and unused bits
bits_written = 0;
bits_unused = 0;

% If the data is not long enough, this bit is written instead
insufficient_bit = 0;

% Dimension of block that image will be split into
block_width = 8;
block_height = 8;

% Location of s1 and s2 within each block
% Comparing these values determines the binary value
s1x = frequency_coefficients(1,1);
s1y = frequency_coefficients(1,2);
s2x = frequency_coefficients(2,1);
s2y = frequency_coefficients(2,2);

[width height] = size(carrier);
stego = zeros(width, height);

grid_width = width / block_width;
grid_height = height / block_height;

for gx = 1:grid_width
    for gy = 1:grid_height
        cx = (gx-1) * block_width + 1;
        cy = (gy-1) * block_width + 1;
        
        posx = cx:cx+block_width-1;
        posy = cy:cy+block_height-1;
        
        % Take the block and perform DCT
        block = dct2(carrier(posx, posy));
        
        c1 = block(s1x, s1y);
        c2 = block(s2x, s2y);
        
        if (secret_bin_i <= secret_length)
            secret_bit = secret_bin(secret_bin_i);
            bits_written = bits_written + 1;
        else
            % secret was not long enough, so pad it with insufficient_bit
            secret_bit = insufficient_bit;
            bits_unused = bits_unused + 1;
        end
        secret_bin_i = secret_bin_i + 1;
        
        if (secret_bit == 0)
            if (c1 > c2)
                % swap
                t = c1;
                c1 = c2;
                c2 = t;
            end
        else
            if (c1 < c2)
                % swap
                t = c1;
                c1 = c2;
                c2 = t;
            end
        end
        
        % Ensure (Abs(c1-c2) > x)
        [c1 c2] = push_apart(c1, c2, persistence);
        
        block(s1x, s1y) = c1;
        block(s2x, s2y) = c2;
        
        % Inverse DCT and build up the stego-image
        stego(posx, posy) = idct2(block);
    end
end

stego = uint8(stego);

end

