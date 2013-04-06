function steganography_statistics(imc, imc_stego, secret_msg_bin, extracted_msg_bin)
% steganography_statistics() Show metrics about before/after steganography
% INPUTS
%    imc               - Original image (one channel)
%    imc_stego         - Steganographic image (one channel)
%    secret_msg_bin    - Message before encoding (in binary)
%    extracted_msg_bin - Message after encoding (in binary)
% OUTPUTS
%    Prints out statistics.

% Convert binary messages to string
secret_msg_str = bin2str(secret_msg_bin);
extracted_msg_str = bin2str(extracted_msg_bin);

% Calculate error
imc_error = (imc - imc_stego) .^ 2;
imc_error_sum = sum(imc_error);

% Show statistics
fprintf('Image error: %d\n', sum(imc_error_sum));
fprintf('Encoded message: %s\n', secret_msg_str);
fprintf('Decoded message: %s\n', extracted_msg_str);

end

