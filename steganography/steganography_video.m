clc;
clear variables;
[dir_input, dir_output, dir_results] = steganography_init();

%@@ Output video, format and compression
%@@ 1 = Archival          (.mj2)
%@@ 2 = Motion JPEG AVI   (.avi)
%@@ 3 = Motion JPEG 2000  (.mj2)
%@@ 4 = MPEG-4            (.mp4)
%@@ 5 = Uncompressed AVI  (.avi)
profile_type = 3;

%@@ Video quality
%@@ NOTE: Only applicable to Motion JPEG AVI and MPEG-4
output_quality = 75;

%@@ Choose algorithm: LSB, DCT, ZK, WDCT, Fusion, Egypt
%@@ (not case sensitive)
algorithm = 'DCT';

%@@ Frames to use from the video
frame_start = 0;
frame_max = 10;

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Which colour space to use ('rgb', 'hsv', 'ycbcr');
colourspace = 'rgb';

%@@ Whether the video is greyscale
use_greyscale = false;

%@@ Name of folder to store test results in
test_name = [algorithm, '_video'];

[dir_results_full, ~] = create_directory_unique([dir_results, test_name]);
output_csv_filename = [dir_results_full, test_name, '_results.csv'];

% Encode
% ======

%@@ Input video and output video. File extension is not required for output
%@@ because it is generated based upon the chosen format.
input_video_filename = [dir_input, 'bunny.mp4'];
output_video_filename_base = [dir_results_full, 'bunny_dct'];

switch profile_type
    case 1
        profile = 'Archival';
        output_video_profilename = 'ARCH';
        output_video_ext = '.mj2';
    case 2
        profile = 'Motion JPEG AVI';
        output_video_profilename = 'MJAVI';
        output_video_ext = '.avi';
    case 3
        profile = 'Motion JPEG 2000';
        output_video_profilename = 'MJ2k';
        output_video_ext = '.mj2';
    case 4
        profile = 'MPEG-4';
        output_video_profilename = 'MPEG4';
        output_video_ext = '.mp4';
    case 5
        profile = 'Uncompressed AVI';
        output_video_profilename = 'UnAVI';
        output_video_ext = '.avi';
    otherwise
        fprintf('Invalid profile_type\n');
        break
end

output_video_filename = [output_video_filename_base, ' ', output_video_profilename, output_video_ext];

vin = VideoReader(input_video_filename);
vout = VideoWriter(output_video_filename, profile);
if (frame_max <= frame_start)
    frame_count = vin.NumberOfFrames - frame_start;
else
    frame_count = min(vin.NumberOfFrames - frame_start, frame_max);
end;
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

% Load chosen algorithm defaults
algorithm = lower(algorithm);
switch algorithm
    case 'lsb'
        [secret_msg_bin] = steg_lsb_default(width, height, use_greyscale, '');
    case 'dct'
        [secret_msg_bin, frequency_coefficients, persistence] = steg_dct_default(width, height, use_greyscale, '');
    case 'zk'
        [secret_msg_bin, frequency_coefficients, variance_threshold, minimum_distance_encode, minimum_distance_decode] = steg_zk_default(width, height, use_greyscale, '');
    case 'wdct'
        [secret_msg_bin, frequency_coefficients, persistence, mode] = steg_wdct_default(width, height, use_greyscale, '');
    case 'fusion'
        [secret_msg_bin, alpha, mode] = steg_fusion_default(width, height, use_greyscale, '');
    case 'egypt'
        [secret_msg_bin, secret_msg_binimg, secret_msg_w, secret_msg_h, mode, block_size, pixel_size, is_binary] = steg_egypt_default(width, height, use_greyscale, '');
    otherwise
        error('No such algorithm "%s" exists.', algorithm);
end

vprocess(1:frame_count) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

% Log some things that we need for statistics at the end
encode_time_log = zeros(1, frame_count);
bits_written_log = zeros(1, frame_count);

if strcmp(algorithm, 'egypt')
    % Create key1 and key2 for Egypt algorithm
    keylength = secret_msg_w / block_size * secret_msg_h / block_size;
    key1 = zeros(1, keylength, frame_count);
    key2 = zeros(1, keylength, frame_count);
end

for num = 1:frame_count
    fprintf('Processing frame %d of %d\n', num, frame_count);
    frame = read(vin, frame_start + num);
    
    frame_before = frame(:,:,channel);

    frame = cs2cs(frame, 'rgb', colourspace);
    
    if strcmp(colourspace, 'hsv')
        framec = frame(:,:,channel) * 255;
    else
        framec = frame(:,:,channel);
    end;

    % Encode
    tic;
    switch algorithm
        case 'lsb'
            [framec] = steg_lsb_encode(framec, secret_msg_bin);
        case 'dct'
            [framec, ~, ~] = steg_dct_encode(secret_msg_bin, framec, frequency_coefficients, persistence);
        case 'zk'
            [framec, bits_written_log(num), ~, ~, ~] = steg_zk_encode(secret_msg_bin, framec, frequency_coefficients, variance_threshold, minimum_distance_encode);
        case 'wdct'
            % WDCT only works on frame size of 16
            framec_part = framec(1:floorx(height, 16), 1:floorx(width, 16));
            [framec_part, ~] = steg_wdct_encode(framec_part, secret_msg_bin, mode, frequency_coefficients, persistence);
            framec(1:floorx(height, 16), 1:floorx(width, 16)) = framec_part;
        case 'fusion'
            [framec, ~, ~] = steg_fusion_encode(framec, secret_msg_bin, alpha, mode);
        case 'egypt'
            [framec, key1(:,:,num), key2(:,:,num), ~, ~] = steg_egypt_encode(framec, secret_msg_binimg, mode, block_size, is_binary);
        otherwise
            error('No such algorithm "%s" exists for encoding.', algorithm);
    end
    encode_time_log(num) = toc;

    frame(:,:,channel) = framec;
    
    frame = cs2cs(frame, colourspace, 'rgb');
    
    frame_after = frame(:,:,channel);
    
    frame = uint8(frame);
    
    vprocess(num).cdata = frame;
end;

%implay(vprocess);

% Choose video quality, if applicable
% Only works for Motion JPEG AVI and MPEG-4
if profile_type == 2 || profile_type == 4
    vout.Quality = output_quality;
else
    % If quality cannot be defined, set it to -1 for the logger
    output_quality = -1;
end

% Write video to file
open(vout);
writeVideo(vout, vprocess);
close(vout);

fprintf('Video written\n');

% Decode
% ======

vin = VideoReader(output_video_filename);
frame_count = min(vin.NumberOfFrames, frame_max);

vin_original = VideoReader(input_video_filename);

iteration_data = zeros(7, frame_count);

for num = 1:frame_count
    frame = read(vin, frame_start + num);
    frame_original = read(vin_original, frame_start + num);
    
    frame = cs2cs(frame, 'rgb', colourspace);
    frame_original = cs2cs(frame_original, 'rgb', colourspace);
    
    framec = frame(:,:,channel);
    framec_original = frame_original(:,:,channel);

    % Decode
    tic;
    switch algorithm
        case 'lsb'
            [extracted_msg_bin] = steg_lsb_decode(framec);
        case 'dct'
            [extracted_msg_bin] = steg_dct_decode(framec, frequency_coefficients);
        case 'zk'
            [extracted_msg_bin, ~, ~] = steg_zk_decode(framec, frequency_coefficients, minimum_distance_decode);
        case 'wdct'
            % WDCT only works on frame size of 16
            framec_part = framec(1:floorx(height, 16), 1:floorx(width, 16));
            [extracted_msg_bin] = steg_wdct_decode(framec_part, mode, frequency_coefficients);
        case 'fusion'
            [extracted_msg_bin] = steg_fusion_decode(framec, framec_original, mode);
        case 'egypt'
            [im_extracted, ~] = steg_egypt_decode(framec, secret_msg_w, secret_msg_h, key1(:,:,num), key2(:,:,num), mode, block_size, is_binary);
            extracted_msg_bin = binimg2bin(im_extracted, pixel_size, 127);
        otherwise
            error('No such algorithm "%s" exists for decoding.', algorithm);
    end
    decode_time = toc;
    encode_time = encode_time_log(num);
    
    extracted_msg_str = bin2str(extracted_msg_bin);
    
    fprintf('Frame %d message: "%s"\n', num, extracted_msg_str);
    
    % Calculate statistics
    [length_bytes, msg_similarity_py, msg_similarity, im_psnr] = steganography_statistics(framec_original, framec, secret_msg_bin, extracted_msg_bin, encode_time, decode_time);
    
    % Length in bytes for ZK is different because it varies depending upon
    % the image, and so was logged during encoding and is recovered now.
    if strcmp(algorithm, 'zk')
        length_bytes = bits_written_log(num)/8;
    end
    
    % Store statistics for this iteration
    iteration_data(((num - 1) * 7) + 1:((num - 1) * 7) + 1 + 6) = [output_quality, msg_similarity_py * 100, msg_similarity * 100, im_psnr, encode_time, decode_time, length_bytes];
end;

% Save statistics to file
test_data_save(output_csv_filename, iteration_data');
fprintf('Saved results at: %s\n', output_csv_filename);

% Tell Matlab to actually close the handle to the video file, because no
% other method seems to work. Not "close(vin)", nor "clear mex".
clear vin

%{
frame = cs2cs(frame, colourspace, 'rgb');

if strcmp(colourspace, 'hsv')
    imshow(uint8(frame * 255));
else
    imshow(uint8(frame));
end
%}