function [stego, bits_written, bits_unused, invalid_blocks, debug_invalid_encode] = steg_zk_encode(secret_bin, carrier, frequency_coefficients, variance_threshold, minimum_distance)
% steg_encode_dct Encodes binary data within the transform domain
% INPUTS
%   secret       - Stream of binary data to hide.
%   carrier      - Image within which to hide data.
% OUTPUTS
%   stego        - Steganographically altered image.
%   bits_written - Number of written bits. If the same length as secret,
%                  then the process hid all data.
%   bits_unused  - Number of  of unused bits. If bigger than zero, then
%                  more data could have fit.

secret_pos = 1;
secret_length = numel(secret_bin);

% Tally the written and unused bits
bits_written = 0;
bits_unused = 0;
invalid_blocks = 0;

% If the data is not long enough, this bit is written instead
insufficient = false;

% Dimension of block that image will be split into
block_width = 8;
block_height = 8;



% Location of s1 and s2 within each block
% Comparing these values determines the binary value
s1x = frequency_coefficients(1,1);
s1y = frequency_coefficients(1,2);
s2x = frequency_coefficients(2,1);
s2y = frequency_coefficients(2,2);
s3x = frequency_coefficients(3,1);
s3y = frequency_coefficients(3,2);

[width height] = size(carrier);
stego = zeros(width, height);

grid_width = width / block_width;
grid_height = height / block_height;

debug_invalid_encode = zeros(grid_width, grid_height);



Modify_X = 0;
Modify_L = 1;
Modify_M = 2;
Modify_H = 3;

for gx = 1:grid_width
    for gy = 1:grid_height
        cx = (gx-1) * block_width + 1;
        cy = (gy-1) * block_width + 1;
        
        posx = cx:cx+block_width-1;
        posy = cy:cy+block_height-1;
        
        % Take the block and perform DCT
        block = dct2(carrier(posx, posy));
        c = [block(s1x, s1y) block(s2x, s2y) block(s3x, s3y)];
        
        % ~ ~ ~ ~ Begin ZK ~ ~ ~ ~ %
        
        block_was_invalid = false;
        bit_was_written = false;
        md = variance_threshold;
        d = minimum_distance;
        
        % Check if there are still bits to write
        if (secret_pos <= secret_length)
            % There are bits to write
            % Chose which bit to write
            secret_bit = secret_bin(secret_pos);
            
            % Work out how the coefficients need to be altered
            c3_target = Modify_X;

            if (secret_bit == 1)
                if (min(abs(c(1)), abs(c(2)) + md < abs(c(3))))
                    % Invalid
                    block_was_invalid = true;
                    c3_target = Modify_M;
                end
            else
                if (max(abs(c(1)), abs(c(2))) > abs(c(3)) + md)
                    % Invalid
                    block_was_invalid = true;
                    c3_target = Modify_M;
                end
            end

            if (~block_was_invalid)
                % Valid
                bit_was_written = true;

                if (secret_bit == 1)
                    c3_target = Modify_L;
                else
                    c3_target = Modify_H;
                end
            end
        else
            % There are no more bits to write
            insufficient = true;
            
            % Because the end of the message has been reached, write
            % invalid blocks rather than 1 or 0
            c3_target = Modify_M;
            block_was_invalid = true;
        end
        
        % Actually modify the coefficients
        switch (c3_target)
            case Modify_L
                % c(3) needs to be lower than the other values
                c(3) = min(c(3), min(c(1), c(2)) - d);
            case Modify_H
                % c(3) needs to be higher than the other values
                c(3) = max(c(3), max(c(1), c(2)) + d);
            case Modify_M
                %{
                % c(3) needs to be inbetween the other values
                if (c(1) < c(2))
                    c(1) = min(c(1), c(3) - d);
                    c(2) = max(c(2), c(3) + d);
                else
                    c(2) = min(c(2), c(3) - d);
                    c(1) = max(c(1), c(3) + d);
                end
                %}
            case Modify_X
                disp('No change required');
        end

        % Bit was written
        if (bit_was_written)
            secret_pos = secret_pos + 1;
            if (~insufficient)
                bits_written = bits_written + 1;
            else
                bits_unused = bits_unused + 1;
            end
        end
        
        % Block was invalid
        if (block_was_invalid)
            invalid_blocks = invalid_blocks + 1;
            bits_unused = bits_unused + 1;
            debug_invalid_encode(gx, gy) = 1;
        else
            debug_invalid_encode(gx, gy) = 0;
        end
        
        % ~ ~ ~ ~ End ZK ~ ~ ~ ~ %
        
        block(s1x, s1y) = c(1);
        block(s2x, s2y) = c(2);
        block(s3x, s3y) = c(3);
        
        % Inverse DCT and build up the stego-image
        stego(posx, posy) = idct2(block);
    end
end

stego = uint8(stego);

end

