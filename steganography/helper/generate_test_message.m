function msg = generate_test_message(num_characters)
% generate_test_message() Returns an extract of Sherlock Holmes
%   Useful for when regular text is required for steganography tests
% INPUTS
%   num_characters - How many characters to return
% OUTPUTS
%   msg - The extract from Sherlock Holmes

message_filename = '\input\sherlock.txt';
fid = fopen(message_filename, 'rb');
b = fread(fid, '*uint8')';
fclose(fid);

msg = native2unicode(b, 'UTF-8');
msg = msg(1:num_characters);

end

