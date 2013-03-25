function [secret] = steg_decode_dct(stego, frequency_coefficients)
% steg_decode_dct Retrieves data encoded with steg_encode_dct
% INPUTS
%   stego  - Steganographic image to retrieve data from
% OUTPUTS
%   secret - Retrieved binary data

% Dimension of block that image will be split into
block_width = 8;
block_height = 8;

% Location of s1 and s2 within each block
% Comparing these values determines the binary value
s1x = frequency_coefficients(1,1);
s1y = frequency_coefficients(1,2);
s2x = frequency_coefficients(2,1);
s2y = frequency_coefficients(2,2);

[width height rgb] = size(stego);

grid_width = width / block_width;
grid_height = height / block_height;

stego_bin = zeros(1, grid_width * grid_height);
stego_bin_i = 1;

for gx = 1:grid_width
    for gy = 1:grid_height
        
        cx = (gx-1) * block_width + 1;
        cy = (gy-1) * block_width + 1;
        
        posx = cx:cx+block_width-1;
        posy = cy:cy+block_height-1;
        
        % Take the block and perform DCT
        block = dct2(stego(posx, posy));
        
        c1 = block(s1x, s1y);
        c2 = block(s2x, s2y);
        
        if (c1 > c2)
            stego_bin(stego_bin_i) = 1;
        else
            stego_bin(stego_bin_i) = 0;
        end
        
        stego_bin_i = stego_bin_i + 1;
    end
end

secret = stego_bin;

end