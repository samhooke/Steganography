clc;
clear variables;
[dir_input, dir_output] = steganography_init();

tic

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
secret_image_filename = [dir_input, 'peppers.jpg'];
output_image_filename = [dir_output, 'lena_egypt.jpg'];

%@@ Output image quality
output_quality = 100;

%@@ Wavelet transformation
mode = 'db1';
%db# 1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45
%coif# 3
%sym# 1, 5...
%bior#.# 1.1, 1.5, 2.4, 2.8, 4.4, 6.8
%rbio#.# 1.1, 1.5...


%@@ Whether each value in the key must be unique
unique_k1 = false;
unique_k2 = false;

%@@ Block size
block_size = 4;

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
[CLL1 CLH1 CHL1 CHH1] = dwt2(im_carrier, mode);
[SLL1 SLH1 SHL1 SHH1] = dwt2(im_secret, mode);
[cw ch] = size(CLL1);
[sw sh] = size(SLL1);
cw = (cw/block_size);
ch = (ch/block_size);
sw = (sw/block_size);
sh = (sh/block_size);

% Number of secret and carrier blocks
ns = sw * sh;
nc = cw * ch;

% Split into a 2D array of 4x4 cells, then arrange them into a 1D array
BS = reshape(mat2cell(SLL1, ones(1, sw) * block_size, ones(1, sh) * block_size)', 1, ns);
BC = reshape(mat2cell(CLL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);
BH = reshape(mat2cell(CHL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);
EB = BH;

% Initiate keys at -1, the negative value indicates it is unset
key1 = zeros(1, ns) - 1;
key2 = zeros(1, nc) - 1;

for i = 1:ns
    % For each BSi in SLL1, find the best matched block BCk1 in CLL1
    best_k1 = 0;
    best_k1_rmse = Inf('double');
    for k1 = 1:nc
        current_rmse = rmse2(BS{i}, BC{k1});
        
        % Compare their RMSE
        if (current_rmse < best_k1_rmse)
            
            % Check this block has not been used yet, to ensure uniqueness
            %if ~unique_k1 || (unique_k1 && ~any(key1 == k2))
            if ~unique_k1 || ~any(key1 == k1)
                best_k1_rmse = current_rmse;
                best_k1 = k1;
            end
        end
    end
    
    % Store the best matched block location in K1
    key1(i) = best_k1;
    
    % Calculate error block (EBi = BCk1 - BSi)
    EB{i} = BC{k1} - BS{i};
end

% Calculate error block (EBi = BCk1 - BSi)
%EB = cellfun(@minus, BC, BS, 'Un', 0);

% Make a copy of CHL1, which will be modified
BH_stego = BH;

for i = 1:ns
    % For each EBi, find the best matched block BHk2 in CHL1
    best_k2 = 0;
    best_k2_rmse = Inf('double');
    for k2 = 1:nc
        current_rmse = rmse2(EB{i}, BH{k2});
        
        % Compare their RMSE
        if (current_rmse < best_k2_rmse)
            
            % Check this block has not been used yet, to ensure uniqueness
            %if ~unique_k2 || (unique_k2 && ~any(key2 == k2))
            if ~unique_k2 || ~any(key2 == k2)
                best_k2_rmse = current_rmse;
                best_k2 = k2;
            end
        end
    end
    
    % Store the best matched block location in K1
    key2(i) = best_k2;
    
    % Also, replace the block
    BH_stego{best_k2} = EB{i};
end

% Form CHL1 with the stego stuff
CHL1_stego = cell2mat(reshape(BH_stego, cw, ch)');

im_wavelet = [CLL1, CLH1; CHL1_stego, CHH1];
im_stego = uint8(idwt2(CLL1, CLH1, CHL1_stego, CHH1, mode));

imwrite(im_stego, output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Need key1, key2 & im_stego (K1, K2 & G)

%{
(1) Perform 1 level 2D-IDWT on G to obtain 4 subimages:
    (GLL1, GLH1, GHL1, GHH1)
(2) Extract block BCk1 from GLL1 using K1
    Extract block EBi from GHL1 using K2
    Obtain BSi with:
        BSi = BCk1 - EBi
(3) Repeat (2) until all secret blocks are extracted and form subimage SLL1
(4) Set SHL1, SLH1 and SHH1 to zeros. Apply 2D-IDWT to obtain secret image
%}

% Load G
im_stego = imread(output_image_filename);

% Perform 2D-IDWT on G
[GLL1 GLH1 GHL1 GHH1] = dwt2(im_stego, mode);

BGLL1 = reshape(mat2cell(GLL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);
BGHL1 = reshape(mat2cell(GHL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);

for i = 1:ns
    BC{i} = BGLL1{key1(i)};
    EB{i} = BGHL1{key2(i)};
    BS{i} = BC{i} - EB{i};
end

SLL1 = cell2mat(reshape(BS, cw, ch)');
SHL1 = zeros(cw * block_size, ch * block_size);
SLH1 = zeros(cw * block_size, ch * block_size);
SHH1 = zeros(cw * block_size, ch * block_size);

im_extracted = uint8(idwt2(SLL1, SLH1, SHL1, SHH1, mode));

toc

subplot(2,2,1);
imshow(im_wavelet, [0 255]);
title('Stego image (wavelet transformed)');
subplot(2,2,2);
imshow(im_stego, [0 255]);
title('Stego image');
subplot(2,2,3);
imshow(im_secret, [0 255]);
title('Secret image - before');
subplot(2,2,4);
imshow(im_extracted, [0 255]);
title('Secret image - after');