function [dir_full, dir_success] = create_directory_unique(dir)
% create_directory_unique() Finds a unique directory name and creates it
%   e.g. Ask for directory called 'C:\folder', but it is taken, so the
%   function returns 'C:\folder_1'
% INPUTS
%   dir - Desired directory name e.g. 'C:\folder'
% OUTPUTS
%   dir_full    - Generated directory, which now eixsts
%   dir_success - False upon failure

dir_success = true;

dir_full = [dir, '\'];
test_num = 0;
while exist(dir_full, 'dir')
    dir_full = [dir, '_', sprintf('%d', test_num), '\'];
    test_num = test_num + 1;
    
    if test_num > 10000
        dir_success = false;
    end
end

if dir_success
    mkdir(dir_full);
else
    error('Could not create directory');
end

end

