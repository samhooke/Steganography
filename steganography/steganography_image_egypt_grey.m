clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena_tiny.jpg'];
secret_image_filename = [dir_input, 'peppers_tiny.jpg'];
output_image_filename = [dir_output, 'lena_egypt.jpg'];

%@@ Output image quality
output_quality = 100;

%@@ Wavelet transformation
mode = 'db1';

%{
C = im_carrier
S = im_secret
G = im_stego
(1) Perform 2D-DWT on C and S to obtain 4 subimages for each:
    (CLL1, CLH1, CHL1, CHH1) and (SLL1, SLH1, SHL1, SHH1)

(2) Take SLL1, CLL1 and SHL1. Part them into blocks of 4x4 pixels such that:
        SLL1 = {BSi ; 1 <= i  < ns}
        CLL1 = {BCk1; 1 <= k1 < nc}
        CHL1 = {BHk2; 1 <= k2 < nc}
    BSi is ith block in SLL1
    BCk1 is k1th block in CLL1
    BHk2 is k2th block in CHL1
    ns is number of 4x4 blocks in SLL1
    nc is number of 4x4 blocks in CLL1 or CHL1 (they are the same size)

(3) For each block BSi in SLL1, find the best matched block BCk1 of minimum
    error in CLL1. Search using root mean squared error (RMSE).
    Key K1 consists of addresses k1 of the best matched blocks in CLL1.

(4)  Calculate the error block, EBi, between BCk1 and BSi as follows:
        EBi = BCk1 - BSi

(5) For each error block EBi, find the best matched block BHk2 of minimum
    error in CHL1. Search using root mean squared error (RMSE).
    Key K2 consists of addresses k2 of the best matched blocks in CHL1.

(6) Repeat (3) to (5) until all error blocks are embedded in CHL1.

(7) Apply 2D-IDWT to (CLL1, CLH1, CHH1, CHL1) to obtain G.
%}

% Load images as greyscale, for simplicity in this first implementation
im_carrier = rgb2gray(imread(carrier_image_filename));
im_secret = rgb2gray(imread(secret_image_filename));

% Calculate the 4 subimages for C and S
[cll1 clh1 chl1 chh1] = dwt2(im_carrier, mode);
[sll1 slh1 shl1 shh1] = dwt2(im_secret, mode);

% SLL1, CLL1 and SHL1

% For each 4x4 block in SLL1, find the best matched block in CLL1
[w h] = size(cll1);

w = w/4;
h = h/4;

% Blocks
bs = zeros(4, 4);
bc1 = zeros(4, 4);

% Best block
best_k1 = 0;
best_rmse = Inf('double');

tic

% Split SLL1 and CLL1 into a 1D array of 4x4 blocks
cellw = ones(1, w) * 4;
cellh = ones(1, h) * 4;

ns = w * h;
nc = w * h;

% reshape([1 2 3;4 5 6;7 8 9]', 1, 9) => [1 2 3 4 5 6 7 8 9]
bs = reshape(mat2cell(sll1, cellw, cellh)', 1, ns);
bc1 = reshape(mat2cell(cll1, cellw, cellh)', 1, nc);
key1 = zeros(1, nc);

for i = 1:ns
    % For each BSi in SLL1, find the best matched block in CLL1
    for k1 = 1:nc
        current_rmse = rmse2(bs{i}, bc1{k1});
        
        % Compare their RMSE
        if (current_rmse < best_rmse)
            best_rmse = current_rmse;
            best_k1 = k1;
        end
    end
    
    % Store the best matched block location in K1
    key1(i) = best_k1;
end

%{
bs_bc1_rmse = zeros(w, h);
for j = 1:w*h
    for i = 1:w*h
        bs_bc1_rmse(i, j) = rmse2(bs{i}, bc1{j});
    end
end
bs_bc1_rmse = reshape(bs_bc1_rmse', 1, w * h);
%}
toc

%{
tic
for sy = 0:h-1;
    for sx = 0:w-1;
        % For each BSi in SLL1...
        bs = sll1(sx*4+1:(sx+1)*4, sy*4+1:(sy+1)*4);

        % ...find the best matched block BCk1 in CLL1
        for cy = 0:h-1;
            for cx = 0:w-1;
                bc1 = cll1(cx*4+1:(cx+1)*4, cy*4+1:(cy+1)*4);
                
                current_rmse = rmse(bs, bc1);
                
                % Compare their RMSE
                if (current_rmse < best_rmse)
                    best_rmse = current_rmse;
                    best_cx = cx;
                    best_cy = cy;
                end
            end
        end
        
        % We now know which has the lowest RMSE match
        key1_x(sx + 1, sy + 1) = best_cx;
        key1_y(sx + 1, sy + 1) = best_cy;
    end
end
toc
%}

%im_wavelet = [cll1, clh1; chl1, chh1];
%im_stego = idwt2(cll1, clh1, chl1, chh1, mode);

% Decode
% ======

%{

%}