function [im_extracted, im_errors] = steg_egypt_decode(im_stego, im_secret_width, im_secret_height, key1, key2, mode, block_size, is_binary)
% steg_egypt_decode() Perform Egypt steganography decoding algorithm
% INPUTS
%    im_stego         - Stego image to extract secret image from
%    im_secret_width  - Width of expected secret image
%    im_secret_height - Height of expected secret image
%    key1             - Key1, which was generated during encoding
%    key2             - Key2, which was generated during encoding
%    mode             - Wavelet mode [Default: 'idk']
%    block_size       - Size of blocks used during encoding [Default: 4]
%    is_binary        - Whether the secret is binary data, or an image. If
%                       true the extracted image is not transformed in any
%                       way after decoding.
% OUTPUTS
%    im_extracted - The extracted secret image
%    im_errors    - For debugging, an image of the error blocks

%{
Decoding algorithm
==================

(1) Perform 1 level 2D-IDWT on G to obtain 4 subimages:
    (GLL1, GLH1, GHL1, GHH1)
(2) Extract block BCk1 from GLL1 using K1
    Extract block EBi from GHL1 using K2
    Obtain BSi with:
        BSi = BCk1 - EBi
(3) Repeat (2) until all secret blocks are extracted and form subimage SLL1
(4) Set SHL1, SLH1 and SHH1 to zeros. Apply 2D-IDWT to obtain secret image
%}

% Perform 2D-DWT on G
[GLL1 GLH1 GHL1 GHH1] = dwt2_pascal(im_stego, mode);

% Width and height of stego image and secret image
[cw ch] = size(GLL1);
cw = cw / block_size;
ch = ch / block_size;
if ~is_binary
    sw = (im_secret_width / 2) / block_size;
    sh = (im_secret_height / 2) / block_size;
else
    sw = im_secret_width / block_size;
    sh = im_secret_height / block_size;
end

% Number of secret and carrier blocks
ns = sw * sh;
nc = cw * ch;

BGLL1 = reshape(mat2cell(GLL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);
BGHL1 = reshape(mat2cell(GHL1, ones(1, cw) * block_size, ones(1, ch) * block_size)', 1, nc);

% Create blank array of cells, which will store the error blocks
BC = reshape(mat2cell(zeros(sw * block_size, sh * block_size), ones(1, sw) * block_size, ones(1, sh) * block_size)', 1, ns);
EB = BC;
BS = BC;

% Extract blocks using keys
for i = 1:ns
    BC{i} = BGLL1{key1(i)};
    EB{i} = BGHL1{key2(i)};
    BS{i} = BC{i} - EB{i};
end

% For debugging, create an image of the block errors
im_errors = cell2mat(reshape(EB, sh, sw)');

% Reform the subimage
SLL1 = cell2mat(reshape(BS, sh, sw)');

% Create the other 3 subimages as just zeros
SHL1 = zeros(sw * block_size, sh * block_size);
SLH1 = SHL1;
SHH1 = SHL1;

% Perform 2D-IDWT to extract the secret image
if ~is_binary
    im_extracted = double(idwt2_pascal(SLL1, SLH1, SHL1, SHH1, mode));
else
    im_extracted = SLL1;
end

end