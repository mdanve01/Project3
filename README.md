# Project3
aging study of cognition

Study 3 Directory

__________________________________________________________________________________


E:/Study_3/create_run

Fourth_iteration

This contains two scripts, ‘create_run’ and ‘generate_control’. These were run sequentially to create a set of timings, then generate a set of control events. Outputs were saved in the files contained within.

__________________________________________________________________________________


E:/Study_3/eye_movements_and_rules

Individual data

All individuals are saved in folders based on their subject number (e.g. sub-301) within the folder Study_3 > eye_movements_and_rules > data. The general rule is numbers 301-399 are elderly, 401-499 are young. There is also a folder Study_3 > eye_movements_and_rules > removals where the participants not included in the analysis are kept.

These folders contain the following sub folders:

•	anat – the anatomical images (prefix sRH), segmented images (prefix c) and segmented dartel images (prefix rc). Also creation of the shoot normalisation template saved 3 files prefixed with j_rc, v_rc and y_rc. In participant 301 the shoot templates were saved.

•	DICOM – the original DICOM images.

•	fmap – field map images with two subfolders:

1.	phase – prefix sRH.

2.	magnitude – two images prefixed sRH.

3.	The voxel displacement map prefixed vdm5.

•	func – the functional images, originals (prefix fRH), unwarped (prefix ufRH), and smoothed/normalised using shoot (prefix swufRH). There is also a design.mat file containing all onset times of events and event types (see below).

•	Output – this contains a folder called 1st_level pertaining to the 1st level analysis, containing beta, con and SPM files.

•	quality_control – contains a quality control script and its output. Within the output there is a ‘temp’ and ‘spat’ directory for temporal and spatial measures of variation, and within each of these there is a ‘shift’ directory which looks at change from one scan or slice to the next, and a ‘cov’ directory that looks at the coefficient of variation.

•	Scripts – contains the SPM scripts for importing the DICOM images, moving items into correct folders, applying 3D>4D/unwarping/realignment/coregistration/segmentation, QA, and the first level analysis (this was a legacy script not used in the final analysis). These are in the main scripts folder too, but each was saved within individual files.

The design.mat file which contains all the trial data for each participant has the following structure. Within the files there is always a column of numbers relating to the onset of that event in seconds. For all cue events there is a second column with the parametrically modulated weighting applied. Subfolders relate to:

•	Num = participant number

•	Cue_cor_X = correct trials

•	Cue_cor_X_22 = correct trials not preceded by an error trial

•	Cue_cor_C = control trials

•	incorCue_missAll = incorrect cue events with all missed events (including cue, target and feedback).

•	incorCue12_missAll = as per above but also including correct cue events preceded by an incorrect trial.

•	Rest_cal_comb = an indication of the rest/calibration periods combined, column 1 is the onset time in seconds, column 2 is the duration in seconds. The five rows refer to the five rest periods.

•	Targ = remaining target events split into the three target locations.

•	Feed = remaining feedback events split into the three target locations.


Second Level Data

This is saved under ‘Study_3 > eye_movements_and_rules > data > 2nd_level’, within which there are three subfolders:

•	Baseline – this contains all beta and con images for the analysis which identified the mean baseline signal across participants, applied to convert plots to percentage signal change.

•	Non-Parametric – this contains the main analysis with gender as a covariate. There is also a subfolder ‘covariate_performance_analysis’ which adds ‘number_of_trials’ as a covariate (a metric of performance).

•	Parametric – this contains the parametrically modulated analysis with gender and IQ as a covariate. The same subfolder in included as per above.


Study_3 > eye_movements_and_rules > Behavioural_data

Basic design.mat files are saved here



Study_3 > eye_movements_and_rules > quality_control

Visual outputs for all quality control processes.



Study_3 > eye_movements_and_rules > ROI

All regional masks are kept here. The two used were ‘mask_smooth’ which was the frontal lobe, and ‘ROI_whole_cerebellum’ which is self explanatory.



Study_3 > eye_movements_and_rules > script

Within the subfolder ‘2nd_level’ there were four scripts:

1.	Covariate_script: this was the non-parametric analysis with gender and number-of-trials as covariates

2.	First_script: this was the non-parametric analysis with just gender as a covariate

3.	Para_covariate_script: this was the parametric analysis with gender, IQ and number-of-trials as covariates

4.	Para_first_script: this was the parametric analysis with gender and IQ as covariates

There was then a set of scripts for analysis, ordered numerically in steps to be self explanatory.

__________________________________________________________________________________


E:/Study_3/SPSS

This contains an excel results file, as well as SPSS files pertaining to each of the analyses in the paper.



L:/Study_3/participants

There are two subfolders, elderly and young. These contain each individual participant’s data under their numerical code (e.g. 401). 

•	RT_RESULTS – this is the experiment builder output file

•	Data_301.s2rx/smrx – this is the spike file with onset/offset times

Under the subfolder Test_301 there is a Test_301.edf file – this is the dataviewer file.



