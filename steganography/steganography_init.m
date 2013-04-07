function [dir_input, dir_output] = steganography_init()
% steganography_init() Sets up Matlab workspace for steganography functions

% Get rid of all open figures
close all;

% Ensure correct directory
cd(home_directory());

% Return input and output directories
dir_input = 'input\';
dir_output = 'output\';

end

