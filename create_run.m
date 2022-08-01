% Has an update that saves the jitter in its original format so it can
% be checked, and when we jitter over 2 TRs it moves the 2nd TRs jitter so 
% samples sit in the middle of the samples in the first TR to keep it
% uniform. Jitters are then plotted so we can ensure they make sense.

% does not check for repeated trial types, but does ensure there are an even
% number of trials within each block

clear all
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/create_run/fourth_iteration');

% generate a list of equidistant events for each condition (x =
% experimental, c = control). The number of experimental
% trials must be divisible by the number of rules, also the number of
% control trials must be divisible by the number of cues, the number of
% targets and the number of blocks
data.numtri_x = 48;
data.numtri_c = 24;

% ensure this matches the create_timings_exp.m file
data.tot_num_trials = data.numtri_x + data.numtri_c;
data.tot_num_blocks = 6;

% set length of events
data.cue_spec = 250;
data.targ_spec = 1250;
data.feed_spec = 250;

% set correlation p value threshold (nothing should be below this, set this to a NS .45 as there are 9 correlations) and r value
% threshold (nothing should be above this, set this to .10 as that is a small effect)
data.p_thresh = 0.90;
data.r_thresh = 0.05;

% set a minimum ISI between any two events within a trial
data.ISI_thresh = 400;

% set the number of cue variants
data.num_cues = 4;

% set the number of targets
data.num_targets = 3;

% set tr
data.tr = 2000;

% set trial length in seconds
data.trilen = 18;

% set start times
data.cue_start = 0;
data.targ_start = 6000;
data.feed_start = 12000;

% set the number of TRs the cue stimuli are jittered over
data.num_tr.cue = 3;
data.num_tr.targ = 3;
data.num_tr.feed = 3;

% set the jitter reduction, so if is a 2000ms TR but want a jitter over
% 1750ms, then set to 250.
data.jitter.cue = 250;
data.jitter.targ = 1250;
data.jitter.feed = 1000;


% CHECK DIVISIBILITY %
data.checkx = (data.numtri_x ./ data.tot_num_blocks) ./ data.num_cues;
data.checkc = (data.numtri_c ./ data.tot_num_blocks) ./ data.num_cues;
data.check_targx = data.numtri_x ./ data.num_targets;
data.check_targc = data.numtri_c ./ data.num_targets;
% I then use mod to establish if the modulo of the number is zero, if it is
% then it must be an integer, which I need
if mod(data.checkx,1) ~= 0 | mod(data.checkc,1) ~= 0 | mod(data.check_targx,1) ~= 0 | mod(data.check_targc,1) ~= 0;
    "NOT DIVISIBLE!"
    else
    "DIVISIBLE, CRACK ON"
end

% set the number of regressors in the final design matri
data.num_regressors = 6;


%%%% EXPERIMENTAL %%%%
% prep the jitter. Each is jittered over 1750ms, but this can vary
clear n
time.jump_cuex = ((data.tr .* data.num_tr.cue) - data.jitter.cue ) ./ data.numtri_x;
time.jump_targx = ((data.tr .* data.num_tr.targ) - data.jitter.targ) ./ data.numtri_x;
time.jump_feedx = ((data.tr .* data.num_tr.feed) - data.jitter.feed) ./ data.numtri_x;

% loop through and create timings
for n = 1:data.numtri_x;
    time.cue1_x(n,2) = (time.jump_cuex .* n) + data.cue_start;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.cue == 2;
    clear a
    a = (time.cue1_x(1,2) ./ data.num_tr.cue) - (time.cue1_x(find(time.cue1_x(:,2) > data.tr,1),2) - data.tr);
    time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):length(time.cue1_x(:,1)),2) = time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):length(time.cue1_x(:,1)),2) + a;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.cue == 3;
    clear a
    clear b
    a = (time.cue1_x(1,2) ./ data.num_tr.cue) - (time.cue1_x(find(time.cue1_x(:,2) > data.tr,1),2) - data.tr);
    b = ((time.cue1_x(1,2) ./ data.num_tr.cue) .* 2) - (time.cue1_x(find(time.cue1_x(:,2) > (data.tr .* 2),1),2) - (data.tr .* 2));
    time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):find(time.cue1_x(:,2) > (data.tr .* 2)) - 1,2) = time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):find(time.cue1_x(:,2) > (data.tr .* 2)) - 1,2) + a;
    time.cue1_x(find(time.cue1_x(:,2) > (data.tr .* 2),1):length(time.cue1_x(:,2)),2) = time.cue1_x(find(time.cue1_x(:,2) > (data.tr .* 2),1):length(time.cue1_x(:,2)),2) + (a .* 2);   
end

% now add the attributes:
% column 2 = cue timing
% column 3 = target timing
% column 5 = cue type
% column 7 = experimental condition (1 = x, 2 = c)
time.cue1_x(:,5) = 1;
clear n
for n = 1:data.numtri_x ./ data.num_cues;
    clear y
    y = n .* data.num_cues;
    time.cue1_x(y,5) = data.num_cues;
    if data.num_cues > 2;
        clear x
        for x = 1:data.num_cues - 2;
            time.cue1_x(y-x,5) = data.num_cues - x;
        end
    end
end
time.cue1_x(:,7) = 1;
% under timing save the original jitter so it can be checked
timing.origcue1_x = time.cue1_x;

% create times for targets
clear n
for n = 1:data.numtri_x;
    time.targ_x(n,:) = (time.jump_targx .* n) + data.targ_start;
end
% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.targ == 2;
    clear a
    a = ((time.targ_x(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
    time.targ_x(find(time.targ_x(:,1) > data.tr,1):length(time.targ_x(:,1)),1) = time.targ_x(find(time.targ_x(:,1) > data.tr,1):length(time.targ_x(:,1)),1) + a;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.targ == 3;
    clear a
    clear b
    a = ((time.targ_x(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
    b = (((time.targ_x(1,1) - data.targ_start) ./ data.num_tr.targ) .* 2) - (time.targ_x(find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1),1) - ((data.tr .* 2) + data.targ_start));
    time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1):find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1,1) = time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1):find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1) + a;
    time.targ_x(find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start ),1):length(time.targ_x(:,1)),1) = time.targ_x(find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1):length(time.targ_x(:,1)),1) + (a .* 2);   
end
timing.origtarg_x = time.targ_x;

% create times for feedback
clear n
for n = 1:data.numtri_x;
    time.feed_x(n,:) = (time.jump_feedx .* n) + data.feed_start;
end
% if multiple TRs being jittered over ensure sampling is good
% if multiple TRs being jittered over ensure sampling is good
% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.feed == 2;
    clear a
    a = ((time.feed_x(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
    time.feed_x(find(time.feed_x(:,1) > data.tr,1):length(time.feed_x(:,1)),1) = time.feed_x(find(time.feed_x(:,1) > data.tr,1):length(time.feed_x(:,1)),1) + a;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.feed == 3;
    clear a
    clear b
    a = ((time.feed_x(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
    b = (((time.feed_x(1,1) - data.feed_start) ./ data.num_tr.feed) .* 2) - (time.feed_x(find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1),1) - ((data.tr .* 2) + data.feed_start));
    time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1):find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1,1) = time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1):find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1) + a;
    time.feed_x(find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start ),1):length(time.feed_x(:,1)),1) = time.feed_x(find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1):length(time.feed_x(:,1)),1) + (a .* 2);   
end
timing.origfeed_x = time.feed_x;


% randomise
time.cue1_x(:,1) = rand(1,data.numtri_x);
time.cue1_x = sortrows(time.cue1_x,1);
time.targ_x(:,2) = rand(1,data.numtri_x);
time.targ_x = sortrows(time.targ_x,2);
time.feed_x(:,2) = rand(1,data.numtri_x);
time.feed_x = sortrows(time.feed_x,2);
clear RHO1
clear PVAL1
clear RHO2
clear PVAL2
clear RHO3
clear PVAL3
[RHO1,PVAL1] = corr(time.cue1_x(:,2),time.targ_x(:,1));
[RHO2,PVAL2] = corr(time.cue1_x(:,2),time.feed_x(:,1));
[RHO3,PVAL3] = corr(time.targ_x(:,1),time.feed_x(:,1));
time.r.x = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
time.p.x = max([PVAL1 PVAL2 PVAL3]);

% check for events that sit right next to each other
time.ISIx(1) = min(time.targ_x(:,1) - (time.cue1_x(:,2) + data.cue_spec));
time.ISIx(2) = min(time.feed_x(:,1) - (time.targ_x(:,1) + data.targ_spec));
time.ISIx(3) = min(time.ISIx(1:2));
    
% loops through until the cue and target onset times are maximally
% uncorrelated
while time.r.x > data.r_thresh | time.p.x < data.p_thresh | time.ISIx(3) < data.ISI_thresh;
    % randomise
    time.cue1_x(:,1) = rand(1,data.numtri_x);
    time.cue1_x = sortrows(time.cue1_x,1);
    time.targ_x(:,2) = rand(1,data.numtri_x);
    time.targ_x = sortrows(time.targ_x,2);
    time.feed_x(:,2) = rand(1,data.numtri_x);
    time.feed_x = sortrows(time.feed_x,2);
    clear RHO1
    clear PVAL1
    clear RHO2
    clear PVAL2
    clear RHO3
    clear PVAL3
    [RHO1,PVAL1] = corr(time.cue1_x(:,2),time.targ_x(:,1));
    [RHO2,PVAL2] = corr(time.cue1_x(:,2),time.feed_x(:,1));
    [RHO3,PVAL3] = corr(time.targ_x(:,1),time.feed_x(:,1));
    time.r.x = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
    time.p.x = max([PVAL1 PVAL2 PVAL3]);

    % check for events that sit right next to each other
    time.ISIx(1) = min(time.targ_x(:,1) - (time.cue1_x(:,2) + data.cue_spec));
    time.ISIx(2) = min(time.feed_x(:,1) - (time.targ_x(:,1) + data.targ_spec));
    time.ISIx(3) = min(time.ISIx(1:2));
end

% add target times to the main list
time.x = time.cue1_x;
time.x(:,1) = 0;
time.x(:,3) = time.targ_x(:,1);
time.x(:,4) = time.feed_x(:,1);

% create zero columns for later stacking
time.x(:,8:9) = 0;

"experimental correlations fixed"





%%%% CONTROL %%%%

% prep the jitter. Each is jittered over 1750ms, but this can vary
clear n
time.jump_cuec = ((data.tr .* data.num_tr.cue) - data.jitter.cue ) ./ data.numtri_c;
time.jump_targc = ((data.tr .* data.num_tr.targ) - data.jitter.targ) ./ data.numtri_c;
time.jump_feedc = ((data.tr .* data.num_tr.feed) - data.jitter.feed) ./ data.numtri_c;

% loop through and create timings
for n = 1:data.numtri_c;
    time.cue1_c(n,2) = (time.jump_cuec .* n) + data.cue_start;
end
% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.cue == 2;
    clear a
    a = (time.cue1_c(1,2) ./ data.num_tr.cue) - (time.cue1_c(find(time.cue1_c(:,2) > data.tr,1),2) - data.tr);
    time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):length(time.cue1_c(:,1)),2) = time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):length(time.cue1_c(:,1)),2) + a;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.cue == 3;
    clear a
    clear b
    a = (time.cue1_c(1,2) ./ data.num_tr.cue) - (time.cue1_c(find(time.cue1_c(:,2) > data.tr,1),2) - data.tr);
    b = ((time.cue1_c(1,2) ./ data.num_tr.cue) .* 2) - (time.cue1_c(find(time.cue1_c(:,2) > (data.tr .* 2),1),2) - (data.tr .* 2));
    time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):find(time.cue1_c(:,2) > (data.tr .* 2)) - 1,2) = time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):find(time.cue1_c(:,2) > (data.tr .* 2)) - 1,2) + a;
    time.cue1_c(find(time.cue1_c(:,2) > (data.tr .* 2),1):length(time.cue1_c(:,2)),2) = time.cue1_c(find(time.cue1_c(:,2) > (data.tr .* 2),1):length(time.cue1_c(:,2)),2) + (a .* 2);   
end

% now add the attributes:
% column 2 = cue timing
% column 3 = target timing
% column 5 = cue type
% column 7 = experimental condition (1 = x, 2 = c)
time.cue1_c(:,5) = 1;
clear n
for n = 1:data.numtri_c ./ data.num_cues;
    clear y
    y = n .* data.num_cues;
    time.cue1_c(y,5) = data.num_cues;
    if data.num_cues > 2;
        clear x
        for x = 1:data.num_cues - 2;
            time.cue1_c(y-x,5) = data.num_cues - x;
        end
    end
end
time.cue1_c(:,7) = 2;
% under timing save the original jitter so it can be checked
timing.origcue1_c = time.cue1_c;

% create times for targets
clear n
for n = 1:data.numtri_c;
    time.targ_c(n,:) = (time.jump_targc .* n) + data.targ_start;
end
% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.targ == 2;
    clear a
    a = ((time.targ_c(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
    time.targ_c(find(time.targ_c(:,1) > data.tr,1):length(time.targ_c(:,1)),1) = time.targ_c(find(time.targ_c(:,1) > data.tr,1):length(time.targ_c(:,1)),1) + a;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.targ == 3;
    clear a
    clear b
    a = ((time.targ_c(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
    b = (((time.targ_c(1,1) - data.targ_start) ./ data.num_tr.targ) .* 2) - (time.targ_c(find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1),1) - ((data.tr .* 2) + data.targ_start));
    time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1):find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1,1) = time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1):find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1) + a;
    time.targ_c(find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start ),1):length(time.targ_c(:,1)),1) = time.targ_c(find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1):length(time.targ_c(:,1)),1) + (a .* 2);   
end
timing.origtarg_c = time.targ_c;

% create times for feedback
clear n
for n = 1:data.numtri_c;
    time.feed_c(n,:) = (time.jump_feedc .* n) + data.feed_start;
end
% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.feed == 2;
    clear a
    a = ((time.feed_c(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
    time.feed_c(find(time.feed_c(:,1) > data.tr,1):length(time.feed_c(:,1)),1) = time.feed_c(find(time.feed_c(:,1) > data.tr,1):length(time.feed_c(:,1)),1) + a;
end

% if multiple TRs being jittered over ensure sampling is good
if data.num_tr.feed == 3;
    clear a
    clear b
    a = ((time.feed_c(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
    b = (((time.feed_c(1,1) - data.feed_start) ./ data.num_tr.feed) .* 2) - (time.feed_c(find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1),1) - ((data.tr .* 2) + data.feed_start));
    time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1):find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1,1) = time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1):find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1) + a;
    time.feed_c(find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start ),1):length(time.feed_c(:,1)),1) = time.feed_c(find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1):length(time.feed_c(:,1)),1) + (a .* 2);   
end
timing.origfeed_c = time.feed_c;


% randomise
time.cue1_c(:,1) = rand(1,data.numtri_c);
time.cue1_c = sortrows(time.cue1_c,1);
time.targ_c(:,2) = rand(1,data.numtri_c);
time.targ_c = sortrows(time.targ_c,2);
time.feed_c(:,2) = rand(1,data.numtri_c);
time.feed_c = sortrows(time.feed_c,2);
clear RHO1
clear PVAL1
clear RHO2
clear PVAL2
clear RHO3
clear PVAL3
[RHO1,PVAL1] = corr(time.cue1_c(:,2),time.targ_c(:,1));
[RHO2,PVAL2] = corr(time.cue1_c(:,2),time.feed_c(:,1));
[RHO3,PVAL3] = corr(time.targ_c(:,1),time.feed_c(:,1));
time.r.c = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
time.p.c = max([PVAL1 PVAL2 PVAL3]);

% check for events that sit right next to each other
time.ISIc(1) = min(time.targ_c(:,1) - (time.cue1_c(:,2) + data.cue_spec));
time.ISIc(2) = min(time.feed_c(:,1) - (time.targ_c(:,1) + data.targ_spec));
time.ISIc(3) = min(time.ISIc(1:2));

% loops through until the cue and target onset times are maximally
% uncorrelated and ensuring ISI does not exceed the stated minimum
% threshold
while time.r.c > data.r_thresh | time.p.c < data.p_thresh | time.ISIc(3) < data.ISI_thresh;
    % randomise
    time.cue1_c(:,1) = rand(1,data.numtri_c);
    time.cue1_c = sortrows(time.cue1_c,1);
    time.targ_c(:,2) = rand(1,data.numtri_c);
    time.targ_c = sortrows(time.targ_c,2);
    time.feed_c(:,2) = rand(1,data.numtri_c);
    time.feed_c = sortrows(time.feed_c,2);
    clear RHO1
    clear PVAL1
    clear RHO2
    clear PVAL2
    clear RHO3
    clear PVAL3
    [RHO1,PVAL1] = corr(time.cue1_c(:,2),time.targ_c(:,1));
    [RHO2,PVAL2] = corr(time.cue1_c(:,2),time.feed_c(:,1));
    [RHO3,PVAL3] = corr(time.targ_c(:,1),time.feed_c(:,1));
    time.r.c = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
    time.p.c = max([PVAL1 PVAL2 PVAL3]);

    % check for events that sit right next to each other
    time.ISIc(1) = min(time.targ_c(:,1) - (time.cue1_c(:,2) + data.cue_spec));
    time.ISIc(2) = min(time.feed_c(:,1) - (time.targ_c(:,1) + data.targ_spec));
    time.ISIc(3) = min(time.ISIc(1:2));
end

% add target times to the main list
time.c = time.cue1_c;
time.c(:,1) = 0;
time.c(:,3) = time.targ_c(:,1);
time.c(:,4) = time.feed_c(:,1);

% create zero columns for later stacking
time.c(:,8:9) = 0;

"control correlations fixed"




% check the jitter
clear n
for n = 1:length(timing.origcue1_x(:,1));
    timing.jitter_cue1x(n,1) = 1;
    if timing.origcue1_x(n,2) < (data.tr + data.cue_start);
        timing.jitter_cue1x(n,2) = timing.origcue1_x(n,2);
    elseif timing.origcue1_x(n,2) > (data.tr + data.cue_start) & timing.origcue1_x(n,2) < ((data.tr .* 2) + data.cue_start);
        timing.jitter_cue1x(n,2) = timing.origcue1_x(n,2) - data.tr;
    elseif timing.origcue1_x(n,2) > ((data.tr .* 2) + data.cue_start);
        timing.jitter_cue1x(n,2) = timing.origcue1_x(n,2) - (data.tr .* 2);
    end
end
figure(1);
subplot(3,2,1);
scatter(timing.jitter_cue1x(:,2),timing.jitter_cue1x(:,1),'filled');
title('cue1x');

clear n
for n = 1:length(timing.origcue1_c(:,1));
    timing.jitter_cue1c(n,1) = 1;
    if timing.origcue1_c(n,2) < (data.tr + data.cue_start);
        timing.jitter_cue1c(n,2) = timing.origcue1_c(n,2);
    elseif timing.origcue1_c(n,2) > (data.tr + data.cue_start) & timing.origcue1_c(n,2) < ((data.tr .* 2) + data.cue_start);
        timing.jitter_cue1c(n,2) = timing.origcue1_c(n,2) - data.tr;
    elseif timing.origcue1_c(n,2) > ((data.tr .* 2) + data.cue_start);
        timing.jitter_cue1c(n,2) = timing.origcue1_c(n,2) - (data.tr .* 2);
    end
end
figure(1);
subplot(3,2,2);
scatter(timing.jitter_cue1c(:,2),timing.jitter_cue1c(:,1),'filled');
title('cue1c');

% check the jitter - targets
clear n
for n = 1:length(timing.origtarg_x(:,1));
    timing.jitter_targx(n,1) = 1;
    if timing.origtarg_x(n,1) < (data.tr + data.targ_start);
        timing.jitter_targx(n,2) = timing.origtarg_x(n,1) - data.targ_start;
    elseif timing.origtarg_x(n,1) > (data.tr + data.targ_start) & timing.origtarg_x(n,1) < ((data.tr .* 2) + data.targ_start);
        timing.jitter_targx(n,2) = timing.origtarg_x(n,1) - (data.tr + data.targ_start);
    elseif timing.origtarg_x(n,1) > ((data.tr .* 2) + data.targ_start);
        timing.jitter_targx(n,2) = timing.origtarg_x(n,1) - ((data.tr .* 2) + data.targ_start);
    end
end
figure(1);
subplot(3,2,3);
scatter(timing.jitter_targx(:,2),timing.jitter_targx(:,1),'filled');
title('targx');

clear n
for n = 1:length(timing.origtarg_c(:,1));
    timing.jitter_targc(n,1) = 1;
    if timing.origtarg_c(n,1) < (data.tr + data.targ_start);
        timing.jitter_targc(n,2) = timing.origtarg_c(n,1) - data.targ_start;
    elseif timing.origtarg_c(n,1) > (data.tr + data.targ_start) & timing.origtarg_c(n,1) < ((data.tr .* 2) + data.targ_start);
        timing.jitter_targc(n,2) = timing.origtarg_c(n,1) - (data.tr + data.targ_start);
    elseif timing.origtarg_c(n,1) > ((data.tr .* 2) + data.targ_start);
        timing.jitter_targc(n,2) = timing.origtarg_c(n,1) - ((data.tr .* 2) + data.targ_start);
    end
end
figure(1);
subplot(3,2,4);
scatter(timing.jitter_targc(:,2),timing.jitter_targc(:,1),'filled');
title('targc');

% check the jitter - feedback
clear n
for n = 1:length(timing.origfeed_x(:,1));
    timing.jitter_feedx(n,1) = 1;
    if timing.origfeed_x(n,1) < (data.tr + data.feed_start);
        timing.jitter_feedx(n,2) = timing.origfeed_x(n,1) - data.feed_start;
    elseif timing.origfeed_x(n,1) > (data.tr + data.feed_start) & timing.origfeed_x(n,1) < ((data.tr .* 2) + data.feed_start);
        timing.jitter_feedx(n,2) = timing.origfeed_x(n,1) - (data.tr + data.feed_start);
    elseif timing.origfeed_x(n,1) > ((data.tr .* 2) + data.feed_start);
        timing.jitter_feedx(n,2) = timing.origfeed_x(n,1) - ((data.tr .* 2) + data.feed_start);
    end
end
figure(1);
subplot(3,2,5);
scatter(timing.jitter_feedx(:,2),timing.jitter_feedx(:,1),'filled');
title('feedx');

clear n
for n = 1:length(timing.origfeed_c(:,1));
    timing.jitter_feedc(n,1) = 1;
    if timing.origfeed_c(n,1) < (data.tr + data.feed_start);
        timing.jitter_feedc(n,2) = timing.origfeed_c(n,1) - data.feed_start;
    elseif timing.origfeed_c(n,1) > (data.tr + data.feed_start) & timing.origfeed_c(n,1) < ((data.tr .* 2) + data.feed_start);
        timing.jitter_feedc(n,2) = timing.origfeed_c(n,1) - (data.tr + data.feed_start);
    elseif timing.origfeed_c(n,1) > ((data.tr .* 2) + data.feed_start);
        timing.jitter_feedc(n,2) = timing.origfeed_c(n,1) - ((data.tr .* 2) + data.feed_start);
    end
end
figure(1);
subplot(3,2,6);
scatter(timing.jitter_feedc(:,2),timing.jitter_feedc(:,1),'filled');
title('feedc');


% now I compile all the trials into their respective blocks
clear n

% first separate into each cue type for exp and control
for n = 1:data.num_cues;
    % find each set of experimental cue types sequentially
    clear my_field
    my_field = strcat('x_',num2str(n));
    block.(my_field) = time.x(find(time.x(:,5) == n),:);
    % do the same for the control cue types
    clear my_field
    my_field = strcat('c_',num2str(n));
    block.(my_field) = time.c(find(time.c(:,5) == n),:);
end

% then spread these equally over blocks
clear numx
clear numc
numx = (data.numtri_x ./ data.tot_num_blocks) ./ data.num_cues;
numc = (data.numtri_c ./ data.tot_num_blocks) ./ data.num_cues;
clear n
for n = 1:data.tot_num_blocks;
    clear a
    a = strcat('block_',num2str(n));
    clear m
    for m = 1:data.num_cues;
        clear b
        b = strcat('x_',num2str(m));
        block.(a)(((m - 1) .* numx) + 1:m .* numx,:) = block.(b)(((n - 1) .* numx) + 1: n .* numx,:);
    end
    clear m
    for m = 1:data.num_cues;
        % now add in the control trials
        clear b
        b = strcat('c_',num2str(m));
        block.(a)(length(block.(a)(:,1)) + 1:length(block.(a)(:,1)) + numc,:) = block.(b)(((n - 1) .* numc) + 1: n .* numc,:);
    end
    % set the block number in column 8
    block.(a)(:,8) = n;
end


% randomise the blocks
clear n
for n = 1:data.tot_num_blocks;
    clear a
    a = strcat('block_',num2str(n));
    clear b
    b = strcat('rand_',num2str(n));
    block.(a)(:,1) = rand(1,length(block.(a)(:,1)));
    block.(b) = sortrows(block.(a),1);
end


% now concatenate all the blocks into a single run
clear n
total.whole_run = block.rand_1
for n = 2:data.tot_num_blocks
    clear a
    a = strcat('rand_',num2str(n));
    total.whole_run(length(total.whole_run(:,1)) + 1:length(total.whole_run(:,1)) +...
    ((data.tot_num_trials ./ data.tot_num_blocks)),:) = block.(a);
end



% then make this run continuous and in seconds
% first set the respective trial length
clear n
for n = 1:length(total.whole_run(:,1));
    total.whole_run(n,9) = data.trilen .* 1000;
end
% then make these cumulative
clear n
for n = 2:length(total.whole_run(:,1));
    total.whole_run(n,9) = total.whole_run(n,9) + total.whole_run(n - 1,9);
end

% now make the trial times cumulative
clear n
total.run2(1,:) = total.whole_run(1,:);
for n = 2:length(total.whole_run(:,1));
    total.run2(n,:) = total.whole_run(n,:);
    total.run2(n,2:4) = total.run2(n,2:4) + total.run2(n-1,9);
end


% convert to seconds
total.run2(:,2:4) = total.run2(:,2:4) ./ 1000;

% need to consider conditions of interest
cond.x = total.run2(find(total.run2(:,7) == 1),:);
cond.c = total.run2(find(total.run2(:,7) == 2),:);


% create the regressors
cond.x_cue_cor = cond.x(:,2);
cond.x_tar_cor = cond.x(:,3);
cond.x_fee_cor = cond.x(:,4);
cond.c_cue_cor = cond.c(:,2);
cond.c_tar_cor = cond.c(:,3);
cond.c_fee_cor = cond.c(:,4);


% load the HRFc function
data.hrfc = importdata('HRFc.mat')';
% check how many cells per second
data.sec = length(data.hrfc) ./ 32.0125;
% calculate the length of the design matrix in cells
clear x
x = max(max(total.run2(:,3:4)));
clear y
y = ceil(x .* data.sec) + length(data.hrfc);

% create the faux design matrix
cond.design(1:y,1:data.num_regressors) = 0;

% loop through each variable and convolve with the HRF

% 1 = exp cue correct
% 2 = exp target correct
% 3 = exp feedback correct
% 4 = con cue all
% 5 = con target all
% 6 = con feedback all


% exp cue correct
clear n
for n = 1:length(cond.x_cue_cor(:,1));
    clear x
    x = ceil(cond.x_cue_cor(n,1) .* data.sec);
    cond.design(x:x+259,1) = cond.design(x:x+259,1) + data.hrfc;
end

% exp target correct
clear n
for n = 1:length(cond.x_tar_cor(:,1));
    clear x
    x = ceil(cond.x_tar_cor(n,1) .* data.sec);
    cond.design(x:x+259,2) = cond.design(x:x+259,2) + data.hrfc;
end

% exp feedback correct
clear n
for n = 1:length(cond.x_fee_cor(:,1));
    clear x
    x = ceil(cond.x_fee_cor(n,1) .* data.sec);
    cond.design(x:x+259,3) = cond.design(x:x+259,3) + data.hrfc;
end

% ctr cue correct
clear n
for n = 1:length(cond.c_cue_cor(:,1));
    clear x
    x = ceil(cond.c_cue_cor(n,1) .* data.sec);
    cond.design(x:x+259,4) = cond.design(x:x+259,4) + data.hrfc;
end

% ctr target correct
clear n
for n = 1:length(cond.c_tar_cor(:,1));
    clear x
    x = ceil(cond.c_tar_cor(n,1) .* data.sec);
    cond.design(x:x+259,5) = cond.design(x:x+259,5) + data.hrfc;
end

% ctr feedback correct
clear n
for n = 1:length(cond.c_fee_cor(:,1));
    clear x
    x = ceil(cond.c_fee_cor(n,1) .* data.sec);
    cond.design(x:x+259,6) = cond.design(x:x+259,6) + data.hrfc;
end


% create a correlation matrix
cond.correlate = corrcoef(cond.design);

% remove 1s
clear n
for n = 1:length(cond.correlate(:,1));
    cond.correlate(n,n) = 0;
end

clear max_j
cond.max_correlate = max(max(abs(cond.correlate)))
total.duration = max(max(total.run2(:,3:4))) ./ 60;



save block block
save cond cond
save data data
save time time
save timing timing
save total total








while cond.max_correlate > 0.1;

    clear all
    load('data.mat');

    %%%% EXPERIMENTAL %%%%
    % prep the jitter. Each is jittered over 1750ms, but this can vary
    clear n
    time.jump_cuex = ((data.tr .* data.num_tr.cue) - data.jitter.cue ) ./ data.numtri_x;
    time.jump_targx = ((data.tr .* data.num_tr.targ) - data.jitter.targ) ./ data.numtri_x;
    time.jump_feedx = ((data.tr .* data.num_tr.feed) - data.jitter.feed) ./ data.numtri_x;

    % loop through and create timings
    for n = 1:data.numtri_x;
        time.cue1_x(n,2) = (time.jump_cuex .* n) + data.cue_start;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.cue == 2;
        clear a
        a = (time.cue1_x(1,2) ./ data.num_tr.cue) - (time.cue1_x(find(time.cue1_x(:,2) > data.tr,1),2) - data.tr);
        time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):length(time.cue1_x(:,1)),2) = time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):length(time.cue1_x(:,1)),2) + a;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.cue == 3;
        clear a
        clear b
        a = (time.cue1_x(1,2) ./ data.num_tr.cue) - (time.cue1_x(find(time.cue1_x(:,2) > data.tr,1),2) - data.tr);
        b = ((time.cue1_x(1,2) ./ data.num_tr.cue) .* 2) - (time.cue1_x(find(time.cue1_x(:,2) > (data.tr .* 2),1),2) - (data.tr .* 2));
        time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):find(time.cue1_x(:,2) > (data.tr .* 2)) - 1,2) = time.cue1_x(find(time.cue1_x(:,2) > data.tr,1):find(time.cue1_x(:,2) > (data.tr .* 2)) - 1,2) + a;
        time.cue1_x(find(time.cue1_x(:,2) > (data.tr .* 2),1):length(time.cue1_x(:,2)),2) = time.cue1_x(find(time.cue1_x(:,2) > (data.tr .* 2),1):length(time.cue1_x(:,2)),2) + (a .* 2);   
    end

    % now add the attributes:
    % column 2 = cue timing
    % column 3 = target timing
    % column 5 = cue type
    % column 7 = experimental condition (1 = x, 2 = c)
    time.cue1_x(:,5) = 1;
    clear n
    for n = 1:data.numtri_x ./ data.num_cues;
        clear y
        y = n .* data.num_cues;
        time.cue1_x(y,5) = data.num_cues;
        if data.num_cues > 2;
            clear x
            for x = 1:data.num_cues - 2;
                time.cue1_x(y-x,5) = data.num_cues - x;
            end
        end
    end
    time.cue1_x(:,7) = 1;
    % under timing save the original jitter so it can be checked
    timing.origcue1_x = time.cue1_x;

    % create times for targets
    clear n
    for n = 1:data.numtri_x;
        time.targ_x(n,:) = (time.jump_targx .* n) + data.targ_start;
    end
    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.targ == 2;
        clear a
        a = ((time.targ_x(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
        time.targ_x(find(time.targ_x(:,1) > data.tr,1):length(time.targ_x(:,1)),1) = time.targ_x(find(time.targ_x(:,1) > data.tr,1):length(time.targ_x(:,1)),1) + a;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.targ == 3;
        clear a
        clear b
        a = ((time.targ_x(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
        b = (((time.targ_x(1,1) - data.targ_start) ./ data.num_tr.targ) .* 2) - (time.targ_x(find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1),1) - ((data.tr .* 2) + data.targ_start));
        time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1):find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1,1) = time.targ_x(find(time.targ_x(:,1) > (data.tr + data.targ_start),1):find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1) + a;
        time.targ_x(find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start ),1):length(time.targ_x(:,1)),1) = time.targ_x(find(time.targ_x(:,1) > ((data.tr .* 2) + data.targ_start),1):length(time.targ_x(:,1)),1) + (a .* 2);   
    end
    timing.origtarg_x = time.targ_x;

    % create times for feedback
    clear n
    for n = 1:data.numtri_x;
        time.feed_x(n,:) = (time.jump_feedx .* n) + data.feed_start;
    end
    % if multiple TRs being jittered over ensure sampling is good
    % if multiple TRs being jittered over ensure sampling is good
    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.feed == 2;
        clear a
        a = ((time.feed_x(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
        time.feed_x(find(time.feed_x(:,1) > data.tr,1):length(time.feed_x(:,1)),1) = time.feed_x(find(time.feed_x(:,1) > data.tr,1):length(time.feed_x(:,1)),1) + a;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.feed == 3;
        clear a
        clear b
        a = ((time.feed_x(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
        b = (((time.feed_x(1,1) - data.feed_start) ./ data.num_tr.feed) .* 2) - (time.feed_x(find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1),1) - ((data.tr .* 2) + data.feed_start));
        time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1):find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1,1) = time.feed_x(find(time.feed_x(:,1) > (data.tr + data.feed_start),1):find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1) + a;
        time.feed_x(find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start ),1):length(time.feed_x(:,1)),1) = time.feed_x(find(time.feed_x(:,1) > ((data.tr .* 2) + data.feed_start),1):length(time.feed_x(:,1)),1) + (a .* 2);   
    end
    timing.origfeed_x = time.feed_x;


    % randomise
    time.cue1_x(:,1) = rand(1,data.numtri_x);
    time.cue1_x = sortrows(time.cue1_x,1);
    time.targ_x(:,2) = rand(1,data.numtri_x);
    time.targ_x = sortrows(time.targ_x,2);
    time.feed_x(:,2) = rand(1,data.numtri_x);
    time.feed_x = sortrows(time.feed_x,2);
    clear RHO1
    clear PVAL1
    clear RHO2
    clear PVAL2
    clear RHO3
    clear PVAL3
    [RHO1,PVAL1] = corr(time.cue1_x(:,2),time.targ_x(:,1));
    [RHO2,PVAL2] = corr(time.cue1_x(:,2),time.feed_x(:,1));
    [RHO3,PVAL3] = corr(time.targ_x(:,1),time.feed_x(:,1));
    time.r.x = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
    time.p.x = max([PVAL1 PVAL2 PVAL3]);

    % check for events that sit right next to each other
    time.ISIx(1) = min(time.targ_x(:,1) - (time.cue1_x(:,2) + data.cue_spec));
    time.ISIx(2) = min(time.feed_x(:,1) - (time.targ_x(:,1) + data.targ_spec));
    time.ISIx(3) = min(time.ISIx(1:2));

    % loops through until the cue and target onset times are maximally
    % uncorrelated
    while time.r.x > data.r_thresh | time.p.x < data.p_thresh | time.ISIx(3) < data.ISI_thresh;
        % randomise
        time.cue1_x(:,1) = rand(1,data.numtri_x);
        time.cue1_x = sortrows(time.cue1_x,1);
        time.targ_x(:,2) = rand(1,data.numtri_x);
        time.targ_x = sortrows(time.targ_x,2);
        time.feed_x(:,2) = rand(1,data.numtri_x);
        time.feed_x = sortrows(time.feed_x,2);
        clear RHO1
        clear PVAL1
        clear RHO2
        clear PVAL2
        clear RHO3
        clear PVAL3
        [RHO1,PVAL1] = corr(time.cue1_x(:,2),time.targ_x(:,1));
        [RHO2,PVAL2] = corr(time.cue1_x(:,2),time.feed_x(:,1));
        [RHO3,PVAL3] = corr(time.targ_x(:,1),time.feed_x(:,1));
        time.r.x = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
        time.p.x = max([PVAL1 PVAL2 PVAL3]);

        % check for events that sit right next to each other
        time.ISIx(1) = min(time.targ_x(:,1) - (time.cue1_x(:,2) + data.cue_spec));
        time.ISIx(2) = min(time.feed_x(:,1) - (time.targ_x(:,1) + data.targ_spec));
        time.ISIx(3) = min(time.ISIx(1:2));
    end

    % add target times to the main list
    time.x = time.cue1_x;
    time.x(:,1) = 0;
    time.x(:,3) = time.targ_x(:,1);
    time.x(:,4) = time.feed_x(:,1);

    % create zero columns for later stacking
    time.x(:,8:9) = 0;

    "experimental correlations fixed"





    %%%% CONTROL %%%%

    % prep the jitter. Each is jittered over 1750ms, but this can vary
    clear n
    time.jump_cuec = ((data.tr .* data.num_tr.cue) - data.jitter.cue ) ./ data.numtri_c;
    time.jump_targc = ((data.tr .* data.num_tr.targ) - data.jitter.targ) ./ data.numtri_c;
    time.jump_feedc = ((data.tr .* data.num_tr.feed) - data.jitter.feed) ./ data.numtri_c;

    % loop through and create timings
    for n = 1:data.numtri_c;
        time.cue1_c(n,2) = (time.jump_cuec .* n) + data.cue_start;
    end
    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.cue == 2;
        clear a
        a = (time.cue1_c(1,2) ./ data.num_tr.cue) - (time.cue1_c(find(time.cue1_c(:,2) > data.tr,1),2) - data.tr);
        time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):length(time.cue1_c(:,1)),2) = time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):length(time.cue1_c(:,1)),2) + a;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.cue == 3;
        clear a
        clear b
        a = (time.cue1_c(1,2) ./ data.num_tr.cue) - (time.cue1_c(find(time.cue1_c(:,2) > data.tr,1),2) - data.tr);
        b = ((time.cue1_c(1,2) ./ data.num_tr.cue) .* 2) - (time.cue1_c(find(time.cue1_c(:,2) > (data.tr .* 2),1),2) - (data.tr .* 2));
        time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):find(time.cue1_c(:,2) > (data.tr .* 2)) - 1,2) = time.cue1_c(find(time.cue1_c(:,2) > data.tr,1):find(time.cue1_c(:,2) > (data.tr .* 2)) - 1,2) + a;
        time.cue1_c(find(time.cue1_c(:,2) > (data.tr .* 2),1):length(time.cue1_c(:,2)),2) = time.cue1_c(find(time.cue1_c(:,2) > (data.tr .* 2),1):length(time.cue1_c(:,2)),2) + (a .* 2);   
    end

    % now add the attributes:
    % column 2 = cue timing
    % column 3 = target timing
    % column 5 = cue type
    % column 7 = experimental condition (1 = x, 2 = c)
    time.cue1_c(:,5) = 1;
    clear n
    for n = 1:data.numtri_c ./ data.num_cues;
        clear y
        y = n .* data.num_cues;
        time.cue1_c(y,5) = data.num_cues;
        if data.num_cues > 2;
            clear x
            for x = 1:data.num_cues - 2;
                time.cue1_c(y-x,5) = data.num_cues - x;
            end
        end
    end
    time.cue1_c(:,7) = 2;
    % under timing save the original jitter so it can be checked
    timing.origcue1_c = time.cue1_c;

    % create times for targets
    clear n
    for n = 1:data.numtri_c;
        time.targ_c(n,:) = (time.jump_targc .* n) + data.targ_start;
    end
    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.targ == 2;
        clear a
        a = ((time.targ_c(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
        time.targ_c(find(time.targ_c(:,1) > data.tr,1):length(time.targ_c(:,1)),1) = time.targ_c(find(time.targ_c(:,1) > data.tr,1):length(time.targ_c(:,1)),1) + a;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.targ == 3;
        clear a
        clear b
        a = ((time.targ_c(1,1) - data.targ_start) ./ data.num_tr.targ) - (time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1),1) - (data.tr + data.targ_start));
        b = (((time.targ_c(1,1) - data.targ_start) ./ data.num_tr.targ) .* 2) - (time.targ_c(find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1),1) - ((data.tr .* 2) + data.targ_start));
        time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1):find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1,1) = time.targ_c(find(time.targ_c(:,1) > (data.tr + data.targ_start),1):find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1) - 1) + a;
        time.targ_c(find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start ),1):length(time.targ_c(:,1)),1) = time.targ_c(find(time.targ_c(:,1) > ((data.tr .* 2) + data.targ_start),1):length(time.targ_c(:,1)),1) + (a .* 2);   
    end
    timing.origtarg_c = time.targ_c;

    % create times for feedback
    clear n
    for n = 1:data.numtri_c;
        time.feed_c(n,:) = (time.jump_feedc .* n) + data.feed_start;
    end
    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.feed == 2;
        clear a
        a = ((time.feed_c(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
        time.feed_c(find(time.feed_c(:,1) > data.tr,1):length(time.feed_c(:,1)),1) = time.feed_c(find(time.feed_c(:,1) > data.tr,1):length(time.feed_c(:,1)),1) + a;
    end

    % if multiple TRs being jittered over ensure sampling is good
    if data.num_tr.feed == 3;
        clear a
        clear b
        a = ((time.feed_c(1,1) - data.feed_start) ./ data.num_tr.feed) - (time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1),1) - (data.tr + data.feed_start));
        b = (((time.feed_c(1,1) - data.feed_start) ./ data.num_tr.feed) .* 2) - (time.feed_c(find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1),1) - ((data.tr .* 2) + data.feed_start));
        time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1):find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1,1) = time.feed_c(find(time.feed_c(:,1) > (data.tr + data.feed_start),1):find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1) - 1) + a;
        time.feed_c(find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start ),1):length(time.feed_c(:,1)),1) = time.feed_c(find(time.feed_c(:,1) > ((data.tr .* 2) + data.feed_start),1):length(time.feed_c(:,1)),1) + (a .* 2);   
    end
    timing.origfeed_c = time.feed_c;


    % randomise
    time.cue1_c(:,1) = rand(1,data.numtri_c);
    time.cue1_c = sortrows(time.cue1_c,1);
    time.targ_c(:,2) = rand(1,data.numtri_c);
    time.targ_c = sortrows(time.targ_c,2);
    time.feed_c(:,2) = rand(1,data.numtri_c);
    time.feed_c = sortrows(time.feed_c,2);
    clear RHO1
    clear PVAL1
    clear RHO2
    clear PVAL2
    clear RHO3
    clear PVAL3
    [RHO1,PVAL1] = corr(time.cue1_c(:,2),time.targ_c(:,1));
    [RHO2,PVAL2] = corr(time.cue1_c(:,2),time.feed_c(:,1));
    [RHO3,PVAL3] = corr(time.targ_c(:,1),time.feed_c(:,1));
    time.r.c = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
    time.p.c = max([PVAL1 PVAL2 PVAL3]);

    % check for events that sit right next to each other
    time.ISIc(1) = min(time.targ_c(:,1) - (time.cue1_c(:,2) + data.cue_spec));
    time.ISIc(2) = min(time.feed_c(:,1) - (time.targ_c(:,1) + data.targ_spec));
    time.ISIc(3) = min(time.ISIc(1:2));

    % loops through until the cue and target onset times are maximally
    % uncorrelated and ensuring ISI does not exceed the stated minimum
    % threshold
    while time.r.c > data.r_thresh | time.p.c < data.p_thresh | time.ISIc(3) < data.ISI_thresh;
        % randomise
        time.cue1_c(:,1) = rand(1,data.numtri_c);
        time.cue1_c = sortrows(time.cue1_c,1);
        time.targ_c(:,2) = rand(1,data.numtri_c);
        time.targ_c = sortrows(time.targ_c,2);
        time.feed_c(:,2) = rand(1,data.numtri_c);
        time.feed_c = sortrows(time.feed_c,2);
        clear RHO1
        clear PVAL1
        clear RHO2
        clear PVAL2
        clear RHO3
        clear PVAL3
        [RHO1,PVAL1] = corr(time.cue1_c(:,2),time.targ_c(:,1));
        [RHO2,PVAL2] = corr(time.cue1_c(:,2),time.feed_c(:,1));
        [RHO3,PVAL3] = corr(time.targ_c(:,1),time.feed_c(:,1));
        time.r.c = max([abs(RHO1) abs(RHO2) abs(RHO3)]);
        time.p.c = max([PVAL1 PVAL2 PVAL3]);

        % check for events that sit right next to each other
        time.ISIc(1) = min(time.targ_c(:,1) - (time.cue1_c(:,2) + data.cue_spec));
        time.ISIc(2) = min(time.feed_c(:,1) - (time.targ_c(:,1) + data.targ_spec));
        time.ISIc(3) = min(time.ISIc(1:2));
    end

    % add target times to the main list
    time.c = time.cue1_c;
    time.c(:,1) = 0;
    time.c(:,3) = time.targ_c(:,1);
    time.c(:,4) = time.feed_c(:,1);

    % create zero columns for later stacking
    time.c(:,8:9) = 0;

    "control correlations fixed"




    % check the jitter
    clear n
    for n = 1:length(timing.origcue1_x(:,1));
        timing.jitter_cue1x(n,1) = 1;
        if timing.origcue1_x(n,2) < (data.tr + data.cue_start);
            timing.jitter_cue1x(n,2) = timing.origcue1_x(n,2);
        elseif timing.origcue1_x(n,2) > (data.tr + data.cue_start) & timing.origcue1_x(n,2) < ((data.tr .* 2) + data.cue_start);
            timing.jitter_cue1x(n,2) = timing.origcue1_x(n,2) - data.tr;
        elseif timing.origcue1_x(n,2) > ((data.tr .* 2) + data.cue_start);
            timing.jitter_cue1x(n,2) = timing.origcue1_x(n,2) - (data.tr .* 2);
        end
    end
    figure(1);
    subplot(3,2,1);
    scatter(timing.jitter_cue1x(:,2),timing.jitter_cue1x(:,1),'filled');
    title('cue1x');

    clear n
    for n = 1:length(timing.origcue1_c(:,1));
        timing.jitter_cue1c(n,1) = 1;
        if timing.origcue1_c(n,2) < (data.tr + data.cue_start);
            timing.jitter_cue1c(n,2) = timing.origcue1_c(n,2);
        elseif timing.origcue1_c(n,2) > (data.tr + data.cue_start) & timing.origcue1_c(n,2) < ((data.tr .* 2) + data.cue_start);
            timing.jitter_cue1c(n,2) = timing.origcue1_c(n,2) - data.tr;
        elseif timing.origcue1_c(n,2) > ((data.tr .* 2) + data.cue_start);
            timing.jitter_cue1c(n,2) = timing.origcue1_c(n,2) - (data.tr .* 2);
        end
    end
    figure(1);
    subplot(3,2,2);
    scatter(timing.jitter_cue1c(:,2),timing.jitter_cue1c(:,1),'filled');
    title('cue1c');

    % check the jitter - targets
    clear n
    for n = 1:length(timing.origtarg_x(:,1));
        timing.jitter_targx(n,1) = 1;
        if timing.origtarg_x(n,1) < (data.tr + data.targ_start);
            timing.jitter_targx(n,2) = timing.origtarg_x(n,1) - data.targ_start;
        elseif timing.origtarg_x(n,1) > (data.tr + data.targ_start) & timing.origtarg_x(n,1) < ((data.tr .* 2) + data.targ_start);
            timing.jitter_targx(n,2) = timing.origtarg_x(n,1) - (data.tr + data.targ_start);
        elseif timing.origtarg_x(n,1) > ((data.tr .* 2) + data.targ_start);
            timing.jitter_targx(n,2) = timing.origtarg_x(n,1) - ((data.tr .* 2) + data.targ_start);
        end
    end
    figure(1);
    subplot(3,2,3);
    scatter(timing.jitter_targx(:,2),timing.jitter_targx(:,1),'filled');
    title('targx');

    clear n
    for n = 1:length(timing.origtarg_c(:,1));
        timing.jitter_targc(n,1) = 1;
        if timing.origtarg_c(n,1) < (data.tr + data.targ_start);
            timing.jitter_targc(n,2) = timing.origtarg_c(n,1) - data.targ_start;
        elseif timing.origtarg_c(n,1) > (data.tr + data.targ_start) & timing.origtarg_c(n,1) < ((data.tr .* 2) + data.targ_start);
            timing.jitter_targc(n,2) = timing.origtarg_c(n,1) - (data.tr + data.targ_start);
        elseif timing.origtarg_c(n,1) > ((data.tr .* 2) + data.targ_start);
            timing.jitter_targc(n,2) = timing.origtarg_c(n,1) - ((data.tr .* 2) + data.targ_start);
        end
    end
    figure(1);
    subplot(3,2,4);
    scatter(timing.jitter_targc(:,2),timing.jitter_targc(:,1),'filled');
    title('targc');

    % check the jitter - feedback
    clear n
    for n = 1:length(timing.origfeed_x(:,1));
        timing.jitter_feedx(n,1) = 1;
        if timing.origfeed_x(n,1) < (data.tr + data.feed_start);
            timing.jitter_feedx(n,2) = timing.origfeed_x(n,1) - data.feed_start;
        elseif timing.origfeed_x(n,1) > (data.tr + data.feed_start) & timing.origfeed_x(n,1) < ((data.tr .* 2) + data.feed_start);
            timing.jitter_feedx(n,2) = timing.origfeed_x(n,1) - (data.tr + data.feed_start);
        elseif timing.origfeed_x(n,1) > ((data.tr .* 2) + data.feed_start);
            timing.jitter_feedx(n,2) = timing.origfeed_x(n,1) - ((data.tr .* 2) + data.feed_start);
        end
    end
    figure(1);
    subplot(3,2,5);
    scatter(timing.jitter_feedx(:,2),timing.jitter_feedx(:,1),'filled');
    title('feedx');

    clear n
    for n = 1:length(timing.origfeed_c(:,1));
        timing.jitter_feedc(n,1) = 1;
        if timing.origfeed_c(n,1) < (data.tr + data.feed_start);
            timing.jitter_feedc(n,2) = timing.origfeed_c(n,1) - data.feed_start;
        elseif timing.origfeed_c(n,1) > (data.tr + data.feed_start) & timing.origfeed_c(n,1) < ((data.tr .* 2) + data.feed_start);
            timing.jitter_feedc(n,2) = timing.origfeed_c(n,1) - (data.tr + data.feed_start);
        elseif timing.origfeed_c(n,1) > ((data.tr .* 2) + data.feed_start);
            timing.jitter_feedc(n,2) = timing.origfeed_c(n,1) - ((data.tr .* 2) + data.feed_start);
        end
    end
    figure(1);
    subplot(3,2,6);
    scatter(timing.jitter_feedc(:,2),timing.jitter_feedc(:,1),'filled');
    title('feedc');


    % now I compile all the trials into their respective blocks
    clear n

    % first separate into each cue type for exp and control
    for n = 1:data.num_cues;
        % find each set of experimental cue types sequentially
        clear my_field
        my_field = strcat('x_',num2str(n));
        block.(my_field) = time.x(find(time.x(:,5) == n),:);
        % do the same for the control cue types
        clear my_field
        my_field = strcat('c_',num2str(n));
        block.(my_field) = time.c(find(time.c(:,5) == n),:);
    end

    % then spread these equally over blocks
    clear numx
    clear numc
    numx = (data.numtri_x ./ data.tot_num_blocks) ./ data.num_cues;
    numc = (data.numtri_c ./ data.tot_num_blocks) ./ data.num_cues;
    clear n
    for n = 1:data.tot_num_blocks;
        clear a
        a = strcat('block_',num2str(n));
        clear m
        for m = 1:data.num_cues;
            clear b
            b = strcat('x_',num2str(m));
            block.(a)(((m - 1) .* numx) + 1:m .* numx,:) = block.(b)(((n - 1) .* numx) + 1: n .* numx,:);
        end
        clear m
        for m = 1:data.num_cues;
            % now add in the control trials
            clear b
            b = strcat('c_',num2str(m));
            block.(a)(length(block.(a)(:,1)) + 1:length(block.(a)(:,1)) + numc,:) = block.(b)(((n - 1) .* numc) + 1: n .* numc,:);
        end
        % set the block number in column 8
        block.(a)(:,8) = n;
    end


    % randomise the blocks
    clear n
    for n = 1:data.tot_num_blocks;
        clear a
        a = strcat('block_',num2str(n));
        clear b
        b = strcat('rand_',num2str(n));
        block.(a)(:,1) = rand(1,length(block.(a)(:,1)));
        block.(b) = sortrows(block.(a),1);
    end


    % now concatenate all the blocks into a single run
    clear n
    total.whole_run = block.rand_1
    for n = 2:data.tot_num_blocks
        clear a
        a = strcat('rand_',num2str(n));
        total.whole_run(length(total.whole_run(:,1)) + 1:length(total.whole_run(:,1)) +...
        ((data.tot_num_trials ./ data.tot_num_blocks)),:) = block.(a);
    end



    % then make this run continuous and in seconds
    % first set the respective trial length
    clear n
    for n = 1:length(total.whole_run(:,1));
        total.whole_run(n,9) = data.trilen .* 1000;
    end
    % then make these cumulative
    clear n
    for n = 2:length(total.whole_run(:,1));
        total.whole_run(n,9) = total.whole_run(n,9) + total.whole_run(n - 1,9);
    end

    % now make the trial times cumulative
    clear n
    total.run2(1,:) = total.whole_run(1,:);
    for n = 2:length(total.whole_run(:,1));
        total.run2(n,:) = total.whole_run(n,:);
        total.run2(n,2:4) = total.run2(n,2:4) + total.run2(n-1,9);
    end


    % convert to seconds
    total.run2(:,2:4) = total.run2(:,2:4) ./ 1000;

    % need to consider conditions of interest
    cond.x = total.run2(find(total.run2(:,7) == 1),:);
    cond.c = total.run2(find(total.run2(:,7) == 2),:);


    % create the regressors
    cond.x_cue_cor = cond.x(:,2);
    cond.x_tar_cor = cond.x(:,3);
    cond.x_fee_cor = cond.x(:,4);
    cond.c_cue_cor = cond.c(:,2);
    cond.c_tar_cor = cond.c(:,3);
    cond.c_fee_cor = cond.c(:,4);


    % load the HRFc function
    data.hrfc = importdata('HRFc.mat')';
    % check how many cells per second
    data.sec = length(data.hrfc) ./ 32.0125;
    % calculate the length of the design matrix in cells
    clear x
    x = max(max(total.run2(:,3:4)));
    clear y
    y = ceil(x .* data.sec) + length(data.hrfc);

    % create the faux design matrix
    cond.design(1:y,1:data.num_regressors) = 0;

    % loop through each variable and convolve with the HRF

    % 1 = exp cue correct
    % 2 = exp target correct
    % 3 = exp feedback correct
    % 4 = con cue all
    % 5 = con target all
    % 6 = con feedback all


    % exp cue correct
    clear n
    for n = 1:length(cond.x_cue_cor(:,1));
        clear x
        x = ceil(cond.x_cue_cor(n,1) .* data.sec);
        cond.design(x:x+259,1) = cond.design(x:x+259,1) + data.hrfc;
    end

    % exp target correct
    clear n
    for n = 1:length(cond.x_tar_cor(:,1));
        clear x
        x = ceil(cond.x_tar_cor(n,1) .* data.sec);
        cond.design(x:x+259,2) = cond.design(x:x+259,2) + data.hrfc;
    end

    % exp feedback correct
    clear n
    for n = 1:length(cond.x_fee_cor(:,1));
        clear x
        x = ceil(cond.x_fee_cor(n,1) .* data.sec);
        cond.design(x:x+259,3) = cond.design(x:x+259,3) + data.hrfc;
    end

    % ctr cue correct
    clear n
    for n = 1:length(cond.c_cue_cor(:,1));
        clear x
        x = ceil(cond.c_cue_cor(n,1) .* data.sec);
        cond.design(x:x+259,4) = cond.design(x:x+259,4) + data.hrfc;
    end

    % ctr target correct
    clear n
    for n = 1:length(cond.c_tar_cor(:,1));
        clear x
        x = ceil(cond.c_tar_cor(n,1) .* data.sec);
        cond.design(x:x+259,5) = cond.design(x:x+259,5) + data.hrfc;
    end

    % ctr feedback correct
    clear n
    for n = 1:length(cond.c_fee_cor(:,1));
        clear x
        x = ceil(cond.c_fee_cor(n,1) .* data.sec);
        cond.design(x:x+259,6) = cond.design(x:x+259,6) + data.hrfc;
    end


    % create a correlation matrix
    cond.correlate = corrcoef(cond.design);

    % remove 1s
    clear n
    for n = 1:length(cond.correlate(:,1));
        cond.correlate(n,n) = 0;
    end

    clear max_j
    cond.max_correlate = max(max(abs(cond.correlate)))
    total.duration = max(max(total.run2(:,3:4))) ./ 60;


    % load up the currently best r value
    old = importdata('cond.mat');
    % if my new best r value is lower, then save this
    if cond.max_correlate < old.max_correlate;
        save block block
        save cond cond
        save time time
        save total total
        'Improvement!'
    else
        'No good....'
    end
end 