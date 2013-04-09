function [extracted_msg_bin] = steg_fusion_decode(im_stego, im_original, mode)
% steg_fusion_decode Performs steganography using fusion through wavelets
%   See paper: "Data Hiding techniques Based On Wavelet-like transform and Complex Wavelet Transforms"
% INPUTS
%   im_stego    - Stego image to extract message from.
%   im_original - Original image used before steganography.
%   mode        - Wavelet mode, e.g. 'haar'.
% OUTPUTS
%   extracted_msg_bin - The extracted message in binary.

[lls lhs hls hhs] = dwt2(im_stego, mode);
[llo lho hlo hho] = dwt2(im_original, mode);

hh = hhs - hho;
[w h] = size(hh);

extracted_msg_bin = zeros(1, w * h);

extracted_msg_pos = 1;
for x = 1:w
    for y = 1:h
        if hh(x,y) > 0
            extracted_msg_bin(extracted_msg_pos) = 1;
        else
            extracted_msg_bin(extracted_msg_pos) = 0;
        end;
        extracted_msg_pos = extracted_msg_pos + 1;
    end;
end;

end

