%% ~~~ Embed ~~~ %%
clear all;
close all;
clc;

frameStart = 200;
frameMax = 5;
fileNameIn = 'videos/bunny_source.mp4';
fileNameOut = 'videos/bunny_stego.avi';
secretIn = str2bin('Test post; please ignore!');
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
variance_threshold = 3; % Higher = more blocks used
minimum_distance_encode = 50; % Higher = more robust; more visible

for num = 1:frameCount
    frame = read(vin, frameStart + num);
    b = frame(:,:,3);
    
    % Hide data
    %b = steg_hide_lsb(b, isecret, bits);
    frequency_coefficients = [3 1; 1 2; 2 3];
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

frameStart = 0;
frameMax = 5;
fileNameIn = 'videos/bunny_stego.avi';
%%%fileNameOut = 'videos/bunny_extract.avi';
%%%bits = 4;

vin = VideoReader(fileNameIn);
%%%vout = VideoWriter(fileNameOut);

frameCount = min(vin.NumberOfFrames, frameMax);
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

%%%vprocess(1:frameCount) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

% ---=== ZK ===---
minimum_distance_decode = 40;

for num = 1:frameCount
    frame = read(vin, frameStart + num);
    b = frame(:,:,3);
    
    % Extract hidden data
    %b = steg_extract_lsb(b, bits);
    
    %%%imshow(b, [0 power(2, bits) - 1]);
    frequency_coefficients = [3 1; 1 2; 2 3];
    %///[messageOut] = bin2str(steg_decode_dct(b, frequency_coefficients));
    [messageOut invalid_blocks_decode debug_invalid_decode] = steg_decode_zk(b, frequency_coefficients, minimum_distance_decode);
    fprintf('Frame %d, message: "%s"\n', num, bin2str(messageOut));
    
    %%%frame(:,:,1) = b;
    %%%frame(:,:,2) = b;
    %%%frame(:,:,3) = b;
    %%%vprocess(num).cdata = frame;
end;

% Display video
%%%implay(vprocess);

% Write video to file
%%%open(vout);
%%%writeVideo(vout, vprocess);
%%%close(vout);