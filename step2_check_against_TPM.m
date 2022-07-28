clear all
cd('F:/Experiment_3/design_2_base/mask/nifti_files');
mask = niftiread('mask.nii');
cd('F:/Experiment_3/design_2_base/mask/brains');
tpm = niftiread('TPM.nii');

for first = 1:length(tpm(:,1,1,1));
    for second = 1:length(tpm(1,:,1,1));
        for third = 1:length(tpm(1,1,:,1));
            if tpm(first,second,third,1) < 0.1;
                mask(ceil(first .* 0.75),ceil(second .* 0.75),ceil(third .* 0.75)) = 0;
            end
        end
    end
end
cd('F:/Experiment_3/design_2_base/mask/matlab_files');
save mask_trim
cd('F:/Experiment_3/design_2_base/mask/nifti_files');
niftiwrite(mask,'mask_trim.nii');