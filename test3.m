%{
1) Split image into 8x8 blocks, perform DCT
2) Loop through all the blocks
2a) Within each block, have two pre-selected cells, C1 and C2
2b-i)  If the value you want to hide is 0, if C1 > C2, swap them
2b-ii) If the value you want to hide is 1, if C1 < C2, swap them
3) Ensure Abs(C1-C2) > x, where x is some value > 0. Higher x = more
robust, but worse image quality
4) perform reverse DCT
%}
clear;
clc;

%secret = repmat('Mary had a little lamb, its fleece was white as snow...', 1, 100);
secret = 'Mary had a little lamb its fleece was white as snow; And everywhere that Mary went, the lamb was sure to go. It followed her to school one day, which was against the rule; It made the children laugh and play, to see a lamb at school. And so the teacher turned it out, but still it lingered near, And waited patiently about till Mary did appear. "Why does the lamb love Mary so?" the eager children cry; "Why, Mary loves the lamb, you know" the teacher did reply.';
carrier = rgb2gray(imread('carrier.jpg'));

secret_bin = str2bin(secret);
secret_bin_i = 1;

% Dimension of block that image will be split into
block_width = 8;
block_height = 8;

% Location of s1 and s2 within each block
% Comparing these values determines the binary value
s1x = 4;
s1y = 1;
s2x = 3;
s2y = 2;

[width height] = size(carrier);
stego = zeros(width, height);

grid_width = width / block_width;
grid_height = height / block_height;

for gx = 1:grid_height
    for gy = 1:grid_width
        cx = (gx-1) * block_width + 1;
        cy = (gy-1) * block_width + 1;
        
        posx = cx:cx+block_width-1;
        posy = cy:cy+block_height-1;
        
        % Take the block and perform DCT
        block = dct2(carrier(posx, posy));
        
        c1 = block(s1x, s1y);
        c2 = block(s2x, s2y);
        
        secret_bit = secret_bin(secret_bin_i);
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
        x = 25; %25 seems to work well
        if (c1 > c2)
            diff = c1 - c2;
            diff = (x - diff)/2;
            c1 = c1 + diff;
            c2 = c2 - diff;
        else
            diff = c2 - c1;
            diff = (x - diff)/2;
            c1 = c1 - diff;
            c2 = c2 + diff;
        end
        
        block(s1x, s1y) = c1;
        block(s2x, s2y) = c2;
        
        % Inverse DCT and build up the stego-image
        stego(posx, posy) = idct2(block);
    end
end
stego = uint8(stego);

subplot(1,2,1);
imshow(carrier);
subplot(1,2,2);
imshow(stego);

imwrite(stego, 'stego.jpg');
%%
%{
1) Split image into 8x8 blocks, perform DCT
2) Loop through all of the blocks
2a) Within each block, compare the pre-selected cells, C1 and C2
2b-i)  If C1 <= C2, value is 0
2b-ii) If C1 > C2, value is 1
%}

clear;
clc;

% Dimension of block that image will be split into
block_width = 8;
block_height = 8;

% Location of s1 and s2 within each block
% Comparing these values determines the binary value
s1x = 4;
s1y = 1;
s2x = 3;
s2y = 2;

stego = imread('stego2.jpg');
[width height rgb] = size(stego);

grid_width = width / block_width;
grid_height = height / block_height;

stego_bin = zeros(1, grid_width * grid_height);
stego_bin_i = 1;

for gx = 1:grid_height
    for gy = 1:grid_width
        
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

bin2str(stego_bin)