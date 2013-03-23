function output = steg_extract_dct(carrier,bits)

steg = uint8(dct(double(carrier)));
steg_secret = steg_extract_lsb(steg,bits);
output = uint8(idct(double(steg_secret)));

end