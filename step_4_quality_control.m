clear all

addpath /usr/local/apps/psycapps/spm/spm12-r7487

%%%%%%%%%%%%%%%%%%
% EDIT THESE %
subject = ('342');
%%%%%%%%%%%%%%%%%%

cd(strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject,'/func'));

path = ('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/quality_control');

path2 = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',subject);

rpara = strcat('rp_fRH_',subject,'_EMAR.txt');

load('design.mat');

% select the file folder
fileFolder = fullfile(pwd);
% find all files starting with the wildcard (remember if asterisk either
% side this will find it anywhere)
files = dir(fullfile(fileFolder, 'fRH_*'));
% save these names in a separate folder
fileNames = {files.name};

% isolate and read the nifti file
fname = fileNames{2};
% save this as a data matrix with n as the 4th dimension
a = niftiread(fname);


% get volumes, we have 4D data (64 x 64 x 50 x n), here I calculate the mean slice values (1:50) at volume n
clear v
for v = 1:length(a(1,1,1,:));
    clear s
    for s = 1:length(a(1,1,:,1));
        slicemean(s,v) = mean(mean(a(:,:,s,v)));
    end
end


% looks at each value in slicemean one volume at a time, and subtracts the mean of that volume,
% to normalise the scores (so the mean value = 0)
clear v
for v = 1:length(slicemean(1,:));
    slicemean_normV(:,v) = slicemean(:,v) - mean(slicemean(:,v));
end

% repeats normalising slices
for s = 1:length(slicemean(:,1));
    slicemean_normS(s,:) = slicemean(s,:) - mean(slicemean(s,:));
end

% fast fourier transform
slicemean_fft = (abs(fft(slicemean_normS')))';

% looks at each slice, and calculates change from one volume to the next.
% Then calculates the maximum shift for this subject
clear n
for n = 1:length(slicemean(:,1));
    clear m
    for m = 2:length(slicemean(1,:));
        measure.temp.shift.data(n,m-1) = abs(slicemean(n,m) - slicemean(n,m-1));
    end
    measure.temp.cov.data(n) = std(slicemean(n,:)) ./ mean(slicemean(n,:));
end
measure.temp.shift.max = max(max(measure.temp.shift.data));
measure.temp.cov.max = max(measure.temp.cov.data);

% does the same over slices within volumes
clear n
for n = 1:length(slicemean(1,:));
    clear m
    for m = 2:length(slicemean(:,1));
        measure.spat.shift.data(m-1,n) = abs(slicemean(m,n) - slicemean(m-1,n));
    end
    measure.spat.cov.data(n) = std(slicemean(:,n)) ./ mean(slicemean(:,n));
end
measure.spat.shift.max = max(max(measure.spat.shift.data));
measure.spat.cov.max = max(measure.spat.cov.data);

% save the relevant
cd(path);
b = figure(1);
set(b, 'Visible', 'off');

subplot(3,1,1);
imagesc(slicemean_normV);
hold on
colorbar
title('slicemean normalised volumes');
xlabel('volumes');
ylabel('slices');
hold off

subplot(3,1,2);
imagesc(slicemean_normS);
hold on
colorbar
title('slicemean normalised slices');
xlabel('volumes');
ylabel('slices');
hold off

subplot(3,1,3);
imagesc(slicemean_fft);
hold on
colorbar
title('fast fourier transformation');
xlabel('volumes');
ylabel('slices');
hold off

jpgName = strcat('quality_control_sub_', subject,'.jpg');
saveas(b,sprintf(jpgName,1));

cd(path2)
mkdir quality_control
cd(strcat(path2,'/quality_control'));
measure.all = [measure.temp.shift.max measure.temp.cov.max measure.spat.shift.max ...
    measure.spat.cov.max];

save output measure



cd(strcat(path2,'/func'));

% head motion
cd(strcat(path2,'/func'));
rp = importdata(rpara);

hm.x = rp(:,1);
hm.y = rp(:,2);
hm.z = rp(:,3);
hm.pitch = rp(:,4);
hm.roll = rp(:,5);
hm.yaw = rp(:,6);

% now work out the shaded areas to denote break periods/calibrations
x = [round(design.rest_cal_comb(1,1)./2), round(design.rest_cal_comb(2,1)./2), round(design.rest_cal_comb(3,1)./2), round(design.rest_cal_comb(4,1)./2), round(design.rest_cal_comb(5,1)./2);...
    round((design.rest_cal_comb(1,1)+design.rest_cal_comb(1,2))./2), round((design.rest_cal_comb(2,1)+design.rest_cal_comb(2,2))./2), round((design.rest_cal_comb(3,1)+design.rest_cal_comb(3,2))./2), round((design.rest_cal_comb(4,1)+design.rest_cal_comb(4,2))./2), round((design.rest_cal_comb(5,1)+design.rest_cal_comb(5,2))./2); ...
    round((design.rest_cal_comb(1,1)+design.rest_cal_comb(1,2))./2), round((design.rest_cal_comb(2,1)+design.rest_cal_comb(2,2))./2), round((design.rest_cal_comb(3,1)+design.rest_cal_comb(3,2))./2), round((design.rest_cal_comb(4,1)+design.rest_cal_comb(4,2))./2), round((design.rest_cal_comb(5,1)+design.rest_cal_comb(5,2))./2); ... 
    round(design.rest_cal_comb(1,1)./2), round(design.rest_cal_comb(2,1)./2), round(design.rest_cal_comb(3,1)./2), round(design.rest_cal_comb(4,1)./2), round(design.rest_cal_comb(5,1)./2)];
low.x = min([min(hm.x) min(hm.y) min(hm.z)]);
low.r = min([min(hm.pitch) min(hm.roll) min(hm.yaw)]);
high.x = max([max(hm.x) max(hm.y) max(hm.z)]);
high.r = max([max(hm.pitch) max(hm.roll) max(hm.yaw)]);
y_x = [low.x low.x low.x low.x low.x; low.x low.x low.x low.x low.x; high.x high.x high.x high.x high.x; high.x high.x high.x high.x high.x];
y_r = [low.r low.r low.r low.r low.r; low.r low.r low.r low.r low.r; high.r high.r high.r high.r high.r; high.r high.r high.r high.r high.r];

cd(path);

c = figure(2);
set(c, 'Visible', 'off');

subplot(2,1,1)
plot(hm.x);
hold on
plot(hm.y);
plot(hm.z);
xlabel('scans');
ylabel('mm');
ylim([low.x high.x]);
xlim([0 n+250]);
patch(x,y_x,'red','FaceAlpha',.25,'EdgeColor','none');
legend('x','y','z','breaks');
hold off
subplot(2,1,2)
plot(hm.pitch);
hold on
plot(hm.roll);
plot(hm.yaw);
xlabel('scans');
ylabel('radians');
ylim([low.r high.r]);
xlim([0 n+250]);
patch(x,y_r,'red','FaceAlpha',.25,'EdgeColor','none');
legend('pitch','roll','yaw','breaks');
hold off

jpgName = strcat('realignment_parameters_sub_', subject,'.jpg');
saveas(c,sprintf(jpgName,1));


% calculate range
hm.range(1,1) = range(hm.x);
% calculate scan to scan shift
clear run
for n = 2:length(hm.x);
    run(n-1) = hm.x(n) - hm.x(n-1);
end
hm.jump(1,1) = max(abs(run));

hm.range(1,2) = range(hm.y);
clear run
for n = 2:length(hm.y);
    run(n-1) = hm.y(n) - hm.y(n-1);
end
hm.jump(1,2) = max(abs(run));

hm.range(1,3) = range(hm.z);
clear run
for n = 2:length(hm.z);
    run(n-1) = hm.z(n) - hm.z(n-1);
end
hm.jump(1,3) = max(abs(run));

hm.range(1,4) = range(hm.pitch);
clear run
for n = 2:length(hm.pitch);
    run(n-1) = hm.pitch(n) - hm.pitch(n-1);
end
hm.jump(1,4) = max(abs(run));

hm.range(1,5) = range(hm.roll);
clear run
for n = 2:length(hm.roll);
    run(n-1) = hm.roll(n) - hm.roll(n-1);
end
hm.jump(1,5) = max(abs(run));

hm.range(1,6) = range(hm.yaw);
clear run
for n = 2:length(hm.yaw);
    run(n-1) = hm.yaw(n) - hm.yaw(n-1);
end
hm.jump(1,6) = max(abs(run));
