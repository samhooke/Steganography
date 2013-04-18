function test_data_save(output_csv_filename, iteration_data)

csvwrite_with_headers(output_csv_filename, iteration_data, '"JPEG Quality (%%)","Similarity Python (%%)","Similarity Matlab (%%)","PSNR (dB)","Encode Time (s)","Decode Time (s)","Length (bytes)"');

end