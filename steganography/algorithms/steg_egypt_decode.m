function [im_extracted, im_errors] = steg_egypt_decode(im_stego, im_secret_width, im_secret_height, key1, key2, mode, block_size)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

% Perform 2D-DWT on G
[GLL1 GLH1 GHL1 GHH1] = dwt2_pascal(im_stego, mode);

% Width and height of stego image and secret image
[cw ch] = size(GLL1);
cw = cw / block_size;
ch = ch / block_size;
sw = (im_secret_width / 2) / block_size;
sh = (im_secret_height / 2) / block_size;

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
im_errors = cell2mat(reshape(EB, sw, sh)');

% Reform the subimage
SLL1 = cell2mat(reshape(BS, sw, sh)');

% Create the other 3 subimages as just zeros
SHL1 = zeros(sw * block_size, sh * block_size);
SLH1 = SHL1;
SHH1 = SHL1;

% Perform 2D-IDWT to extract the secret image
im_extracted = double(idwt2_pascal(SLL1, SLH1, SHL1, SHH1, mode));

end