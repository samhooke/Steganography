% Encode
% ======

clear all;
close all;
clc;
clf;

%@@ Input image and output location
carrier_video_filename = 'input\bunny.mp4';
output_video_filename = 'output\bunny_dct.avi';
cd('C:\Users\Muffin\Documents\GitHub\Steganography');

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

%@@ Whether the output video is compressed
use_compression = false;

secret_msg_bin = str2bin(secret_msg_str);
vin = VideoReader(carrier_video_filename);

if use_compression
    profile = 'Motion JPEG AVI';
else
    profile = 'Uncompressed AVI'; 
end;

vout = VideoWriter(output_video_filename, profile);
frame_count = min(vin.NumberOfFrames, frame_max);
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

vprocess(1:frame_count) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

for num = 1:frame_count
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

clear all;
close all;
clc;
clf;

%@@ Input image and output location
output_video_filename = 'output\bunny_dct.avi';
cd('C:\Users\Muffin\Documents\GitHub\Steganography');

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