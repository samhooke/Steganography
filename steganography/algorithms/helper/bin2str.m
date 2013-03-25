function s = bin2str( a )
b = char(a(:)'+'0')';
b = reshape(b, 8, length(a(:))/8)';
s = char(bin2dec(b))';
end

