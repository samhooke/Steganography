function [im_stego, im_wavelet_original, im_wavelet_stego] = steg_fusion_encode(im, secret_msg_bin, alpha, mode)
% steg_fusion_encode Performs steganography using fusion through wavelets
%   See paper: "Data Hiding techniques Based On Wavelet-like transform and Complex Wavelet Transforms"
% INPUTS
%   im             - Carrier image. Must only have 1 colour channel.
%   secret_msg_bin - Binary data to encode.
%   alpha          - Preprocessing parameter (preferably 0.05).
%   mode           - Wavelet mode, e.g. 'haar'.
% OUTPUTS
%   im_stego            - Carrier image with message embedded.
%   im_wavelet_original - For debugging. Wavelet transform before stego.
%   im_wavelet_stego    - For debugging. Wavelet transform after stego.

secret_msg_bin_len = length(secret_msg_bin);
uint8_max = 255;

% Normalise
im = double(im) / uint8_max;

 % Preprocess
im(im < alpha) = alpha;
im(im > 1 - alpha) = 1 - alpha;

% Perform wavelet transform
[ll lh hl hh] = dwt2(im, mode);

% For debugging, take a copy of the transform before stego
im_wavelet_original = [ll, lh; hl, hh];

secret_msg_pos = 1;
[w h] = size(hh);
for x = 1:w
    for y = 1:h
        % Choose bit to encode
        if secret_msg_pos <= secret_msg_bin_len
            bit = secret_msg_bin(secret_msg_pos);
            secret_msg_pos = secret_msg_pos + 1;
        else
            bit = 0;
        end;
        
        % Encode the bit
        if bit == 1
            hh(x,y) = hh(x,y) + alpha;
        else
            hh(x,y) = hh(x,y) - alpha;
        end;
    end;
end;

% For debug, take a copy of the transform after stego
im_wavelet_stego = [ll, lh; hl, hh];

% Inverse wavelet transform
im_stego = idwt2(ll, lh, hl, hh, mode);

% Denormalise
im_stego = uint8(im_stego * uint8_max);

end