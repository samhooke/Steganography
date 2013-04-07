% Encode
% ======

clear all;
close all;
clc;

%@@ Input video
carrier_video_filename = 'input\bunny.mp4';
cd('C:\Users\Muffin\Documents\GitHub\Steganography');

%@@ Output video, format and compression
profile_type = 6;

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
        break;
end;

output_video_filename_base = 'output\bunny_dct';
output_video_filename = [output_video_filename_base, ' ', output_video_profilename, output_video_ext];

%@@ Message string to encode into carrier video
secret_msg_str = '0123456789__________0123456789----------';

%@@ Frames to use from the video
frame_start = 0;
frame_max = 5;

%@@ Which colour channel to use (1=r, 2=g, 3=b)
channel = 3;

%@@ Which colour space to use ('rgb', 'hsv', 'ycbcr');
colourspace = 'hsv';

%@@ Persistence the steg encoding (higher = more persistent, more visible)
persistence = 40;

%@@ Frequency coefficients
frequency_coefficients = [3 6; 5 2];

secret_msg_bin = str2bin(secret_msg_str);
vin = VideoReader(carrier_video_filename);
vout = VideoWriter(output_video_filename, profile);
if (frame_max <= frame_start)
    frame_count = vin.NumberOfFrames - frame_start;
else
    frame_count = min(vin.NumberOfFrames - frame_start, frame_max);
end;
fps = vin.FrameRate;
width = vin.Width;
height = vin.Height;

vprocess(1:frame_count) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);

for num = 1:frame_count
    fprintf('Processing frame %d of %d\n', num, frame_count);
    frame = read(vin, frame_start + num);
    
    frame_before = frame(:,:,channel);

    if strcmp(colourspace, 'hsv')
        frame = rgb2hsv(frame);
    elseif strcmp(colourspace, 'ycbcr')
        frame = rgb2ycbcr(frame);
    end;
    
    if strcmp(colourspace, 'hsv')
        framec_max = 255;
        %alpha = -10;
        
        framec = frame(:,:,channel) * framec_max;
        
        %framec(framec < alpha) = alpha;
        %framec(framec > (framec_max - alpha)) = (framec_max - alpha);
    else
        framec = frame(:,:,channel);
    end;

    [framec, ~, ~] = steg_dct_encode(secret_msg_bin, framec, frequency_coefficients, persistence);    

    frame(:,:,channel) = framec;
    
    if strcmp(colourspace, 'hsv')
        frame = hsv2rgb(frame);
    elseif strcmp(colourspace, 'ycbcr')
        frame = ycbcr2rgb(frame);
    end;

    frame_after = frame(:,:,channel);
    
    frame = uint8(frame);
    
    vprocess(num).cdata = frame;
end;

implay(vprocess);

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
    
    if strcmp(colourspace, 'hsv')
        frame = rgb2hsv(frame);
    elseif strcmp(colourspace, 'ycbcr')
        frame = rgb2ycbcr(frame);
    end;
    
    framec = frame(:,:,channel);

    [retrieved_msg_bin] = steg_dct_decode(framec, frequency_coefficients);
    retrieved_msg_str = bin2str(retrieved_msg_bin);
    
    fprintf('Frame %d message: %s\n', num, retrieved_msg_str);
end;

if strcmp(colourspace, 'hsv')
    frame = hsv2rgb(frame);
elseif strcmp(colourspace, 'ycbcr')
    frame = ycbcr2rgb(frame);
end;

imshow(uint8(frame * 255));