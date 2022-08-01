% enter the name of the matlab script below, followed by (subject_number)
function step_7_normalise(subject_number);% List of open inputs

    % set path
    addpath /usr/local/apps/psycapps/spm/spm12-r7487

    jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/script/step_7_normalise_job.m'};
    jobs = repmat(jobfile, 1, 1);
    inputs = cell(2, 1);

    % create the paths
    deform = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject_number,'/anat/y_rc1rsRH-0005-00001-000176-01_Template.nii');
    epi = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject_number,'/func/ufRH_',subject_number,'_EMAR.nii');
    
    inputs{1, 1} = {deform}; % Write Normalised: Deformation field - cfg_files
    inputs{2, 1} = {epi}; % Write Normalised: Images - cfg_files
    
    spm('defaults', 'FMRI');
    spm_jobman('run', jobs, inputs{:});
    
end