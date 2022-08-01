clear all
addpath /usr/local/apps/psycapps/spm/spm12-r7487;

% check the bfs
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-301/output/1st_level');
load('SPM.mat');
% set the window length and work out how many arbitrary units equate to 1
% second
window = SPM.xBF.length;
sec = length(SPM.xBF.bf(:,1)) ./ window;
% isolate the basis functions
hrf = SPM.xBF.bf;
clear SPM

% navigate to the 2nd level folder and load the SPM file
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/covariate_version');
load('SPM.mat');
mkdir('images');

% create 3 regressors with the basis function flipped both ways
for n = 1:length(hrf(1,:));
    run(1:length(hrf(:,1)),n) = hrf(:,n) .* -1;
    run(length(hrf(:,1)) + 1:length(hrf(:,1)) .* 2,n) = hrf(:,n);
end

% load locations where we find significance
% young only exp x control
main_y = niftiread('main_y_pfc.nii');
para_y = niftiread('para_y_pfc.nii');
% old only exp x control
main_o = niftiread('main_o_pfc.nii');
para_o = niftiread('para_o_pfc.nii');
% age x condition interaction
main = niftiread('main_pfc.nii');
para = niftiread('para_pfc.nii');

% load the con files for young x main reg
rxy.one = spm_vol('beta_0013.nii');
[rxy.a,rxy.XYZ1]=spm_read_vols(rxy.one);
rxy.two = spm_vol('beta_0014.nii');
[rxy.b,rxy.XYZ2]=spm_read_vols(rxy.two);
rxy.thr = spm_vol('beta_0015.nii');
[rxy.c,rxy.XYZ3]=spm_read_vols(rxy.thr);

% load the con files for young x para reg
pxy.one = spm_vol('beta_0016.nii');
[pxy.a,pxy.XYZ1]=spm_read_vols(pxy.one);
pxy.two = spm_vol('beta_0017.nii');
[pxy.b,pxy.XYZ2]=spm_read_vols(pxy.two);
pxy.thr = spm_vol('beta_0018.nii');
[pxy.c,pxy.XYZ3]=spm_read_vols(pxy.thr);

% load the con files for young c main reg
rcy.one = spm_vol('beta_0019.nii');
[rcy.a,rcy.XYZ1]=spm_read_vols(rcy.one);
rcy.two = spm_vol('beta_0020.nii');
[rcy.b,rcy.XYZ2]=spm_read_vols(rcy.two);
rcy.thr = spm_vol('beta_0021.nii');
[rcy.c,rcy.XYZ3]=spm_read_vols(rcy.thr);

% load the con files for young c para reg
pcy.one = spm_vol('beta_0022.nii');
[pcy.a,pcy.XYZ1]=spm_read_vols(pcy.one);
pcy.two = spm_vol('beta_0023.nii');
[pcy.b,pcy.XYZ2]=spm_read_vols(pcy.two);
pcy.thr = spm_vol('beta_0024.nii');
[pcy.c,pcy.XYZ3]=spm_read_vols(pcy.thr);

% load the con files for old x main reg
rxo.one = spm_vol('beta_0001.nii');
[rxo.a,rxo.XYZ1]=spm_read_vols(rxo.one);
rxo.two = spm_vol('beta_0002.nii');
[rxo.b,rxo.XYZ2]=spm_read_vols(rxo.two);
rxo.thr = spm_vol('beta_0003.nii');
[rxo.c,rxo.XYZ3]=spm_read_vols(rxo.thr);

% load the con files for old x para reg
pxo.one = spm_vol('beta_0004.nii');
[pxo.a,pxo.XYZ1]=spm_read_vols(pxo.one);
pxo.two = spm_vol('beta_0005.nii');
[pxo.b,pxo.XYZ2]=spm_read_vols(pxo.two);
pxo.thr = spm_vol('beta_0006.nii');
[pxo.c,pxo.XYZ3]=spm_read_vols(pxo.thr);

% load the con files for old c main reg
positions.main_y = find(main_y > 0);

rco.one = spm_vol('beta_0007.nii');
[rco.a,rco.XYZ1]=spm_read_vols(rco.one);
rco.two = spm_vol('beta_0008.nii');
[rco.b,rco.XYZ2]=spm_read_vols(rco.two);
rco.thr = spm_vol('beta_0009.nii');
[rco.c,rco.XYZ3]=spm_read_vols(rco.thr);

% load the con files for old c para reg
pco.one = spm_vol('beta_0010.nii');
[pco.a,pco.XYZ1]=spm_read_vols(pco.one);
pco.two = spm_vol('beta_0011.nii');
[pco.b,pco.XYZ2]=spm_read_vols(pco.two);
pco.thr = spm_vol('beta_0012.nii');
[pco.c,pco.XYZ3]=spm_read_vols(pco.thr);

% load up significant positions
positions.main = find(main > 0);
positions.main_y = find(main_y > 0);
positions.main_o = find(main_o > 0);

cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/covariate_version/images');
mkdir('young_pfc');
mkdir('age_comp_pfc');

cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/covariate_version/images/age_comp_pfc');


clear n
% work through the main effects
for n = 1:length(positions.main);
    % check if there is a significant effect within each age group
    clear sig.young
    clear sig.old
    if length(find(positions.main_y == positions.main(n))) == 1;
        sig.young = 1
    else sig.young = 0;
    end
    if length(find(positions.main_o == positions.main(n))) == 1;
        sig.old = 1
    else sig.old = 0;
    end
        
    clear output
    clear full
    output(:,1) = hrf(:,1) .* rxy.a(positions.main(n));
    output(:,2) = hrf(:,2) .* rxy.b(positions.main(n));
    output(:,3) = hrf(:,3) .* rxy.c(positions.main(n));
    full(:,1) = output(:,1) + output(:,2) + output(:,3);
    output(:,4) = hrf(:,1) .* rcy.a(positions.main(n));
    output(:,5) = hrf(:,2) .* rcy.b(positions.main(n));
    output(:,6) = hrf(:,3) .* rcy.c(positions.main(n));
    full(:,2) = output(:,4) + output(:,5) + output(:,6);
    output(:,7) = hrf(:,1) .* rxo.a(positions.main(n));
    output(:,8) = hrf(:,2) .* rxo.b(positions.main(n));
    output(:,9) = hrf(:,3) .* rxo.c(positions.main(n));
    full(:,3) = output(:,7) + output(:,8) + output(:,9);
    output(:,10) = hrf(:,1) .* rco.a(positions.main(n));
    output(:,11) = hrf(:,2) .* rco.b(positions.main(n));
    output(:,12) = hrf(:,3) .* rco.c(positions.main(n));
    full(:,4) = output(:,10) + output(:,11) + output(:,12);
    
    clear maxi
    maxi(1) = max(max(full)) + (abs(max(max(full))) ./ 10);
    maxi(2) = min(min(full)) - (abs(min(min(full))) ./ 10);
    
    c = figure(1);
    set(c, 'Visible', 'off');
    set(gcf,'Position',[60 60 1600 800]);
    subplot(1,2,1);
    plot(full(:,1));
    hold on
    plot(full(:,3));
    xbins = 0: (2*sec): (sec*window);
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
    ylim([maxi(2) maxi(1)]);
    xlabel('Time (secs)');
    ylabel('Amplitude');
    legend('young exp','old exp');
    title(strcat('x = ',num2str(rxy.XYZ1(1,positions.main(n))),', y = ',num2str(rxy.XYZ1(2,positions.main(n))),', z = ',num2str(rxy.XYZ1(3,positions.main(n)))));
    hold off
    
    subplot(1,2,2);
    plot(full(:,2));
    hold on
    plot(full(:,4));
    xbins = 0: (2*sec): (sec*window);
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
    xlabel('Time (secs)');
    ylabel('Amplitude');
    ylim([maxi(2) maxi(1)]);
    legend('young con','old con');
    if sig.young == 1 & sig.old == 1;
        title('Exp x Control effect significant in both age groups');
    elseif sig.young == 1 & sig.old == 0;
        title('Exp x Control effect significant in young only');
    elseif sig.young == 0 & sig.old == 1;
        title('Exp x Control effect significant in old only');
    elseif sig.young == 0 & sig.old == 0;
        title('Exp x Control effect not significant in either age group');
    end
    jpgName = strcat('main_reg',num2str(n),'.jpg');
    saveas(c,sprintf(jpgName,1));
    hold off
end


% load up significant positions
positions.para = find(para > 0);
positions.para_y = find(para_y > 0);
positions.para_o = find(para_o > 0);
clear n
% work through the main effects
for n = 1:length(positions.para);
    % check if there is a significant effect within each age group
    clear sig.young
    clear sig.old
    if length(find(positions.para_y == positions.para(n))) == 1;
        sig.young = 1
    else sig.young = 0;
    end
    if length(find(positions.para_o == positions.para(n))) == 1;
        sig.old = 1
    else sig.old = 0;
    end
    
    clear output
    clear full
    output(:,1) = run(:,1) .* pxy.a(positions.para(n));
    output(:,2) = run(:,2) .* pxy.b(positions.para(n));
    output(:,3) = run(:,3) .* pxy.c(positions.para(n));
    full(:,1) = output(:,1) + output(:,2) + output(:,3);
    output(:,4) = run(:,1) .* pcy.a(positions.para(n));
    output(:,5) = run(:,2) .* pcy.b(positions.para(n));
    output(:,6) = run(:,3) .* pcy.c(positions.para(n));
    full(:,2) = output(:,4) + output(:,5) + output(:,6);
    output(:,7) = run(:,1) .* pxo.a(positions.para(n));
    output(:,8) = run(:,2) .* pxo.b(positions.para(n));
    output(:,9) = run(:,3) .* pxo.c(positions.para(n));
    full(:,3) = output(:,7) + output(:,8) + output(:,9);
    output(:,10) = run(:,1) .* pco.a(positions.para(n));
    output(:,11) = run(:,2) .* pco.b(positions.para(n));
    output(:,12) = run(:,3) .* pco.c(positions.para(n));
    full(:,4) = output(:,10) + output(:,11) + output(:,12);
    
    clear maxi
    maxi(1) = max(max(full)) + (abs(max(max(full))) ./ 10);
    maxi(2) = min(min(full)) - (abs(min(min(full))) ./ 10);
    
    c = figure(2);
    set(c, 'Visible', 'off');
    set(gcf,'Position',[60 60 1600 800]);
    subplot(2,2,1);
    plot(full(:,1));
    hold on
    plot(full(:,3));
    xbins = 0: (4*sec): (sec*(window .* 2));
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,4));
    ylim([maxi(2) maxi(1)]);
    xlabel('Time (secs)');
    ylabel('Amplitude');
    legend('young exp','old exp');
    title(strcat('x = ',num2str(pxy.XYZ1(1,positions.para(n))),', y = ',num2str(pxy.XYZ1(2,positions.para(n))),', z = ',num2str(pxy.XYZ1(3,positions.para(n)))));
    hold off
    
    subplot(2,2,2);
    plot(full(:,2));
    hold on
    plot(full(:,4));
    xbins = 0: (4*sec): (sec*(window .* 2));
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,4));
    xlabel('Time (secs)');
    ylabel('Amplitude');
    ylim([maxi(2) maxi(1)]);    
    legend('young con','old con');
    if sig.young == 1 & sig.old == 1;
            title('Exp x Control effect significant in both age groups');
        elseif sig.young == 1 & sig.old == 0;
            title('Exp x Control effect significant in young only');
        elseif sig.young == 0 & sig.old == 1;
            title('Exp x Control effect significant in old only');
        elseif sig.young == 0 & sig.old == 0;
            title('Exp x Control effect not significant in either age group');
    end
    hold off
    
    
    % now load up the main response for comparison
    clear output
    clear full
    output(:,1) = hrf(:,1) .* rxy.a(positions.para(n));
    output(:,2) = hrf(:,2) .* rxy.b(positions.para(n));
    output(:,3) = hrf(:,3) .* rxy.c(positions.para(n));
    full(:,1) = output(:,1) + output(:,2) + output(:,3);
    output(:,4) = hrf(:,1) .* rcy.a(positions.para(n));
    output(:,5) = hrf(:,2) .* rcy.b(positions.para(n));
    output(:,6) = hrf(:,3) .* rcy.c(positions.para(n));
    full(:,2) = output(:,4) + output(:,5) + output(:,6);
    output(:,7) = hrf(:,1) .* rxo.a(positions.para(n));
    output(:,8) = hrf(:,2) .* rxo.b(positions.para(n));
    output(:,9) = hrf(:,3) .* rxo.c(positions.para(n));
    full(:,3) = output(:,7) + output(:,8) + output(:,9);
    output(:,10) = hrf(:,1) .* rco.a(positions.para(n));
    output(:,11) = hrf(:,2) .* rco.b(positions.para(n));
    output(:,12) = hrf(:,3) .* rco.c(positions.para(n));
    full(:,4) = output(:,10) + output(:,11) + output(:,12);
    
    clear maxi
    maxi(1) = max(max(full)) + (abs(max(max(full))) ./ 10);
    maxi(2) = min(min(full)) - (abs(min(min(full))) ./ 10);
    
    subplot(2,2,3);
    plot(full(:,1));
    hold on
    plot(full(:,3));
    xbins = 0: (2*sec): (sec*window);
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
    ylim([maxi(2) maxi(1)]);
    xlabel('Time (secs)');
    ylabel('Amplitude');
    legend('young exp','old exp');
    title(strcat('x = ',num2str(rxy.XYZ1(1,positions.para(n))),', y = ',num2str(rxy.XYZ1(2,positions.para(n))),', z = ',num2str(rxy.XYZ1(3,positions.para(n)))));
    hold off
    
    subplot(2,2,4);
    plot(full(:,2));
    hold on
    plot(full(:,4));
    xbins = 0: (2*sec): (sec*window);
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
    xlabel('Time (secs)');
    ylabel('Amplitude');
    ylim([maxi(2) maxi(1)]);
    legend('young con','old con');
    title(strcat('x = ',num2str(rxy.XYZ1(1,positions.para(n))),', y = ',num2str(rxy.XYZ1(2,positions.para(n))),', z = ',num2str(rxy.XYZ1(3,positions.para(n)))));  
    jpgName = strcat('para_reg',num2str(n),'.jpg');
    saveas(c,sprintf(jpgName,1));
    hold off
    
end




% look at young only
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/covariate_version/images/young_pfc');
positions.main_y = find(main_y > 0);


clear n
% work through the main effects
for n = 1:length(positions.main_y);
    clear output
    clear full
    output(:,1) = hrf(:,1) .* rxy.a(positions.main_y(n));
    output(:,2) = hrf(:,2) .* rxy.b(positions.main_y(n));
    output(:,3) = hrf(:,3) .* rxy.c(positions.main_y(n));
    full(:,1) = output(:,1) + output(:,2) + output(:,3);
    output(:,4) = hrf(:,1) .* rcy.a(positions.main_y(n));
    output(:,5) = hrf(:,2) .* rcy.b(positions.main_y(n));
    output(:,6) = hrf(:,3) .* rcy.c(positions.main_y(n));
    full(:,2) = output(:,4) + output(:,5) + output(:,6);
        
    c = figure(3);
    set(c, 'Visible', 'off');
    set(gcf,'Position',[60 60 1200 800]);   
    plot(full(:,1));
    hold on
    plot(full(:,2));
    xbins = 0: (2*sec): (sec*window);
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
    xlabel('Time (secs)');
    ylabel('Amplitude');
    legend('young exp','young con');
    title(strcat('x = ',num2str(rxy.XYZ1(1,positions.main_y(n))),', y = ',num2str(rxy.XYZ1(2,positions.main_y(n))),', z = ',num2str(rxy.XYZ1(3,positions.main_y(n)))));
    jpgName = strcat('main_reg',num2str(n),'.jpg');
    saveas(c,sprintf(jpgName,1));
    hold off
end


positions.para_y = find(para_y > 0);
clear n
% work through the main effects
for n = 1:length(positions.para_y);
    clear output
    clear full
    output(:,1) = run(:,1) .* pxy.a(positions.para_y(n));
    output(:,2) = run(:,2) .* pxy.b(positions.para_y(n));
    output(:,3) = run(:,3) .* pxy.c(positions.para_y(n));
    full(:,1) = output(:,1) + output(:,2) + output(:,3);
    output(:,4) = run(:,1) .* pcy.a(positions.para_y(n));
    output(:,5) = run(:,2) .* pcy.b(positions.para_y(n));
    output(:,6) = run(:,3) .* pcy.c(positions.para_y(n));
    full(:,2) = output(:,4) + output(:,5) + output(:,6);
    
    c = figure(4);
    subplot(1,2,1);
    set(c, 'Visible', 'off');
    set(gcf,'Position',[60 60 1200 800]);    
    plot(full(:,1));
    hold on
    plot(full(:,2));
    xbins = 0: (4*sec): (sec*(window .* 2));
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,4));
    xlabel('Time (secs)');
    ylabel('Amplitude');
    legend('young exp','young con');
    title(strcat('x = ',num2str(pxy.XYZ1(1,positions.para_y(n))),', y = ',num2str(pxy.XYZ1(2,positions.para_y(n))),', z = ',num2str(pxy.XYZ1(3,positions.para_y(n)))));
    hold off
    
    
    clear output
    clear full
    output(:,1) = hrf(:,1) .* rxy.a(positions.para_y(n));
    output(:,2) = hrf(:,2) .* rxy.b(positions.para_y(n));
    output(:,3) = hrf(:,3) .* rxy.c(positions.para_y(n));
    full(:,1) = output(:,1) + output(:,2) + output(:,3);
    output(:,4) = hrf(:,1) .* rcy.a(positions.para_y(n));
    output(:,5) = hrf(:,2) .* rcy.b(positions.para_y(n));
    output(:,6) = hrf(:,3) .* rcy.c(positions.para_y(n));
    full(:,2) = output(:,4) + output(:,5) + output(:,6);
    
    subplot(1,2,2);
    plot(full(:,1));
    hold on
    plot(full(:,2));
    xbins = 0: (2*sec): (sec*window);
    set(gca, 'xtick', xbins);
    % set the x axis to seconds, and round up to the nearest second (2 decimal
    % places)
    xt = get(gca, 'XTick');                                 
    set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
    xlabel('Time (secs)');
    ylabel('Amplitude');
    legend('young exp','young con');
    title(strcat('x = ',num2str(rxy.XYZ1(1,positions.para_y(n))),', y = ',num2str(rxy.XYZ1(2,positions.para_y(n))),', z = ',num2str(rxy.XYZ1(3,positions.para_y(n)))));
    jpgName = strcat('para_reg',num2str(n),'.jpg');
    saveas(c,sprintf(jpgName,1));
    hold off
    
end