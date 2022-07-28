clear all
% cd to the location and load the mask
cd('F:/Experiment_3/design_2_base/mask/matlab_files');
load('mask_trim.mat');
% create a new mask of zeros
new_mask = mask;
new_mask(:,:,:) = 0;

% set a threshold above which we give a 1
thresh = 0.15

for f = 2:length(mask(:,1,1)) - 1;
    for s = 2:length(mask(1,:,1)) - 1;
        for t = 2:length(mask(1,1,:)) - 1;
            % now look at each voxel and determine an average of it and all
            % those surrounding it in 3D space
            new_mask(f,s,t) = mean(mean(mean(mask(f-1:f+1,s-1:s+1,t-1:t+1))));
            if new_mask(f,s,t) > thresh;
                new_mask(f,s,t) = 1;
            else
                new_mask(f,s,t) = 0;
            end
        end
    end
end

cd('F:/Experiment_3/design_2_base/mask/matlab_files');
save mask_smooth new_mask
cd('F:/Experiment_3/design_2_base/mask/nifti_files');
niftiwrite(new_mask,'mask_smooth.nii');