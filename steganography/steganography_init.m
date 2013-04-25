function [dir_input, dir_output, dir_results] = steganography_init()
% steganography_init() Sets up Matlab workspace for steganography functions

% Ensure correct directory
cd(home_directory());

% Return input and output directories
dir_input = 'input\';
dir_output = 'output\';
dir_results = 'results\';

end

