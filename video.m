%% Initial variables
clear all; close all; clc;
startframe = 200;
maxframes = 50;
fin = 'videos/bunny_source.mp4';
isecret = 'video_secret2.png';
fout = 'videos/big_buck_bunny_edge_detect.avi';
bits = 6;

%% Hiding in video

% Load video
vin = VideoReader(fin);
frames = min(vin.NumberOfFrames,maxframes);
fps = vin.FrameRate;
height = vin.Height;
width = vin.Width;

% Load image
secret = rgb2gray(imread(isecret));

% Output movie structure
vout(1:frames) = struct('cdata', zeros(height,width,3,'uint8'),'colormap',[]);

for k = 1 : frames
    fi = read(vin, startframe+k);

    r = fi(:,:,1);
    g = fi(:,:,2);
    b = fi(:,:,3);
    
    % Frame is now split into three channels
    %r = im2uint8(edge(r,'log',0,1.0)*255);
    %g = im2uint8(edge(g,'log',0,1.0)*255);
    %b = im2uint8(edge(b,'log',0,1.0)*255);
    
    %r = steg_hide_lsb(r, secret, bits);
    %g = steg_hide_lsb(g, secret, bits);
    b = steg_hide_lsb(b, secret, bits);
    
    %b = steg_hide_lsb(b,im2uint8(edge(r,'log',0,1.0)*255),bits);
    
    fo(:,:,1) = r;
    fo(:,:,2) = g;
    fo(:,:,3) = b;
    vout(k).cdata = fo;
end

hf = figure;
set(hf, 'position', [300 300 width height])
movie(hf, vout, 1, fps);



%% Retrieve from video

vsteg = vout;%VideoReader(fout);

%{
frames = min(vsteg.NumberOfFrames,maxframes);
fps = vsteg.FrameRate;
height = vsteg.Height;
width = vsteg.Width;
%}

% Output movie structure
vout(1:frames) = struct('cdata', zeros(height,width,3,'uint8'),'colormap',[]);

for k = 1 : 20
    fi = read(vout, startframe+k);


    b = fi(:,:,3);

    b = steg_extract_lsb(b,bits);
    imshow(b,[0 power(2,bits)-1]);
    
    %vout(k).cdata = fo;
end