clear;
clc;

secret = repmat('Mary had a little lamb, its fleece was white as snow...', 1, 100);
carrier = rgb2gray(imread('lena512.jpg'));

steg = steg_encode_lsb(carrier, str2bin(secret));

imshow(steg, [0 255]);

secret_extracted = bin2str(steg_decode_lsb(steg));

disp(secret_extracted);


%%
clear;
clc;

secret = repmat('Mary had a little lamb, its fleece was white as snow...', 1, 100);
carrier = rgb2gray(imread('lena512.jpg'));

secret_bin = str2bin(secret);

if (length(secret_bin(:)) > length(carrier(:)))
    error('secret is too large to fit within carrier');
else
    secret_padded = zeros(length(carrier(:)), 1);
    secret_padded(1:length(secret_bin)) = secret_bin;
    d = size(carrier);
    secret_padded = logical(reshape(secret_padded, d));

    steg = mod(secret_padded, 2) + double(bitshift(carrier, -1) * 2);
end

imshow(steg, [0 255]);

output = mod(steg,2);

secret_extracted = bin2str(output);

fprintf('encoded secret length = %d, decoded secret length = %d\n', length(secret), length(secret_extracted));
disp(secret_extracted);

%{
clear;
clc;

bits = 2;

%secret = repmat('Mary had a little lamb, its fleece was white as snow...', 1, 100);
s = 'test post please ignore!';
secret = repmat(s, 1, (256 * 256 * bits) / (8 * length(s)));

carrier = rgb2gray(imread('carrier.png'));

secret_bin = str2bin(secret);


if (length(secret_bin(:)) > length(carrier(:)) * bits)
    error('secret is too large to fit within carrier');
else
    secret_padded = zeros(length(carrier(:)) * bits, 1);
    secret_padded(1:length(secret_bin)) = secret_bin;
    d = [size(carrier) bits];
    secret_padded = logical(reshape(secret_padded, d));
    
    pbits = power(2, bits);
    
    
    steg = mod(secret_padded(:,:,1), pbits) + double(bitshift(carrier, -bits) * pbits);
end

imshow(steg, [0 1]);

output = mod(steg,power(2,1));

secret_extracted = bin2str(output);

length(secret)
length(secret_extracted)
secret_extracted
%}