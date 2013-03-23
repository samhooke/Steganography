function output = steg_hide_dct(carrier,secret,bits)

carrier = uint8(dct(double(carrier)));
steg = steg_hide_lsb(carrier,secret,bits);
output = uint8(idct(double(steg)));

end

