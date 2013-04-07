function a = str2bin( s )
a = dec2bin(s, 8)';
a = a(:)'-'0';
end

