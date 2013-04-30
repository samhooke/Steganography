%% Example calling nice functions

msg = [0 1 1 0 1 0 0 1];

msg_sent = hamming_encode(msg);

% Chance of flipping a random bit
if rand > 0.5
    msg_received = msg_sent;
    rnd_pos = floor(1 + rand * length(msg_received));
    msg_received(1,rnd_pos) = mod(msg_received(1,rnd_pos) - 1,2);
end

msg_final = hamming_decode(msg_received);

msg
msg_sent
msg_final

%% Example calling base functions

msg = [0 1 1 0 1 0 0 1];

% Calculates the length of the string
n = length(msg);

% Calculate number of parity bits
nbp = floor(log2(n + ceil(log2(n)))) + 1;

msg_sent = insert_parity_bits(msg,nbp);

% Chance of flipping a random bit
if rand > 0.5
    msg_received = msg_sent;
    rnd_pos = floor(1 + rand * length(msg_received));
    msg_received(1,rnd_pos) = mod(msg_received(1,rnd_pos) - 1,2);
end

% Detect errors
vect_error = error_check(msg_received,nbp);
if sum(vect_error) ~= 0
    % Error exists, so find it and correct it
    pos_err = find_error(msg_received,nbp);
    msg_corrected = correct_message(msg_received,nbp);
    msg_final = message_decode(msg_corrected,nbp);
else
    % No error; simply decode the message
    msg_final = message_decode(msg_received, nbp);
end

msg
msg_sent
msg_final