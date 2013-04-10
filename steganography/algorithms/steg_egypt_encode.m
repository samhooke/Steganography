function [im_stego, key1, key2, im_wavelet_stego, im_wavelet_secret] = steg_egypt_encode(im_carrier, im_secret, mode, block_size)
% steg_egypt_encode() Perform Egypt steganography algorithm
% INPUTS
%    im_carrier - Carrier image
%    im_secret  - Secret image (same size or smaller than carrier)
%    mode       - Wavelet mode to use
%    block_size - Size of blocks to split subimages into [Default: 4]
% OUTPUTS
%    im_stego          - Stego image
%    key1              - K1, required for decoding
%    key2              - K2, required for decoding
%    im_wavelet_stego  - DWT of stego image
%    im_wavelet_secret - DWT of secret image

%@@ Whether each value in the key must be unique
%@@ [Default: false, false]
unique_k1 = false;
unique_k2 = false;

%@@ Whether to overwrite BH during encoding, or use a temporary copy
%@@ [Default: false]
overwrite_BH = false;

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
        current_rmse = rmse2_lazy(BS{i}, BC{k1});
        
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
            current_rmse = rmse2_lazy(EB{i}, BH{k2});
        else
            current_rmse = rmse2_lazy(EB{i}, BH_stego{k2});
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

im_wavelet_stego = [CLL1, CHL1_stego; CLH1, CHH1];
im_wavelet_secret = [SLL1, SHL1; SLH1, SHH1];

im_stego = idwt2_pascal(CLL1, CLH1, CHL1_stego, CHH1, mode);

end

