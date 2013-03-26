% Encode
% ======

clear all;
close all;
clc;
clf;

%@@ Input video
carrier_video_filename = 'input\bunny.mp4';
cd('C:\Users\Muffin\Documents\GitHub\Steganography');

%@@ Output video, format and compression
profile_type = 3;

switch profile_type
    case 1
        profile = 'Motion JPEG AVI';
        output_video_filename = 'output\bunny_dct_MJAVI.avi';
    case 2
        profile = 'Uncompressed AVI';
        output_video_filename = 'output\bunny_dct_UnAVI.avi';
    case 3
        profile = 'Motion JPEG 2000';
        output_video_filename = 'output\bunny_dct_MJ2k.mj2';
    otherwise
        fprintf('Invalid profile_type\n');
        break;
end;

%@@ Message string to encode into carrier video
secret_msg_str = '0123456789__________0123456789----------';%'Test post; please ignore!';

%@@ Frames to use from the video
frame_start = 0;
frame_max = 5;

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Persistence the steg encoding (higher = more persistent, more visible)
persistence = 100;

%@@ Frequency coefficients
frequency_coefficients = [3 6; 5 2];

secret_msg_bin = str2bin(secret_msg_str);
vin = VideoReader(carrier_video_filename);
vout = VideoWriter(output_video_filename, profile);
frame_count = min(vin.NumberOfFrames, frame_max);
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

vprocess(1:frame_count) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

for num = 1:frame_count
    fprintf('Processing frame %d of %d\n', num, frame_count);
    frame = read(vin, frame_start + num);
    framec = frame(:,:,channel);
    
    [framec, ~, ~] = steg_dct_encode(secret_msg_bin, framec, frequency_coefficients, persistence);    
    
    frame(:,:,channel) = framec;
    vprocess(num).cdata = frame;
end;

% Display video
%implay(vprocess);

% Write video to file
open(vout);
writeVideo(vout, vprocess);
close(vout);
fprintf('Video written\n');
%%

% Decode
% ======

%@@ Frames to use from the video
frame_start = 0;
frame_max = 5;

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Frequency coefficients
frequency_coefficients = [3 6; 5 2];

vin = VideoReader(output_video_filename);
frame_count = min(vin.NumberOfFrames, frame_max);

for num = 1:frame_count
    frame = read(vin, frame_start + num);
    framec = frame(:,:,channel);

    [retrieved_msg_bin] = steg_dct_decode(framec, frequency_coefficients);
    retrieved_msg_str = bin2str(retrieved_msg_bin);
    
    fprintf('Frame %d message: %s\n', num, retrieved_msg_str);
end;

imshow(frame);