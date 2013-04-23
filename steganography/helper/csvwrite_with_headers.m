function csvwrite_with_headers(filename, data, headers)

fid = fopen(filename, 'w');
fprintf(fid, [headers, '\n']);
fclose(fid);

dlmwrite(filename, data, '-append', 'precision', '%.6f', 'delimiter', ',');

end

