
% this needs the spike file and the results file, but none of the
% dataviewer files.

% later on at the bottom we need the other dataviewer files including trial
% start times, messages, and message times.
clear all
% load the datafile starting at the TTL trigger
load('data_401.mat');

% save ID
design.num = 401;

% set whether we use max (1) or mean (2) pupil size data
type = 1;

% set number of blocks, trials, calibrations etc.
num_block = 6;
num_tri = 72;
num_cal = 5;
block_tri = num_tri ./ (num_cal + 1);
numEvents_perBlock = 3;
num_events.trial = num_tri .* 6;
num_events.cal = num_cal .* 4;
% when I export the data from spike set it to 5000Hz and time shifted
% divide n by 5 to set the value to ms


% TTLs - events
run_ttl = data_401_Ch2.values;
change_ttl = findchangepts(run_ttl,'MaxNumChanges',num_events.trial);
figure(99);
plot(run_ttl);
hold on
for n = 1:num_events.trial;
    xline(change_ttl(n));
end
change_ttl = change_ttl ./ 5;

% TTLs - calibration
cal_ttl = data_401_Ch1.values;
change_cal = findchangepts(cal_ttl,'MaxNumChanges',num_events.cal);
figure(100);
plot(cal_ttl);
hold on
for n = 1:num_events.cal;
    xline(change_cal(n));
end
change_cal = change_cal ./ 5;


% this is the basic results folder with RTs and correct/incorrect etc.
results1 = importdata('RT_RESULTS.txt');
results = results1.data;
results(1:8,:) = [];
% load pupillometry data from onset of cue1 to onset of targets. This gives
% the max, then the mean
pupil = importdata('pupil_whole.xlsx');
pupil(1:8,:) = [];

% find the experimental trials
exp.results = results(find(results(:,8) == 1),:);
% check errors in each cue
for n = 1:4;
    exp.split(1,n) = length(find(exp.results(:,3) == n & exp.results(:,5) == 1));
end
% now convert to percentage
for n = 1:4;
    exp.split(2,n) = (exp.split(1,n) ./ sum(exp.split(1,:))) .* 100;
end

% find pupillometry data
exp.pupil.all = pupil(find(results(:,8) == 1),:);
% split by cue type
exp.pupil.one = pupil(find(results(:,8) == 1 & results(:,3) == 1),:);
exp.pupil.two = pupil(find(results(:,8) == 1 & results(:,3) == 2),:);
exp.pupil.three = pupil(find(results(:,8) == 1 & results(:,3) == 3),:);
exp.pupil.four = pupil(find(results(:,8) == 1 & results(:,3) == 4),:);

% take the average of all experimental trials within each block
exp.pupil.blocked(1,1) = median(pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(1,2) = range(pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 1),type));
% run kolmogorov smirnov test, if 1 then not a normal distribution
exp.pupil.blocked(1,3) = kstest(pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 1),type));

exp.pupil.blocked(2,1) = median(pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(2,2) = range(pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(2,3) = kstest(pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 1),type));

exp.pupil.blocked(3,1) = median(pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(3,2) = range(pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(3,3) = kstest(pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 1),type));

exp.pupil.blocked(4,1) = median(pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(4,2) = range(pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(4,3) = kstest(pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 1),type));

exp.pupil.blocked(5,1) = median(pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(5,2) = range(pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(5,3) = kstest(pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 1),type));

exp.pupil.blocked(6,1) = median(pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(6,2) = range(pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 1),type));
exp.pupil.blocked(6,3) = kstest(pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 1),type));


% look at blocks
exp.pupil.block.total = pupil(find(results(:,8) == 1),:);
exp.pupil.block.one = pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 1),type);
figure(900);
hold on
subplot(3,2,1);
histogram(exp.pupil.block.one(:,type),length(exp.pupil.block.one(:,type)));
exp.pupil.block.two = pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 1),type);
subplot(3,2,2);
histogram(exp.pupil.block.two(:,type),length(exp.pupil.block.two(:,type)));
exp.pupil.block.thr = pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 1),type);
subplot(3,2,3);
histogram(exp.pupil.block.thr(:,type),length(exp.pupil.block.thr(:,type)));
exp.pupil.block.fou = pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 1),type);
subplot(3,2,4);
histogram(exp.pupil.block.fou(:,type),length(exp.pupil.block.fou(:,type)));
exp.pupil.block.fiv = pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 1),type);
subplot(3,2,5);
histogram(exp.pupil.block.fiv(:,type),length(exp.pupil.block.fiv(:,type)));
exp.pupil.block.six = pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 1),type);
subplot(3,2,6);
histogram(exp.pupil.block.six(:,type),length(exp.pupil.block.six(:,type)));
title('exp pupil');
hold off

con.results = results(find(results(:,8) == 2),:);    
con.pupil.all = pupil(find(results(:,8) == 2),:);
con.pupil.one = pupil(find(results(:,8) == 2 & results(:,3) == 1),:);
con.pupil.two = pupil(find(results(:,8) == 2 & results(:,3) == 2),:);
con.pupil.three = pupil(find(results(:,8) == 2 & results(:,3) == 3),:);
con.pupil.four = pupil(find(results(:,8) == 2 & results(:,3) == 4),:);

% set whether we use max (1) or mean (2)
con.pupil.blocked(1,1) = median(pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(1,2) = range(pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 2),type));
% run kolmogorov smirnov test, if 1 then not a normal distribution
con.pupil.blocked(1,3) = kstest(pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 2),type));

con.pupil.blocked(2,1) = median(pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(2,2) = range(pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(2,3) = kstest(pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 2),type));

con.pupil.blocked(3,1) = median(pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(3,2) = range(pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(3,3) = kstest(pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 2),type));

con.pupil.blocked(4,1) = median(pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(4,2) = range(pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(4,3) = kstest(pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 2),type));

con.pupil.blocked(5,1) = median(pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(5,2) = range(pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(5,3) = kstest(pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 2),type));

con.pupil.blocked(6,1) = median(pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(6,2) = range(pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 2),type));
con.pupil.blocked(6,3) = kstest(pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 2),type));



% look at blocks
con.pupil.block.total = pupil(find(results(:,8) == 1),:);
con.pupil.block.one = pupil(find(results(:,1) < 21 & results(:,1) > 8 & results(:,5) == 2 & results(:,8) == 2),type);
figure(901);
hold on
subplot(3,2,1);
histogram(con.pupil.block.one(:,type),length(con.pupil.block.one(:,type)));
con.pupil.block.two = pupil(find(results(:,1) < 33 & results(:,1) > 20 & results(:,5) == 2 & results(:,8) == 2),type);
subplot(3,2,2);
histogram(con.pupil.block.two(:,type),length(con.pupil.block.two(:,type)));
con.pupil.block.thr = pupil(find(results(:,1) < 45 & results(:,1) > 32 & results(:,5) == 2 & results(:,8) == 2),type);
subplot(3,2,3);
histogram(con.pupil.block.thr(:,type),length(con.pupil.block.thr(:,type)));
con.pupil.block.fou = pupil(find(results(:,1) < 57 & results(:,1) > 44 & results(:,5) == 2 & results(:,8) == 2),type);
subplot(3,2,4);
histogram(con.pupil.block.fou(:,type),length(con.pupil.block.fou(:,type)));
con.pupil.block.fiv = pupil(find(results(:,1) < 69 & results(:,1) > 56 & results(:,5) == 2 & results(:,8) == 2),type);
subplot(3,2,5);
histogram(con.pupil.block.fiv(:,type),length(con.pupil.block.fiv(:,type)));
con.pupil.block.six = pupil(find(results(:,1) < 81 & results(:,1) > 68 & results(:,5) == 2 & results(:,8) == 2),type);
subplot(3,2,6);
histogram(con.pupil.block.six(:,type),length(con.pupil.block.six(:,type)));
title('con pupil');
hold off




% block up the experimental trials
exp.block.one = exp.results(find(exp.results(:,1) < 21),:);
% finds the percentage relative to total number trials (missed or not)
exp.cor(1) = (length(find(exp.block.one(:,5) == 2)) ./ 8) .* 100;
% finds the percentage relative to the number of non miss trials
exp.cor_only(1) = (length(find(exp.block.one(:,5) == 2)) ./ length(find(exp.block.one(:,5) > 0))) .* 100;
exp.rt(1) = median(exp.block.one(find(exp.block.one(:,2) > 0 & exp.block.one(:,5) == 2),2));
figure(910);
hold on
title('exp RTs');
subplot(3,2,1);
histogram(exp.block.one(find(exp.block.one(:,5) == 2 & exp.block.one(:,2) > 0),2),length(exp.block.one(find(exp.block.one(:,5) == 2 & exp.block.one(:,2) > 0))));

exp.block.two = exp.results(find(exp.results(:,1) < 33 & exp.results(:,1) > 20),:);
exp.cor(2) = (length(find(exp.block.two(:,5) == 2)) ./ 8) .* 100;
% finds the percentage relative to the number of non miss trials
exp.cor_only(2) = (length(find(exp.block.two(:,5) == 2)) ./ length(find(exp.block.two(:,5) > 0))) .* 100;
exp.rt(2) = median(exp.block.two(find(exp.block.two(:,2) > 0 & exp.block.two(:,5) == 2),2));
subplot(3,2,2);
histogram(exp.block.two(find(exp.block.two(:,5) == 2 & exp.block.two(:,2) > 0),2),length(exp.block.two(find(exp.block.two(:,5) == 2 & exp.block.two(:,2) > 0))));

exp.block.thr = exp.results(find(exp.results(:,1) < 45 & exp.results(:,1) > 32),:);
exp.cor(3) = (length(find(exp.block.thr(:,5) == 2)) ./ 8) .* 100;
% finds the percentage relative to the number of non miss trials
exp.cor_only(3) = (length(find(exp.block.thr(:,5) == 2)) ./ length(find(exp.block.thr(:,5) > 0))) .* 100;
exp.rt(3) = median(exp.block.thr(find(exp.block.thr(:,2) > 0 & exp.block.thr(:,5) == 2),2));
subplot(3,2,3);
histogram(exp.block.thr(find(exp.block.thr(:,5) == 2 & exp.block.thr(:,2) > 0),2),length(exp.block.thr(find(exp.block.thr(:,5) == 2 & exp.block.thr(:,2) > 0))));

exp.block.fou = exp.results(find(exp.results(:,1) < 57 & exp.results(:,1) > 44),:);
exp.cor(4) = (length(find(exp.block.fou(:,5) == 2)) ./ 8) .* 100;
% finds the percentage relative to the number of non miss trials
exp.cor_only(4) = (length(find(exp.block.fou(:,5) == 2)) ./ length(find(exp.block.fou(:,5) > 0))) .* 100;
exp.rt(4) = median(exp.block.fou(find(exp.block.fou(:,2) > 0 & exp.block.fou(:,5) == 2),2));
subplot(3,2,4);
histogram(exp.block.fou(find(exp.block.fou(:,5) == 2 & exp.block.fou(:,2) > 0),2),length(exp.block.fou(find(exp.block.fou(:,5) == 2 & exp.block.fou(:,2) > 0))));

exp.block.fiv = exp.results(find(exp.results(:,1) < 69 & exp.results(:,1) > 56),:);
exp.cor(5) = (length(find(exp.block.fiv(:,5) == 2)) ./ 8) .* 100;
% finds the percentage relative to the number of non miss trials
exp.cor_only(5) = (length(find(exp.block.fiv(:,5) == 2)) ./ length(find(exp.block.fiv(:,5) > 0))) .* 100;
exp.rt(5) = median(exp.block.fiv(find(exp.block.fiv(:,2) > 0 & exp.block.fiv(:,5) == 2),2));
subplot(3,2,5);
histogram(exp.block.fiv(find(exp.block.fiv(:,5) == 2 & exp.block.fiv(:,2) > 0),2),length(exp.block.fiv(find(exp.block.fiv(:,5) == 2 & exp.block.fiv(:,2) > 0))));

exp.block.six = exp.results(find(exp.results(:,1) < 81 & exp.results(:,1) > 68),:);
exp.cor(6) = (length(find(exp.block.six(:,5) == 2)) ./ 8) .* 100;
% finds the percentage relative to the number of non miss trials
exp.cor_only(6) = (length(find(exp.block.six(:,5) == 2)) ./ length(find(exp.block.six(:,5) > 0))) .* 100;
exp.rt(6) = median(exp.block.six(find(exp.block.six(:,2) > 0 & exp.block.six(:,5) == 2),2));
subplot(3,2,6);
histogram(exp.block.six(find(exp.block.six(:,5) == 2 & exp.block.six(:,2) > 0),2),length(exp.block.six(find(exp.block.six(:,5) == 2 & exp.block.six(:,2) > 0))));
hold off


% block up the control trials
con.block.one = con.results(find(con.results(:,1) < 21),:);
con.rt(1) = median(con.block.one(find(con.block.one(:,2) > 0 & con.block.one(:,5) == 2),2));
figure(911);
hold on
title('con RTs');
subplot(3,2,1);
histogram(con.block.one(find(con.block.one(:,5) == 2 & con.block.one(:,2) > 0),2),length(con.block.one(find(con.block.one(:,5) == 2 & con.block.one(:,2) > 0))));

con.block.two = con.results(find(con.results(:,1) < 33 & con.results(:,1) > 20),:);
con.rt(2) = median(con.block.two(find(con.block.two(:,2) > 0 & con.block.two(:,5) == 2),2));
subplot(3,2,2);
histogram(con.block.two(find(con.block.two(:,5) == 2 & con.block.two(:,2) > 0),2),length(con.block.two(find(con.block.two(:,5) == 2 & con.block.two(:,2) > 0))));

con.block.thr = con.results(find(con.results(:,1) < 45 & con.results(:,1) > 32),:);
con.rt(3) = median(con.block.thr(find(con.block.thr(:,2) > 0 & con.block.thr(:,5) == 2),2));
subplot(3,2,3);
histogram(con.block.thr(find(con.block.thr(:,5) == 2 & con.block.thr(:,2) > 0),2),length(con.block.thr(find(con.block.thr(:,5) == 2 & con.block.thr(:,2) > 0))));

con.block.fou = con.results(find(con.results(:,1) < 57 & con.results(:,1) > 44),:);
con.rt(4) = median(con.block.fou(find(con.block.fou(:,2) > 0 & con.block.fou(:,5) == 2),2));
subplot(3,2,4);
histogram(con.block.fou(find(con.block.fou(:,5) == 2 & con.block.fou(:,2) > 0),2),length(con.block.fou(find(con.block.fou(:,5) == 2 & con.block.fou(:,2) > 0))));

con.block.fiv = con.results(find(con.results(:,1) < 69 & con.results(:,1) > 56),:);
con.rt(5) = median(con.block.fiv(find(con.block.fiv(:,2) > 0 & con.block.fiv(:,5) == 2),2));
subplot(3,2,5);
histogram(con.block.fiv(find(con.block.fiv(:,5) == 2 & con.block.fiv(:,2) > 0),2),length(con.block.fiv(find(con.block.fiv(:,5) == 2 & con.block.fiv(:,2) > 0))));

con.block.six = con.results(find(con.results(:,1) < 81 & con.results(:,1) > 68),:);
con.rt(6) = median(con.block.six(find(con.block.six(:,2) > 0 & con.block.six(:,5) == 2),2));
subplot(3,2,6);
histogram(con.block.six(find(con.block.six(:,5) == 2 & con.block.six(:,2) > 0),2),length(con.block.six(find(con.block.six(:,5) == 2 & con.block.six(:,2) > 0))));
hold off

% set the percentage of correct trials
% plot bar
X = categorical({'One','Two','Three','Four','Five','Six'});
X = reordercats(X,{'One','Two','Three','Four','Five','Six'});
figure(1);
bar(X,exp.cor_only)
hold on
xlabel('Blocks');
ylabel('Percentage Correct');
ylim([0 100]);


figure(2);
subplot(2,2,1);
plot(exp.pupil.one(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 1');
subplot(2,2,2);
plot(exp.pupil.two(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 2');
subplot(2,2,3);
plot(exp.pupil.three(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 3');
subplot(2,2,4);
plot(exp.pupil.four(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 4');

figure(22);
subplot(2,2,1);
plot(con.pupil.one(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 1');
subplot(2,2,2);
plot(con.pupil.two(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 2');
subplot(2,2,3);
plot(con.pupil.three(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 3');
subplot(2,2,4);
plot(con.pupil.four(:,type));
xlabel('Trials');
ylabel('Maximum Pupil Area');
title('Rule 4');

% add error bars to the block averages for pupillometry
figure(33);
errorbar(exp.pupil.blocked(:,1),exp.pupil.blocked(:,2));
hold on
errorbar(con.pupil.blocked(:,1),con.pupil.blocked(:,2));
xlabel('blocks');
ylabel('averaged max pupil area');
legend('experimental','control');
title('Pupillometry data (error bars = 1SD)');
hold off

% create bar chart for the same
pupil_bar = [exp.pupil.blocked(1,1) con.pupil.blocked(1,1); exp.pupil.blocked(2,1) con.pupil.blocked(2,1); ...
    exp.pupil.blocked(3,1) con.pupil.blocked(3,1); exp.pupil.blocked(4,1) con.pupil.blocked(4,1); ...
    exp.pupil.blocked(5,1) con.pupil.blocked(5,1); exp.pupil.blocked(6,1) con.pupil.blocked(6,1)];
pupil_std = [exp.pupil.blocked(1,2) con.pupil.blocked(1,2); exp.pupil.blocked(2,2) con.pupil.blocked(2,2); ...
    exp.pupil.blocked(3,2) con.pupil.blocked(3,2); exp.pupil.blocked(4,2) con.pupil.blocked(4,2); ...
    exp.pupil.blocked(5,2) con.pupil.blocked(5,2); exp.pupil.blocked(6,2) con.pupil.blocked(6,2)];

figure(44); clf;
hb = bar(pupil_bar);
hold on
for k = 1:size(pupil_bar,2)
    xpos = hb(k).XData + hb(k).XOffset;
    errorbar(xpos, pupil_bar(:,k), pupil_std(:,k), 'Linestyle', 'none', ...
        'Color', 'k', 'LineWidth', 1);
end
set(gca,'xticklabel',{'One'; 'Two'; 'Three'; 'Four'; 'Five'; 'Six'});
ylim([300 1300]);
xlabel('blocks');
ylabel('averaged max pupil area');
legend('experimental','control');
title('Pupillometry data (error bars = 1SD)');




% find all events in the trials, removing the calibration periods
if num_block > 0;
    times.block(1:block_tri .* numEvents_perBlock .* 2) = change_ttl(1:block_tri .* numEvents_perBlock .* 2);
end
for n = 1:num_block - 2;
    times.block(length(times.block) + 1:length(times.block) + block_tri .* numEvents_perBlock .* 2)...
    = change_ttl(length(times.block) + 1:length(times.block) + block_tri .* numEvents_perBlock .* 2);
end
times.block(length(times.block) + 1:length(times.block) + block_tri .* numEvents_perBlock .* 2)...
    = change_ttl(length(times.block) + 1:length(times.block) + block_tri .* numEvents_perBlock .* 2);
% convert to seconds
times.block = times.block ./ 1000;

% this finds the onset then the duration for each
for n = 1:num_tri;
    spike.cue(1,n) = times.block(1 + (6 .* (n - 1)));
    spike.cue(2,n) = times.block(2 + (6 .* (n - 1))) - times.block(1 + (6 .* (n - 1)));
    spike.targ(1,n) = times.block(3 + (6 .* (n - 1)));
    spike.targ(2,n) = times.block(4 + (6 .* (n - 1))) - times.block(3 + (6 .* (n - 1)));
    spike.feed(1,n) = times.block(5 + (6 .* (n - 1)));
    spike.feed(2,n) = times.block(6 + (6 .* (n - 1))) - times.block(5 + (6 .* (n - 1)));    
end



% convert the rest/calibration data into seconds
change_cal = change_cal ./ 1000;

% now save onset, offset and duration
for n = 1:num_cal;
    spike.rest(n,1) = change_cal(1 + (4 .* (n - 1)));
    spike.rest(n,2) = change_cal(2 + (4.* (n - 1)));
    spike.rest(n,3) = spike.rest(n,2) - spike.rest(n,1);
    spike.cal(n,1) = change_cal(3 + (4 .* (n - 1)));
    spike.cal(n,2) = change_cal(4 + (4.* (n - 1)));
    spike.cal(n,3) = spike.cal(n,2) - spike.cal(n,1);
end

% add the times to the original results file
results(:,9) = spike.cue(1,:);
results(:,10) = spike.targ(1,:);
results(:,11) = spike.feed(1,:);
% add pupillometry data (max)
results(:,12) = pupil(:,1);
% add event durations
results(:,14) = spike.cue(2,:);
results(:,15) = spike.targ(2,:);
results(:,16) = spike.feed(2,:);



% start to separate the key trials
% find the correct experimental trials
trials.correct_exp = results(find(results(:,8) == 1 & results(:,5) == 2),:);
% find the incorrect experimental trials
trials.incorrect_exp = results(find(results(:,8) == 1 & results(:,5) == 1),:);
% find the correct control trials
trials.correct_ctrl = results(find(results(:,8) == 2 & results(:,5) == 2),:);
% find the missed trials
trials.missed_all = results(find(results(:,5) == 0),:);
trials.missed_x = results(find(results(:,8) == 1 & results(:,5) == 0),:);
trials.missed_c = results(find(results(:,8) == 2 & results(:,5) == 0),:);

% isolate the experimental trials
trials.experimental = results(find(results(:,8) == 1),:);
% isolate all control trials
trials.control = results(find(results(:,8) == 2),:);


% now split into the 4 different rule options
trials.exp.one = trials.experimental(find(trials.experimental(:,3) == 1),:);
trials.exp.two = trials.experimental(find(trials.experimental(:,3) == 2),:);
trials.exp.three = trials.experimental(find(trials.experimental(:,3) == 3),:);
trials.exp.four = trials.experimental(find(trials.experimental(:,3) == 4),:);

trials.ctrl.one = trials.control(find(trials.control(:,3) == 1),:);
trials.ctrl.two = trials.control(find(trials.control(:,3) == 2),:);
trials.ctrl.three = trials.control(find(trials.control(:,3) == 3),:);
trials.ctrl.four = trials.control(find(trials.control(:,3) == 4),:);

% create the alternative trial types removing trials where n - 1 is error
trials.exp.one(:,17) = 0;
trials.exp.two(:,17) = 0;
trials.exp.three(:,17) = 0;
trials.exp.four(:,17) = 0;
% CUE 1
% Check the first trial
if trials.exp.one(1,5) == 2
    trials.exp.one_22 = trials.exp.one(1,:);
    trials.exp.one_22(1,17) = 1
end
% run through and check the rest
for n = 2:length(trials.exp.one(:,1));
    if trials.exp.one(n,5) == 2 & trials.exp.one(n-1,5) == 1;
        try
            trials.exp.one_12(length(trials.exp.one_12(:,1)) + 1,:) = trials.exp.one(n,:);
        catch
            trials.exp.one_12(1,:) = trials.exp.one(n,:);
        end
    elseif trials.exp.one(n,5) == 2;
        try
            trials.exp.one_22(length(trials.exp.one_22(:,1)) + 1,:) = trials.exp.one(n,:);
            trials.exp.one_22(length(trials.exp.one_22(:,1)),17) = length(trials.exp.one_22(:,1))
        catch
            trials.exp.one_22(1,:) = trials.exp.one(n,:);
            trials.exp.one_22(1,17) = 1
        end
    end
end
% 
% CUE 2
% Check the first trial
if trials.exp.two(1,5) == 2
    trials.exp.two_22 = trials.exp.two(1,:);
    trials.exp.two_22(1,17) = 1
end
% run through and check the rest
for n = 2:length(trials.exp.two(:,1));
    if trials.exp.two(n,5) == 2 & trials.exp.two(n-1,5) == 1;
        try
            trials.exp.two_12(length(trials.exp.two_12(:,1)) + 1,:) = trials.exp.two(n,:);
        catch
            trials.exp.two_12(1,:) = trials.exp.two(n,:);
        end
    elseif trials.exp.two(n,5) == 2;
        try
            trials.exp.two_22(length(trials.exp.two_22(:,1)) + 1,:) = trials.exp.two(n,:);
            trials.exp.two_22(length(trials.exp.two_22(:,1)),17) = length(trials.exp.two_22(:,1))
        catch
            trials.exp.two_22(1,:) = trials.exp.two(n,:);
            trials.exp.two_22(1,17) = 1
        end
    end
end
% 
% CUE 3
% Check the first trial
if trials.exp.three(1,5) == 2
    trials.exp.three_22 = trials.exp.three(1,:);
    trials.exp.three_22(1,17) = 1
end
% run through and check the rest
for n = 2:length(trials.exp.three(:,1));
    if trials.exp.three(n,5) == 2 & trials.exp.three(n-1,5) == 1;
        try
            trials.exp.three_12(length(trials.exp.three_12(:,1)) + 1,:) = trials.exp.three(n,:);
        catch
            trials.exp.three_12(1,:) = trials.exp.three(n,:);
        end
    elseif trials.exp.three(n,5) == 2;
        try
            trials.exp.three_22(length(trials.exp.three_22(:,1)) + 1,:) = trials.exp.three(n,:);
            trials.exp.three_22(length(trials.exp.three_22(:,1)),17) = length(trials.exp.three_22(:,1))
        catch
            trials.exp.three_22(1,:) = trials.exp.three(n,:);
            trials.exp.three_22(1,17) = 1
        end
    end
end
% 
% CUE 4
% Check the first trial
if trials.exp.four(1,5) == 2
    trials.exp.four_22 = trials.exp.four(1,:);
    trials.exp.four_22(1,17) = 1
end
% run through and check the rest
for n = 2:length(trials.exp.four(:,1));
    if trials.exp.four(n,5) == 2 & trials.exp.four(n-1,5) == 1;
        try
            trials.exp.four_12(length(trials.exp.four_12(:,1)) + 1,:) = trials.exp.four(n,:);
        catch
            trials.exp.four_12(1,:) = trials.exp.four(n,:);
        end
    elseif trials.exp.four(n,5) == 2;
        try
            trials.exp.four_22(length(trials.exp.four_22(:,1)) + 1,:) = trials.exp.four(n,:);
            trials.exp.four_22(length(trials.exp.four_22(:,1)),17) = length(trials.exp.four_22(:,1))
        catch
            trials.exp.four_22(1,:) = trials.exp.four(n,:);
            trials.exp.four_22(1,17) = 1
        end
    end
end
% now concatenate the trials for inc_cor types
trials.exp.all_12(1,1:17) = 0;
try
    trials.exp.all_12 = [trials.exp.all_12; trials.exp.one_12];
end
try
    trials.exp.all_12 = [trials.exp.all_12; trials.exp.two_12];
end
try
    trials.exp.all_12 = [trials.exp.all_12; trials.exp.three_12];
end
try
    trials.exp.all_12 = [trials.exp.all_12; trials.exp.four_12];
end
trials.exp.all_12(1,:) = [];
trials.exp.all_12 = sortrows(trials.exp.all_12, 1);
% and for cor-cor types
trials.exp.all_22(1,1:17) = 0;
try
    trials.exp.all_22 = [trials.exp.all_22; trials.exp.one_22];
end
try
    trials.exp.all_22 = [trials.exp.all_22; trials.exp.two_22];
end
try
    trials.exp.all_22 = [trials.exp.all_22; trials.exp.three_22];
end
try
    trials.exp.all_22 = [trials.exp.all_22; trials.exp.four_22];
end
trials.exp.all_22(1,:) = [];
trials.exp.all_22 = sortrows(trials.exp.all_22, 1);


% plot performance
figure(3);
subplot(1,2,1);
plot(trials.exp.one(:,2));
hold on
plot(trials.exp.two(:,2));
plot(trials.exp.three(:,2));
plot(trials.exp.four(:,2));
xlabel('trial number');
ylabel('Reaction Time (ms)');
legend('experimental all');
hold off


subplot(1,2,2);
plot(trials.ctrl.one(:,2));
hold on
plot(trials.ctrl.two(:,2));
plot(trials.ctrl.three(:,2));
plot(trials.ctrl.four(:,2));
xlabel('trial number');
ylabel('Reaction Time (ms)');
legend('control all');
hold off





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% sanity check the results %%%%%%%%

% these are the messages from dataviewer isolated into a single column,
% derived from analysis-messages(TXT and TIME)
messages = importdata('messages.xlsx');
% these are the message times from dataviewer isolated into a single column
message_times = importdata('times.xlsx');
% also load up the trial start times derived from analysis - trial report -
% start_time. This tells us at what time in the eyetracker run the trial
% started. Also put into a single column file.
t_start = importdata('st_time.xlsx');

% now look at the message file for the relevant indices of each cue type
% CUE1
cue1.a = strcmp('cue1_presentation',messages);
cue1.final = message_times(find(cue1.a == 1));

% TARGET
targ.a = strcmp('GO',messages);
targ.final = message_times(find(targ.a == 1));

% FEEDBACK
feed.a = strcmp('TTL_feedon',messages);
feed.final = message_times(find(feed.a == 1));

% START
star.a = strcmp('trial_start',messages);
star.final = message_times(find(star.a == 1));

% look at when the MRI scanner started relative to the eyetracker running, based on the trial start time
% for experimental trial 2, plus the delay which tells us when the first TTL
% pulse was received.
% EDITED DUE TO AN ERROR IN THE SYSTEM
% val = t_start(10) + star.final(1);
val = t_start(9) + star.final(1);

% now make the trials cumulative and convert from milliseconds into seconds
% also cut off the practise trials
% EDITED DUE TO AN ERROR IN THE SYSTEM so we run from the 2nd trial
% for n = 10:length(cue1.final);
%     datav.cue(n-9) = ((t_start(n) + cue1.final(n)) - val + 18000) ./ 1000;
%     datav.targ(n-9) = ((t_start(n) + targ.final(n)) - val + 18000) ./ 1000;
%     datav.feed(n-9) = ((t_start(n) + feed.final(n)) - val + 18000) ./ 1000;
% end
for n = 9:length(cue1.final);
    datav.cue(n-8) = ((t_start(n) + cue1.final(n)) - val) ./ 1000;
    datav.targ(n-8) = ((t_start(n) + targ.final(n)) - val) ./ 1000;
    datav.feed(n-8) = ((t_start(n) + feed.final(n)) - val) ./ 1000;
end

% now sanity check that things are approximately correct
figure(4);
subplot(1,3,1);
scatter(datav.cue,spike.cue(1,1:72));
hold on
xlabel('DataViewer');
ylabel('Spike');
title('Cue1');
hold off

subplot(1,3,2);
scatter(datav.targ,spike.targ(1,1:72));
hold on
xlabel('DataViewer');
ylabel('Spike');
title('Target');
hold off

subplot(1,3,3);
scatter(datav.feed,spike.feed(1,1:72));
hold on
xlabel('DataViewer');
ylabel('Spike');
title('Feedback');
hold off

% also plot the durations of events to see how well it works
run = [1:72];
figure(5);
subplot(3,1,1);
scatter(run,spike.cue(2,1:72));
xlabel('Trial');
ylabel('Duration (secs)');
title('Cue');

subplot(3,1,2);
scatter(run,spike.targ(2,1:72));
xlabel('Trial');
ylabel('Duration (secs)');
title('Target');

subplot(3,1,3);
scatter(run,spike.feed(2,1:72));
xlabel('Trial');
ylabel('Duration (secs)');
title('Feedback');


% this gives the min differences, max difference and range of the
% differences for each event type
diff.cue1(1) = min(datav.cue - spike.cue(1,1:72));
diff.cue1(2) = max(datav.cue - spike.cue(1,1:72));
diff.cue1(3) = range(datav.cue - spike.cue(1,1:72));
diff.targ(1) = min(datav.targ - spike.targ(1,1:72));
diff.targ(2) = max(datav.targ - spike.targ(1,1:72));
diff.targ(3) = range(datav.targ - spike.targ(1,1:72));
diff.feed(1) = min(datav.feed - spike.feed(1,1:72));
diff.feed(2) = max(datav.feed - spike.feed(1,1:72));
diff.feed(3) = range(datav.feed - spike.feed(1,1:72));

% check accuracy further
diff.dvmsp.cue(2,:) = datav.cue - spike.cue(1,1:72);
diff.dvmsp.cue(1,:) = [1:length(diff.dvmsp.cue(1,:))];
figure(990);
scatter(diff.dvmsp.cue(1,:),diff.dvmsp.cue(2,:));
hold on
xlabel('trial');
ylabel('error (dataviewer - spike) - sec');
hold off



% now generate the percentage accuray
total_accuracy.exp = length(trials.correct_exp(:,1)) ./ ((num_tri ./ 3) .* 2);
total_accuracy.ctrl = length(trials.correct_ctrl(:,1)) ./ (num_tri ./ 3);
total_accuracy.measure = (total_accuracy.exp ./ total_accuracy.ctrl) .* 100;
total_accuracy.missed_x = length(trials.missed_x(:,1)) ./ ((num_tri ./ 3) .* 2);
total_accuracy.missed_c = length(trials.missed_c(:,1)) ./ (num_tri ./ 3);


% check where differeces between spike and dataviewer occur
check.cue = spike.cue(1,1:72);
check.cue(2,:) = datav.cue(1,:);
check.cue(3,:) = check.cue(1,:) - check.cue(2,:);

% make parametric regressors (experimental)
clear n
clear count
count = 0;
for n = 1:length(trials.exp.one(:,5));
    if trials.exp.one(n,5) == 2;
        count = count + 1;
        paramet.exp.one(count,1) = trials.exp.one(n,1);
        paramet.exp.one(count,2) = count;
    end
end
clear n
clear count
count = 0;
for n = 1:length(trials.exp.two(:,5));
    if trials.exp.two(n,5) == 2;
        count = count + 1;
        paramet.exp.two(count,1) = trials.exp.two(n,1);
        paramet.exp.two(count,2) = count;
    end
end
clear n
clear count
count = 0;
for n = 1:length(trials.exp.three(:,5));
    if trials.exp.three(n,5) == 2;
        count = count + 1;
        paramet.exp.three(count,1) = trials.exp.three(n,1);
        paramet.exp.three(count,2) = count;
    end
end
clear n
clear count
count = 0;
for n = 1:length(trials.exp.four(:,5));
    if trials.exp.four(n,5) == 2;
        count = count + 1;
        paramet.exp.four(count,1) = trials.exp.four(n,1);
        paramet.exp.four(count,2) = count;
    end
end
paramet.exp.all = [paramet.exp.one; paramet.exp.two; paramet.exp.three; paramet.exp.four];
paramet.exp.all = sortrows(paramet.exp.all,1);


% make parametric regressors (control)
clear n
clear count
count = 0;
for n = 1:length(trials.ctrl.one(:,5));
    if trials.ctrl.one(n,5) == 2;
        count = count + 1;
        paramet.ctrl.one(count,1) = trials.ctrl.one(n,1);
        paramet.ctrl.one(count,2) = count;
    end
end
clear n
clear count
count = 0;
for n = 1:length(trials.ctrl.two(:,5));
    if trials.ctrl.two(n,5) == 2;
        count = count + 1;
        paramet.ctrl.two(count,1) = trials.ctrl.two(n,1);
        paramet.ctrl.two(count,2) = count;
    end
end
clear n
clear count
count = 0;
for n = 1:length(trials.ctrl.three(:,5));
    if trials.ctrl.three(n,5) == 2;
        count = count + 1;
        paramet.ctrl.three(count,1) = trials.ctrl.three(n,1);
        paramet.ctrl.three(count,2) = count;
    end
end
clear n
clear count
count = 0;
for n = 1:length(trials.ctrl.four(:,5));
    if trials.ctrl.four(n,5) == 2;
        count = count + 1;
        paramet.ctrl.four(count,1) = trials.ctrl.four(n,1);
        paramet.ctrl.four(count,2) = count;
    end
end
paramet.ctrl.all = [paramet.ctrl.one; paramet.ctrl.two; paramet.ctrl.three; paramet.ctrl.four];
paramet.ctrl.all = sortrows(paramet.ctrl.all,1);




% now create the relevant data for the design matrix
% all correct exp cue
design.cue_cor_X = [trials.correct_exp(:,9) paramet.exp.all(:,2)];
% correct exp cue which were not preceded by an incorrect trial
design.cue_cor_X_22 = [trials.exp.all_22(:,9) trials.exp.all_22(:,17)];
% correct control cue
design.cue_cor_C = [trials.correct_ctrl(:,9) paramet.ctrl.all(:,2)];
altdesign.targ.all = spike.targ(1,:)';
altdesign.feed.all = spike.feed(1,:)';
altdesign.incor_miss_cue = sortrows([trials.incorrect_exp(:,9); trials.missed_all(:,9)],1);
% all incorrect and missed cues, plus cues on correct trials but preceded by incorrect trial. All targets and feedback for missed trials.
design.incorCue_missAll = sortrows([trials.incorrect_exp(:,9); trials.missed_all(:,9); trials.missed_all(:,10);trials.missed_all(:,11)],1);
design.incorCue12_missAll = sortrows([trials.incorrect_exp(:,9); trials.exp.all_12(:,9); trials.missed_all(:,9); trials.missed_all(:,10);trials.missed_all(:,11)],1);
altdesign.rest = [spike.rest(:,1) spike.rest(:,3)];
altdesign.calibrate = [spike.cal(:,1) spike.cal(:,3)];
% rest and calibration combined
design.rest_cal_comb = [spike.rest(:,1) spike.rest(:,3)+spike.cal(:,3)];

% now make variants if I want to break down the target and feedback
% regressors further
altdesign.targ.mis = spike.targ(1,find(results(:,7) == 0))';
% target events for non-missed trials
design.targ.one = spike.targ(1,find(results(:,7) == 1))';
design.targ.two = spike.targ(1,find(results(:,7) == 2))';
design.targ.thr = spike.targ(1,find(results(:,7) == 3))';
altdesign.feed.mis = spike.feed(1,find(results(:,7) == 0))';
% feedback events for non-missed trials
design.feed.one = spike.feed(1,find(results(:,7) == 1))';
design.feed.two = spike.feed(1,find(results(:,7) == 2))';
design.feed.thr = spike.feed(1,find(results(:,7) == 3))';

% transpose for ease of copyinh
pupil_bar = pupil_bar';

save design design