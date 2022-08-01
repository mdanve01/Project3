% enter the name of the matlab script below, followed by (subject_number)
function step_8_first_level(subject_number);

    % set path
    addpath /usr/local/apps/psycapps/spm/spm12-r7487

    jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/script/step_8_first_level_job.m'};
    jobs = repmat(jobfile, 1, 1);
    inputs = cell(16, 1);

    path = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject_number,'/func');
    cd(path);

    % create the paths
    direct = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject_number,'/output/1st_level');
    epi = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject_number,'/func/swufRH_',subject_number,'_EMAR.nii');
    regs = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject_number,'/func/rp_fRH_',subject_number,'_EMAR.txt'); % adds ,: to the end of the path
    design = importdata('design.mat');

    inputs{1, 1} = {direct}; % load the directory path
    inputs{2, 1} = {epi}; % fMRI model specification: Scans - cfg_files
    inputs{3, 1} = design.cue_cor_X_22(:,1); % fMRI model specification: Onsets - cfg_entry
    inputs{4, 1} = design.cue_cor_X_22(:,2); % fMRI model specification: Values - cfg_entry
    inputs{5, 1} = design.cue_cor_C(:,1); % fMRI model specification: Onsets - cfg_entry
    inputs{6, 1} = design.cue_cor_C(:,2); % fMRI model specification: Values - cfg_entry
    inputs{7, 1} = design.incorCue12_missAll; % fMRI model specification: Onsets - cfg_entry
    inputs{8, 1} = design.targ.one; % fMRI model specification: Onsets - cfg_entry
    inputs{9, 1} = design.targ.two; % fMRI model specification: Onsets - cfg_entry
    inputs{10, 1} = design.targ.thr; % fMRI model specification: Onsets - cfg_entry
    inputs{11, 1} = design.feed.one; % fMRI model specification: Onsets - cfg_entry
    inputs{12, 1} = design.feed.two; % fMRI model specification: Onsets - cfg_entry
    inputs{13, 1} = design.feed.thr; % fMRI model specification: Onsets - cfg_entry
    inputs{14, 1} = design.rest_cal_comb(:,1); % fMRI model specification: Onsets - cfg_entry
    inputs{15, 1} = design.rest_cal_comb(:,2); % fMRI model specification: Durations - cfg_entry
    inputs{16, 1} = {regs}; % fMRI model specification: Multiple regressors - cfg_files

    spm('defaults', 'FMRI');
    spm_jobman('run', jobs, inputs{:});
end
