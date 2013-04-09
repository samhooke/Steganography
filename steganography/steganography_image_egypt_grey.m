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
[CLL1 CLH1 CHL1 CHH1] = dwt2(im_carrier, mode);
[SLL1 SLH1 SHL1 SHH1] = dwt2(im_secret, mode);
[cw ch] = size(CLL1);
[sw sh] = size(SLL1);
cw = cw/4;
ch = ch/4;
sw = sw/4;
sh = sh/4;

% Best block (key 1)
best_k1 = 0;
best_k1_rmse = Inf('double');

% Number of secret and carrier blocks
ns = sw * sh;
nc = cw * ch;

% Split into a 2D array of 4x4 cells, then arrange them into a 1D array
BS = reshape(mat2cell(SLL1, ones(1, sw) * 4, ones(1, sh) * 4)', 1, ns);
BC = reshape(mat2cell(CLL1, ones(1, cw) * 4, ones(1, ch) * 4)', 1, nc);
BH = reshape(mat2cell(CHL1, ones(1, cw) * 4, ones(1, ch) * 4)', 1, nc);
key1 = zeros(1, ns);
key2 = zeros(1, nc);

for i = 1:ns
    % For each BSi in SLL1, find the best matched block BCk1 in CLL1
    for k1 = 1:nc
        current_rmse = rmse2(BS{i}, BC{k1});
        
        % Compare their RMSE
        if (current_rmse < best_k1_rmse)
            best_k1_rmse = current_rmse;
            best_k1 = k1;
        end
    end
    
    % Store the best matched block location in K1
    key1(i) = best_k1;
end

% Calculate error block (EBi = BCk1 - BSi)
EB = cellfun(@minus, BC, BS, 'Un', 0);

% Best block (key 2)
best_k2 = 0;
best_k2_rmse = Inf('double');

% Make a copy of CHL1, which will be modified
BH_stego = BH;

for i = 1:ns
    % For each EBi, find the best matched block BHk2 in CHL1
    for k2 = 1:nc
        current_rmse = rmse2(EB{i}, BH{k2});
        
        % Compare their RMSE
        if (current_rmse < best_k2_rmse)
            best_k2_rmse = current_rmse;
            best_k2 = k2;
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
im_stego = idwt2(CLL1, CLH1, CHL1_stego, CHH1, mode);

subplot(1,2,1);
imshow(im_wavelet, [0 255]);
subplot(1,2,2);
imshow(im_stego, [0 255]);

% Decode
% ======

%{

%}