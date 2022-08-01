clear all

try 
    mask = importdata('mask.mat');
catch
    % create a mask of the appropriate size
    mask(1:91,1:109,1:91) = 0;
end

% go down in x (left), then step down in y (posterior), and work along z
% (up/down)
% left to right
x_orig = [72:75];
% ant to pos from 54
y_orig = [73:75];
% sup to inf
z_orig = [31]
% set the x(L-R), y(front-back), and z(top to bottom) coordiantes
% x needs to be flipped and adjusted by 1
x = abs(x_orig - 91);
% y and z need to be increased by 1
y = y_orig + 1;
z = z_orig + 1;

if max(max(max(mask))) > 0;
    load('mask.mat');
end

% add a 1 to this coordinate
mask(x,y,z) = 0;

% save the mask
save mask mask;

% THIS WAY I CAN SAVE COORDIANTE BY COORDINATE TO DETERMINE INCLUSION ZONES
% OF MY MASK.

% once this is done it needs to be saved as a nifti file, xyz resized to 2,
% then adjust 'forward' by -18, and 'up' by 18 (so should read 46,64,37).
% Then this matches the single subject canonical
niftiwrite(mask,'mask.nii');
