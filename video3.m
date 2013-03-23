%% ~~~ Embed ~~~ %%
clear all;
close all;
clc;

message = 'Test post; please ignore!';

frameStart = 200;
frameMax = 5;
fileNameIn = 'videos/bunny_source.mp4';
fileNameOut = 'videos/bunny_stego.avi';
secretIn = str2bin(message);
%fileNameSecret = 'video_secret2.png';
%bits = 4;

vin = VideoReader(fileNameIn);
vout = VideoWriter(fileNameOut);
%isecret = rgb2gray(imread(fileNameSecret));

frameCount = min(vin.NumberOfFrames, frameMax);
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

vprocess(1:frameCount) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

% ---=== ZK ===---
variance_threshold = 1; % Higher = more blocks used
minimum_distance_encode = 100; % Higher = more robust; more visible

for num = 1:frameCount
    frame = read(vin, frameStart + num);
    b = frame(:,:,3);
    
    % Hide data
    %b = steg_hide_lsb(b, isecret, bits);
    frequency_coefficients = [4 6; 5 2; 6 5];%[3 1; 1 2; 2 3];
    %///[b bits_written bits_unused] = steg_encode_dct(secretIn, b, frequency_coefficients, 500);
    [b bits_written bits_unused invalid_blocks_encode debug_invalid_encode] = steg_encode_zk(secretIn, b, frequency_coefficients, variance_threshold, minimum_distance_encode);
    
    
    frame(:,:,3) = b;
    vprocess(num).cdata = frame;
end;

% Display video
implay(vprocess);

% Write video to file
open(vout);
writeVideo(vout, vprocess);
close(vout);

%% ~~~ Extract ~~~ %%
clear all;
close all;
clc;

message = 'Test post; please ignore!';

frameStart = 0;
frameMax = 5;
fileNameIn = 'videos/bunny_stego.avi';

vin = VideoReader(fileNameIn);

frameCount = min(vin.NumberOfFrames, frameMax);
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

%%%vprocess(1:frameCount) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

% ---=== ZK ===---
decode_start = 0;
step_size = 1;
decode_end = 30; % Should be about minimum_distance_encode from last part
minimum_distance_decode = 0; % Gets looped through


best_minimum_distance_decode = 0;
best_iteration_similarity = 0;
best_iteration_chars_match = 0;

for minimum_distance_decode = decode_start:step_size:decode_end
    iteration_similarity = 0;
    iteration_chars_match = 0;
    iteration_chars_diff = 0;
    
    for num = 1:frameCount
        frame = read(vin, frameStart + num);
        b = frame(:,:,3);

        frequency_coefficients = [4 6; 5 2; 6 5];%[3 1; 1 2; 2 3];

        [messageOutBin invalid_blocks_decode debug_invalid_decode] = steg_decode_zk(b, frequency_coefficients, minimum_distance_decode);
        messageOut = bin2str(messageOutBin);
        
        [frame_similarity chars_match chars_diff] = string_similarity(message, messageOut, length(message));
        iteration_similarity = iteration_similarity + frame_similarity;
        iteration_chars_match = iteration_chars_match + chars_match;
        iteration_chars_diff = iteration_chars_diff + chars_diff;
        %fprintf('Frame %d, match %d, diff %d, message: "%s"\n', num, chars_match, chars_diff, messageOut);
    end;
    iteration_similarity = round(iteration_similarity / frameCount);
    
    if (iteration_chars_match > best_iteration_chars_match)
        best_iteration_chars_match = iteration_chars_match;
        best_iteration_similarity = iteration_similarity;
        best_minimum_distance_decode = minimum_distance_decode;
    end
    
    fprintf('[minimum_distance_decode=%d] [similarity=%d%%] [ratio=%d:%d]\n', minimum_distance_decode, iteration_similarity, iteration_chars_match, iteration_chars_diff);
end;
fprintf('Test finished. Best minimum_distance_decode is %d with a similarity of %d\n', best_minimum_distance_decode, best_iteration_similarity);