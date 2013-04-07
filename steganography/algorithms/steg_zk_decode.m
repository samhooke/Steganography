function [secret, invalid_blocks, debug_invalid_decode] = steg_zk_decode(stego, frequency_coefficients, invalid_distance)
% steg_decode_dct Retrieves data encoded with steg_encode_dct
% INPUTS
%   stego  - Steganographic image to retrieve data from
% OUTPUTS
%   secret - Retrieved binary data

invalid_blocks = 0;

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
        c3 = block(s3x, s3y);
        
        %1: (c1 > c3 + d) and (c2 > c3 + d)
        %0: (c1 + d < c3) and (c2 + d < c3)
        
        debug_invalid_decode(gx,gy) = 0;
        
        csort = sort([c1 c2 c3]);
        cmin = csort(1);
        cmid = csort(2);
        cmax = csort(3);
        
        %{
        if (((c1 == cmin && c2 == cmid) || (c1 == cmid && c2 == cmin)) && (c3 == cmax))
            stego_bin(stego_bin_i) = 0;
            stego_bin_i = stego_bin_i + 1;
        elseif (((c1 == cmax && c2 == cmid) || (c1 == cmid && c2 == cmax)) && (c3 == cmin))
            stego_bin(stego_bin_i) = 1;
            stego_bin_i = stego_bin_i + 1;
        else
            invalid_blocks = invalid_blocks + 1;
            debug_invalid_decode(gx,gy) = 1;
        end
        %}
        
        %{
        if ((c3 >= c2) && (c2 >= c1)) || ((c3 >= c1) && (c1 >= c2))
            stego_bin(stego_bin_i) = 0;
            stego_bin_i = stego_bin_i + 1;
        elseif ((c2 >= c1) && (c1 >= c3)) || ((c1 >= c2) && (c2 >= c3))
            stego_bin(stego_bin_i) = 1;
            stego_bin_i = stego_bin_i + 1;
        else
            invalid_blocks = invalid_blocks + 1;
            debug_invalid_decode(gx,gy) = 1;
        end
        %}
        
        
        if ((c1 > c3 + invalid_distance) && (c2 > c3 + invalid_distance))
            stego_bin(stego_bin_i) = 1;
            stego_bin_i = stego_bin_i + 1;
        elseif ((c1 + invalid_distance < c3) && (c2 + invalid_distance < c3))
            stego_bin(stego_bin_i) = 0;
            stego_bin_i = stego_bin_i + 1;
        else
            invalid_blocks = invalid_blocks + 1;
            debug_invalid_decode(gx,gy) = 1;
        end
        
    end
end

secret = stego_bin;

end