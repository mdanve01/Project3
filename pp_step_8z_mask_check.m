clear all

subs = [301 304 306 309 310 312 313 316 318 319 320 322 323 324 326 328 330 331 333 334 336 340 341 342 401 406 407 410 411 412 413 414 416 418 420 422 423 424 425 426 427 428 429 430 431 432 433 434];

% work through subjects to check the number of voxels in their mask
clear n
for n = 1:length(subs);
    clear sub
    clear sub_text
    sub = subs(n);
    sub_text = num2str(sub);
    cd(strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',sub_text,'/output/1st_level'));
    clear SPM
    load('SPM.mat');
    % set the corrcoef and clear the 1s from the diagonal
    clear corco
    corco = corrcoef(SPM.xX.X);
    clear m
    for m = 1:length(corco(:,1));
        corco(m,m) = 0;
    end
    % find the maximum correlation relating to my 4 conditions of interest,
    % excluding head motion
    list(n,7) = max(max(abs(corco(1:12,1:36))));
    % and now look at correlations with head motion
    list(n,8) = max(max(abs(corco([1:3 7:9],37:42))));
    % and finally correlations specifically between parametric X regressors
    % and head motion)
    list(n,9) = max(max(abs(corco(4:6,37:42))));
    list(n,10) = max(max(abs(corco(10:12,37:42))));
    
    % load the mask
    mask.(strcat('sub',sub_text)) = niftiread('mask.nii');
    % save sub num
    list(n,1) = sub;
    % save the number of voxels in the mask
    list(n,2) = length(find(mask.(strcat('sub',sub_text)) > 0));
end



% create a group mask
mask.group = mask.sub301;
clear n
for n = 2:length(subs);
    clear sub
    clear sub_text
    sub = subs(n);
    sub_text = num2str(sub);
    % add 1 to the coordinate for each subject with signal
    % there
    mask.group = mask.group + mask.(strcat('sub',sub_text));
end



% set this to binary, based upon the mode
% start with a fake mask built of zeros
mask.group2 = double(mask.sub301);
mask.group2(:,:,:) = 0;
mask.group = double(mask.group);
% then divide the total number of parrticipant who have signal at a
% coordinate by the total umber of participants in the sample. If the
% result is 0.5 (50%) or higher thens et this to 1, if not it is left at
% zero
mask.group = mask.group ./ length(subs);
mask.group2(find(mask.group >= 0.5)) = 1;


% now look at each participant and see how many voxels within their mask do
% not match the group mask
clear n
for n = 1:length(subs);
    clear sub
    clear sub_text
    sub = subs(n);
    sub_text = num2str(sub);
    list(n,4) = length(find(mask.(strcat('sub',sub_text)) ~= mask.group2));
end



% calculate z scores
clear n
for n = 1:length(list(:,1));
    list(n,3) = (list(n,2) - mean(list(:,2))) ./ std(list(:,2));
    list(n,5) = (list(n,4) - mean(list(:,4))) ./ std(list(:,4));
end
% look at max absolute z scores
list(length(list(:,1)) + 1, 3) = max(abs(list(:,3)));
list(length(list(:,1)), 5) = max(abs(list(:,5)));


cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/quality_control');
save list list
niftiwrite(mask.group2, 'mask_group.nii');
save mask mask
