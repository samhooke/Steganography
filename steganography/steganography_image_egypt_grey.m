%{

Encode
======

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


Decode
======

(1) Perform 1 level 2D-IDWT on G to obtain 4 subimages:
    (GLL1, GLH1, GHL1, GHH1)
(2) Extract block BCk1 from GLL1 using K1
    Extract block EBi from GHL1 using K2
    Obtain BSi with:
        BSi = BCk1 - EBi
(3) Repeat (2) until all secret blocks are extracted and form subimage SLL1
(4) Set SHL1, SLH1 and SHH1 to zeros. Apply 2D-IDWT to obtain secret image

%}

clc;
clear variables;
[dir_input, dir_output] = steganography_init();

% Encode
% ======

%@@ Input image and output location
carrier_image_filename = [dir_input, 'lena.jpg'];
secret_image_filename = [dir_input, 'peppers_small.jpg'];
output_image_filename = [dir_output, 'lena_egypt.jpg'];

%@@ Output image quality
output_quality = 75;

%@@ Wavelet transformation
mode = 'idk';

%@@ Whether each value in the key must be unique
%@@ [Default: false, false]
unique_k1 = false;
unique_k2 = false;

%@@ Block size
%@@ [Default: 4]
block_size = 4;

%@@ Whether to overwrite BH during encoding, or use a temporary copy
%@@ [Default: false]
overwrite_BH = false;

% Load images as greyscale, for simplicity in this first implementation
im_carrier = double(rgb2gray(imread(carrier_image_filename)));
im_secret = double(rgb2gray(imread(secret_image_filename)));

% Calculate the 4 subimages for C and S
[CLL1 CLH1 CHL1 CHH1] = dwt2_pascal(im_carrier, mode);
[SLL1 SLH1 SHL1 SHH1] = dwt2_pascal(im_secret, mode);
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

% Create blank array of cells, which will store the error blocks
EB = reshape(mat2cell(zeros(sw * block_size, sh * block_size), ones(1, sw) * block_size, ones(1, sh) * block_size)', 1, ns);

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
            
            % Ensure uniqueness, if required
            if ~unique_k1 || ~any(key1 == k1)
                best_k1_rmse = current_rmse;
                best_k1 = k1;
            end
        end
    end
    
    % Store the best matched block location in K1
    key1(i) = best_k1;
    
    % Calculate error block (EBi = BCk1 - BSi)
    EB{i} = BC{key1(i)} - BS{i};
end

if ~overwrite_BH
    % Make a copy of CHL1, which will be modified
    BH_stego = BH;
end

for i = 1:ns
    % For each EBi, find the best matched block BHk2 in CHL1
    best_k2 = 0;
    best_k2_rmse = Inf('double');
    for k2 = 1:nc
        if overwrite_BH
            current_rmse = rmse2(EB{i}, BH{k2});
        else
            current_rmse = rmse2(EB{i}, BH_stego{k2});
        end
        
        % Compare their RMSE
        if (current_rmse < best_k2_rmse)
            
            % Ensure uniqueness, if required
            if ~unique_k2 || ~any(key2 == k2)
                best_k2_rmse = current_rmse;
                best_k2 = k2;
            end
        end
    end
    
    % Store the best matched block location in K1
    key2(i) = best_k2;
    
    % Also, replace the block
    if overwrite_BH
        %BH{best_k2} = EB{i};
        BH{best_k2} = BH{best_k2} + EB{i};
    else
        %BH_stego{best_k2} = EB{i};
        BH_stego{best_k2} = BH{best_k2} + EB{i};
    end
end

% Form CHL1 with the stego stuff
if overwrite_BH
    CHL1_stego = cell2mat(reshape(BH, cw, ch)');
else
    CHL1_stego = cell2mat(reshape(BH_stego, cw, ch)');
end

im_wavelet = [CLL1, CHL1_stego; CLH1, CHH1];
im_wavelet_s = [SLL1, SHL1; SLH1, SHH1];

im_stego = idwt2_pascal(CLL1, CLH1, CHL1_stego, CHH1, mode);
%im_stego = idwt2_pascal(CLL1, CLH1, CHL1, CHH1, mode);

imwrite(uint8(im_stego), output_image_filename, 'Quality', output_quality);

% Decode
% ======

% Need key1, key2 & im_stego (K1, K2 & G)

% Load G
im_stego = double(imread(output_image_filename));

% Perform 2D-IDWT on G
[GLL1 GLH1 GHL1 GHH1] = dwt2_pascal(im_stego, mode);

BGLL1 = reshape(mat2cell(GLL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);
BGHL1 = reshape(mat2cell(GHL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);

for i = 1:ns
    BC{i} = BGLL1{key1(i)};
    EB{i} = BGHL1{key2(i)};
    BS{i} = BC{i} - EB{i};
    %BS{i} = EB{i} + BC{i};
end

SLL1 = cell2mat(reshape(BS, sw, sh)');
SHL1 = zeros(sw * block_size, sh * block_size);
SLH1 = zeros(sw * block_size, sh * block_size);
SHH1 = zeros(sw * block_size, sh * block_size);

im_errors = cell2mat(reshape(EB, sw, sh)');

im_extracted = double(idwt2_pascal(SLL1, SLH1, SHL1, SHH1, mode));

wmin = min(min(min(min(im_wavelet_s)), min(min(im_wavelet))), min(min(im_errors)));
wmax = max(max(max(max(im_wavelet_s)), max(max(im_wavelet))), max(max(im_errors)));

subplot(2,3,1);
imshow(im_wavelet_s, [wmin wmax]);
title('Secret image (wavelet transformed)');
subplot(2,3,4);
imshow(im_wavelet, [wmin wmax]);
title('Stego image (wavelet transformed)');

subplot(2,3,2);
imshow(im_stego, [0 255]);
title('Stego image');
subplot(2,3,5);
imshow(im_errors, [wmin wmax]);
title('Error blocks');

subplot(2,3,3);
imshow(im_secret, [0 255]);
title('Secret image - before');
subplot(2,3,6);
imshow(im_extracted, [0 255]);
title('Secret image - after');