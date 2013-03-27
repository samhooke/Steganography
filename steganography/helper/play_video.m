function play_video(filename, frame_start, frame_max)
% play_video Plays the supplied video
%   Supports playing a multitide of formats, such as Motion JPEG 2000.
%   Can play all or part of the video, starting from any frame.
% INPUTS
%   filename    - Full filename of video (e.g. 'C:\folder\video.mj2')
%   frame_start - Frame to start playing at (e.g. 0)
%   frame_max   - How many frames to play (Set as 0 to play until end)

[pathstr, name, ext] = fileparts(filename);
video_filename = [name, ext];
cd(pathstr);
vin = VideoReader(video_filename);

if (frame_max <= frame_start)
    frame_count = vin.NumberOfFrames - frame_start;
else
    frame_count = min(vin.NumberOfFrames - frame_start, frame_max);
end;

vplay(1:frame_count) = struct('cdata', zeros(vin.Height, vin.Width, 3, 'uint8'), 'colormap', []);

for num = 1:frame_count
    vplay(num).cdata = read(vin, frame_start + num);
end;

implay(vplay);

end

