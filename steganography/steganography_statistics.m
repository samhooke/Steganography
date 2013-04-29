function [length_bytes, msg_similarity_py, msg_similarity, im_psnr] = steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin, encode_time, decode_time)
% steganography_statistics() Show metrics about before/after steganography
% INPUTS
%    imc               - Original image (one channel)
%    imc_stego         - Steganographic image (one channel)
%    secret_msg_bin    - Message before encoding (in binary)
%    extracted_msg_bin - Message after encoding (in binary)
% OUTPUTS
%    Prints out statistics.

%@@ Whether to output the message decoded from binary
%@@ Also whether they should be truncated. Set to 0 to display full string
output_message_strings = false;
output_message_truncate = 100;%Inf('double');

%@@ Whether to calculate message similarity at binary level
%@@ _py method calls Python, the other one uses a Matlab function
calculate_message_similarity_py = true;
calculate_message_similarity = true;

%@@ Leave at false - spelling correction is far too slow
try_correcting_spelling = false;

% Calculate PSNR
im_psnr = PSNR(imc, imc_stego);

% Calculate message similarity (using Python)
msg_similarity_py = py_string_similarity(bin2binstr(secret_msg_bin), bin2binstr(extracted_msg_bin));

% Calculate message similarity
msg_similarity = string_similarity(bin2binstr(secret_msg_bin), bin2binstr(extracted_msg_bin), 0);

% Convert binary messages to string
secret_msg_str = bin2str(secret_msg_bin);
extracted_msg_str = bin2str(extracted_msg_bin(1:floor(length(extracted_msg_bin)/8)*8)); % Ensure msg is multiple of 8

% Calculate length
length_bytes = length(secret_msg_str);

if try_correcting_spelling
    % Try performing spelling correction on the output
    corrected_msg_str = py_spelling(extracted_msg_str);
    corrected_msg_bin = str2bin(corrected_msg_str);
    msg_similarity_corrected = py_string_similarity(bin2binstr(secret_msg_bin), bin2binstr(corrected_msg_bin));
end

% ---=== Show statistics ===---

fprintf('Encode time: %fs\n', encode_time);
fprintf('Decode time: %fs\n', decode_time);

% PSNR of input image to output image
fprintf('PSNR: %f\n', im_psnr);

% Percentage similarity of input secret to output secret
if calculate_message_similarity_py
    fprintf('Message similarity (Python): ~%2.2f%%\n', msg_similarity_py * 100);
end
if calculate_message_similarity
    fprintf('Message similarity (Matlab): ~%2.2f%%\n', msg_similarity * 100);
end

% Correction of spelling
if try_correcting_spelling
    % TODO: Similarity is biased towards shorter strings
    % The correct string often comes out shorter because of the processing
    fprintf('Corrected similarity: ~%2.2f%%\n', msg_similarity_corrected * 100);
end

% Output message before and after
if output_message_strings
    fprintf('Encoded message length: %d bytes\n', length_bytes);
    fprintf('Encoded message: %s\n', secret_msg_str(1:min(output_message_truncate, length(secret_msg_str))));
    fprintf('Decoded message: %s\n', extracted_msg_str(1:min(output_message_truncate, length(extracted_msg_str))));

    if try_correcting_spelling
        fprintf('Corrected message: %s\n', corrected_msg_str(1:min(output_message_truncate, length(corrected_msg_str))));
    end
end

end