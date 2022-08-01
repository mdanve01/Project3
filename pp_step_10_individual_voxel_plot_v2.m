% select region (cer, hip or pfc)
region = "hip";

% load up the main files if needed
try 
    max(max(max(main_int)));
catch
    clear all
    addpath /usr/local/apps/psycapps/spm/spm12-r7487;
    
    % select region (cer or pfc)
    region = "hip";
    
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

    % load locations where we find significance
    cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/original');
    
    % create 3 regressors with the basis function flipped both ways
    for n = 1:length(hrf(1,:));
        run(1:length(hrf(:,1)),n) = hrf(:,n) .* -1;
        run(length(hrf(:,1)) + 1:length(hrf(:,1)) .* 2,n) = hrf(:,n);
    end
    
    %%%%%% UPDATE %%%%%%
    
    % ORIGINAL
    
    % interaction
    main_int = niftiread(strcat('main_int_',region,'.nii'));
    % young only exp vs control
    main_y = niftiread(strcat('main_y_',region,'.nii'));
    % old only exp vs control
    main_o = niftiread(strcat('main_o_',region,'.nii'));
    % experimental only young vs old
    main_x = niftiread(strcat('main_Xage_',region,'.nii'));
    % control only young vs old
    main_c = niftiread(strcat('main_Cage_',region,'.nii'));
    
    % parametric interaction
    para_int = niftiread(strcat('para_int_',region,'.nii'));
    % young only exp vs control
    para_y = niftiread(strcat('para_y_',region,'.nii'));
    % old only exp vs control
    para_o = niftiread(strcat('para_o_',region,'.nii'));
    % experimental only young vs old
    para_x = niftiread(strcat('para_Xage_',region,'.nii'));
    % control only young vs old
    para_c = niftiread(strcat('para_Cage_',region,'.nii'));
    
    % all the single effects
    single_ox = niftiread(strcat('ox_',region,'.nii'));
    single_oxp = niftiread(strcat('oxp_',region,'.nii'));
    single_oc = niftiread(strcat('oc_',region,'.nii'));
    single_ocp = niftiread(strcat('ocp_',region,'.nii'));
    single_yx = niftiread(strcat('yx_',region,'.nii'));
    single_yxp = niftiread(strcat('yxp_',region,'.nii'));
    single_yc = niftiread(strcat('yc_',region,'.nii'));
    single_ycp = niftiread(strcat('ycp_',region,'.nii'));
  
    
    
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
    
    % COVARIATE
    cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/covariate');

    % interaction
    cov_main_int = niftiread(strcat('cov_main_int_',region,'.nii'));
    % young only exp vs control
    cov_main_y = niftiread(strcat('cov_main_y_',region,'.nii'));
    % old only exp vs control
    cov_main_o = niftiread(strcat('cov_main_o_',region,'.nii'));
    % experimental only young vs old
    cov_main_x = niftiread(strcat('cov_main_Xage_',region,'.nii'));
    % control only young vs old
    cov_main_c = niftiread(strcat('cov_main_Cage_',region,'.nii'));
    
    % cov_parametric interaction
    cov_para_int = niftiread(strcat('cov_para_int_',region,'.nii'));
    % young only exp vs control
    cov_para_y = niftiread(strcat('cov_para_y_',region,'.nii'));
    % old only exp vs control
    cov_para_o = niftiread(strcat('cov_para_o_',region,'.nii'));
    % experimental only young vs old
    cov_para_x = niftiread(strcat('cov_para_Xage_',region,'.nii'));
    % control only young vs old
    cov_para_c = niftiread(strcat('cov_para_Cage_',region,'.nii'));
    
    % all the cov_single effects
    cov_single_ox = niftiread(strcat('ox_',region,'.nii'));
    cov_single_oxp = niftiread(strcat('oxp_',region,'.nii'));
    cov_single_oc = niftiread(strcat('oc_',region,'.nii'));
    cov_single_ocp = niftiread(strcat('ocp_',region,'.nii'));
    cov_single_yx = niftiread(strcat('yx_',region,'.nii'));
    cov_single_yxp = niftiread(strcat('yxp_',region,'.nii'));
    cov_single_yc = niftiread(strcat('yc_',region,'.nii'));
    cov_single_ycp = niftiread(strcat('ycp_',region,'.nii'));
    
    % load the con files for young x main reg
    cov_rxy.one = spm_vol('beta_0013.nii');
    [cov_rxy.a,cov_rxy.XYZ1]=spm_read_vols(cov_rxy.one);
    cov_rxy.two = spm_vol('beta_0014.nii');
    [cov_rxy.b,cov_rxy.XYZ2]=spm_read_vols(cov_rxy.two);
    cov_rxy.thr = spm_vol('beta_0015.nii');
    [cov_rxy.c,cov_rxy.XYZ3]=spm_read_vols(cov_rxy.thr);

    % load the con files for young x para reg
    cov_pxy.one = spm_vol('beta_0016.nii');
    [cov_pxy.a,cov_pxy.XYZ1]=spm_read_vols(cov_pxy.one);
    cov_pxy.two = spm_vol('beta_0017.nii');
    [cov_pxy.b,cov_pxy.XYZ2]=spm_read_vols(cov_pxy.two);
    cov_pxy.thr = spm_vol('beta_0018.nii');
    [cov_pxy.c,cov_pxy.XYZ3]=spm_read_vols(cov_pxy.thr);

    % load the con files for young c main reg
    cov_rcy.one = spm_vol('beta_0019.nii');
    [cov_rcy.a,cov_rcy.XYZ1]=spm_read_vols(cov_rcy.one);
    cov_rcy.two = spm_vol('beta_0020.nii');
    [cov_rcy.b,cov_rcy.XYZ2]=spm_read_vols(cov_rcy.two);
    cov_rcy.thr = spm_vol('beta_0021.nii');
    [cov_rcy.c,cov_rcy.XYZ3]=spm_read_vols(cov_rcy.thr);

    % load the con files for young c para reg
    cov_pcy.one = spm_vol('beta_0022.nii');
    [cov_pcy.a,cov_pcy.XYZ1]=spm_read_vols(cov_pcy.one);
    cov_pcy.two = spm_vol('beta_0023.nii');
    [cov_pcy.b,cov_pcy.XYZ2]=spm_read_vols(cov_pcy.two);
    cov_pcy.thr = spm_vol('beta_0024.nii');
    [cov_pcy.c,cov_pcy.XYZ3]=spm_read_vols(cov_pcy.thr);

    % load the con files for old x main reg
    cov_rxo.one = spm_vol('beta_0001.nii');
    [cov_rxo.a,cov_rxo.XYZ1]=spm_read_vols(cov_rxo.one);
    cov_rxo.two = spm_vol('beta_0002.nii');
    [cov_rxo.b,cov_rxo.XYZ2]=spm_read_vols(cov_rxo.two);
    cov_rxo.thr = spm_vol('beta_0003.nii');
    [cov_rxo.c,cov_rxo.XYZ3]=spm_read_vols(cov_rxo.thr);

    % load the con files for old x para reg
    cov_pxo.one = spm_vol('beta_0004.nii');
    [cov_pxo.a,cov_pxo.XYZ1]=spm_read_vols(cov_pxo.one);
    cov_pxo.two = spm_vol('beta_0005.nii');
    [cov_pxo.b,cov_pxo.XYZ2]=spm_read_vols(cov_pxo.two);
    cov_pxo.thr = spm_vol('beta_0006.nii');
    [cov_pxo.c,cov_pxo.XYZ3]=spm_read_vols(cov_pxo.thr);

    % load the con files for old c main reg
    cov_rco.one = spm_vol('beta_0007.nii');
    [cov_rco.a,cov_rco.XYZ1]=spm_read_vols(cov_rco.one);
    cov_rco.two = spm_vol('beta_0008.nii');
    [cov_rco.b,cov_rco.XYZ2]=spm_read_vols(cov_rco.two);
    cov_rco.thr = spm_vol('beta_0009.nii');
    [cov_rco.c,cov_rco.XYZ3]=spm_read_vols(cov_rco.thr);

    % load the con files for old c para reg
    cov_pco.one = spm_vol('beta_0010.nii');
    [cov_pco.a,cov_pco.XYZ1]=spm_read_vols(cov_pco.one);
    cov_pco.two = spm_vol('beta_0011.nii');
    [cov_pco.b,cov_pco.XYZ2]=spm_read_vols(cov_pco.two);
    cov_pco.thr = spm_vol('beta_0012.nii');
    [cov_pco.c,cov_pco.XYZ3]=spm_read_vols(cov_pco.thr);
end

cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/original');


% load the variables of interest
x = 22.5;
y = -31.5;
z = -15;

% find the coordinate of interest
clear coord
coord = find(rxy.XYZ1(1,:) == x & rxy.XYZ1(2,:) == y & rxy.XYZ1(3,:) == z);

% check if contrasts are significant
clear sig
if main_int(coord) > 0;
    sig.int = 1
else sig.int = 0;
end
if main_y(coord) > 0;
    sig.young = 1
else sig.young = 0;
end
if main_o(coord) > 0;
    sig.old = 1
else sig.old = 0;
end
if main_x(coord) > 0;
    sig.experimental = 1
else sig.experimental = 0;
end
if main_c(coord) > 0;
    sig.control = 1
else sig.control = 0;
end
if para_int(coord) > 0;
    sig.Pint = 1
else sig.Pint = 0;
end
if para_y(coord) > 0;
    sig.Pyoung = 1
else sig.Pyoung = 0;
end
if para_o(coord) > 0;
    sig.Pold = 1
else sig.Pold = 0;
end
if para_x(coord) > 0;
    sig.Pexperimental = 1
else sig.Pexperimental = 0;
end
if para_c(coord) > 0;
    sig.Pcontrol = 1
else sig.Pcontrol = 0;
end
if single_ox(coord) > 0;
    sig.single_ox = 1
else sig.single_ox = 0;
end
if single_oxp(coord) > 0;
    sig.single_oxp = 1
else sig.single_oxp = 0;
end
if single_oc(coord) > 0;
    sig.single_oc = 1
else sig.single_oc = 0;
end
if single_ocp(coord) > 0;
    sig.single_ocp = 1
else sig.single_ocp = 0;
end
if single_yx(coord) > 0;
    sig.single_yx = 1
else sig.single_yx = 0;
end
if single_yxp(coord) > 0;
    sig.single_yxp = 1
else sig.single_yxp = 0;
end
if single_yc(coord) > 0;
    sig.single_yc = 1
else sig.single_yc = 0;
end
if single_ycp(coord) > 0;
    sig.single_ycp = 1
else sig.single_ycp = 0;
end

clear output
clear full
output(:,1) = hrf(:,1) .* rxy.a(coord);
output(:,2) = hrf(:,2) .* rxy.b(coord);
output(:,3) = hrf(:,3) .* rxy.c(coord);
full(:,1) = output(:,1) + output(:,2) + output(:,3);
output(:,4) = hrf(:,1) .* rcy.a(coord);
output(:,5) = hrf(:,2) .* rcy.b(coord);
output(:,6) = hrf(:,3) .* rcy.c(coord);
full(:,2) = output(:,4) + output(:,5) + output(:,6);
output(:,7) = hrf(:,1) .* rxo.a(coord);
output(:,8) = hrf(:,2) .* rxo.b(coord);
output(:,9) = hrf(:,3) .* rxo.c(coord);
full(:,3) = output(:,7) + output(:,8) + output(:,9);
output(:,10) = hrf(:,1) .* rco.a(coord);
output(:,11) = hrf(:,2) .* rco.b(coord);
output(:,12) = hrf(:,3) .* rco.c(coord);
full(:,4) = output(:,10) + output(:,11) + output(:,12);

clear maxi
maxi(1) = max(max(full)) + (abs(max(max(full))) ./ 10);
maxi(2) = min(min(full)) - (abs(min(min(full))) ./ 10);

clear amplitudes
% save peak amplitudes
for n = 1:4;
    amplitudes(n) = max(abs(full(:,n)));
end

% young x as a proportion of old x
amplitudes(5) = amplitudes(1) ./ amplitudes(3);
% young c as a proportion of young x
amplitudes(6) = amplitudes(2) ./ amplitudes(1);
% young c as a proportion of old c
amplitudes(7) = amplitudes(2) ./ amplitudes(4);
% old c as a proportion of old x
amplitudes(8) = amplitudes(4) ./ amplitudes(3);


a = figure(1);
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
if sig.experimental == 1 & sig.old == 1;
    legend(strcat('young exp - diff from elderly exp: ',num2str(amplitudes(5))),strcat('elderly exp - diff from elderly control: ',num2str(amplitudes(8))));
elseif sig.experimental == 1 & sig.old == 0;
    legend(strcat('young exp - diff from elderly exp: ',num2str(amplitudes(5))),'elderly exp');
elseif sig.experimental == 0 & sig.old == 1;
    legend('young exp',strcat('elderly exp - diff from elderly control: ',num2str(amplitudes(8))));
elseif sig.experimental == 0 & sig.old == 0;
    legend('young exp','elderly exp');
end
title(strcat('x = ',num2str(x),', y = ',num2str(y),', z = ',num2str(z)));
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
if sig.young == 1 & sig.control == 1;
    legend(strcat('young con - diff from young exp: ',num2str(amplitudes(6))),strcat('elderly con - diff from young con: ',num2str(amplitudes(7))));
elseif sig.young == 1 & sig.control == 0;
    legend(strcat('young con - diff from young exp: ',num2str(amplitudes(6))),'elderly con');
elseif sig.young == 0 & sig.control == 1;
    legend('young con',strcat('elderly con - diff from young con: ',num2str(amplitudes(7))));
elseif sig.young == 0 & sig.control == 0;
    legend('young con','elderly con');
end
if sig.int == 1;
    title('significant interaction');
else
    title('no interaction');
end
hold off

% save as a table
amplitudes = array2table(amplitudes, ...
    'VariableNames',{'YoungX','YoungC','OldX','OldC','YxOx','YcYx','YcOc','OcOx'});


% run through parametric
clear outputP
clear fullP
outputP(:,1) = run(:,1) .* pxy.a(coord);
outputP(:,2) = run(:,2) .* pxy.b(coord);
outputP(:,3) = run(:,3) .* pxy.c(coord);
fullP(:,1) = outputP(:,1) + outputP(:,2) + outputP(:,3);
outputP(:,4) = run(:,1) .* pcy.a(coord);
outputP(:,5) = run(:,2) .* pcy.b(coord);
outputP(:,6) = run(:,3) .* pcy.c(coord);
fullP(:,2) = outputP(:,4) + outputP(:,5) + outputP(:,6);
outputP(:,7) = run(:,1) .* pxo.a(coord);
outputP(:,8) = run(:,2) .* pxo.b(coord);
outputP(:,9) = run(:,3) .* pxo.c(coord);
fullP(:,3) = outputP(:,7) + outputP(:,8) + outputP(:,9);
outputP(:,10) = run(:,1) .* pco.a(coord);
outputP(:,11) = run(:,2) .* pco.b(coord);
outputP(:,12) = run(:,3) .* pco.c(coord);
fullP(:,4) = outputP(:,10) + outputP(:,11) + outputP(:,12);

clear maxiP
maxiP(1) = max(max(fullP)) + (abs(max(max(fullP))) ./ 10);
maxiP(2) = min(min(fullP)) - (abs(min(min(fullP))) ./ 10);

clear amplitudesP
% save peak amplitudesP
for n = 1:4;
    amplitudesP(n) = max(abs(fullP(:,n)));
end

% young x as a proportion of old x
amplitudesP(5) = amplitudesP(1) ./ amplitudesP(3);
% young c as a proportion of young x
amplitudesP(6) = amplitudesP(2) ./ amplitudesP(1);
% young c as a proportion of old c
amplitudesP(7) = amplitudesP(2) ./ amplitudesP(4);
% old c as a proportion of old x
amplitudesP(8) = amplitudesP(4) ./ amplitudesP(3);


b = figure(2);
set(gcf,'Position',[60 60 1600 800]);
subplot(1,2,1);
plot(fullP(:,1));
hold on
plot(fullP(:,3));
xbins = 0: (4*sec): (sec*(window.*2));
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([maxi(2) maxi(1)]);
xlabel('Time (secs)');
ylabel('Amplitude');
if sig.Pexperimental == 1 & sig.Pold == 1;
    legend(strcat('young exp - diff from elderly exp: ',num2str(amplitudesP(5))),strcat('elderly exp - diff from elderly control: ',num2str(amplitudesP(8))));
elseif sig.Pexperimental == 1 & sig.Pold == 0;
    legend(strcat('young exp - diff from elderly exp: ',num2str(amplitudesP(5))),'elderly exp');
elseif sig.Pexperimental == 0 & sig.Pold == 1;
    legend('young exp',strcat('elderly exp - diff from elderly control: ',num2str(amplitudesP(8))));
elseif sig.Pexperimental == 0 & sig.Pold == 0;
    legend('young exp','elderly exp');
end
title(strcat('x = ',num2str(x),', y = ',num2str(y),', z = ',num2str(z)));
hold off

subplot(1,2,2);
plot(fullP(:,2));
hold on
plot(fullP(:,4));
xbins = 0: (4*sec): (sec*(window.*2));
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Amplitude');
ylim([maxi(2) maxi(1)]);
if sig.Pyoung == 1 & sig.Pcontrol == 1;
    legend(strcat('young con - diff from young exp: ',num2str(amplitudesP(6))),strcat('elderly con - diff from young con: ',num2str(amplitudesP(7))));
elseif sig.Pyoung == 1 & sig.Pcontrol == 0;
    legend(strcat('young con - diff from young exp: ',num2str(amplitudesP(6))),'elderly con');
elseif sig.Pyoung == 0 & sig.Pcontrol == 1;
    legend('young con',strcat('elderly con - diff from young con: ',num2str(amplitudesP(7))));
elseif sig.Pyoung == 0 & sig.Pcontrol == 0;
    legend('young con','elderly con');
end
if sig.Pint == 1;
    title('significant interaction');
else
    title('no interaction');
end
hold off

% save as a table
amplitudesP = array2table(amplitudesP, ...
    'VariableNames',{'YoungX','YoungC','OldX','OldC','YxOx','YcYx','YcOc','OcOx'});







% re run with covariate version
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/covariate');


% check if contrasts are cov_significant
clear cov_sig
if cov_main_int(coord) > 0;
    cov_sig.int = 1
else cov_sig.int = 0;
end
if cov_main_y(coord) > 0;
    cov_sig.young = 1
else cov_sig.young = 0;
end
if cov_main_o(coord) > 0;
    cov_sig.old = 1
else cov_sig.old = 0;
end
if cov_main_x(coord) > 0;
    cov_sig.experimental = 1
else cov_sig.experimental = 0;
end
if cov_main_c(coord) > 0;
    cov_sig.control = 1
else cov_sig.control = 0;
end
if cov_para_int(coord) > 0;
    cov_sig.Pint = 1
else cov_sig.Pint = 0;
end
if cov_para_y(coord) > 0;
    cov_sig.Pyoung = 1
else cov_sig.Pyoung = 0;
end
if cov_para_o(coord) > 0;
    cov_sig.Pold = 1
else cov_sig.Pold = 0;
end
if cov_para_x(coord) > 0;
    cov_sig.Pexperimental = 1
else cov_sig.Pexperimental = 0;
end
if cov_para_c(coord) > 0;
    cov_sig.cov_pcontrol = 1
else cov_sig.cov_pcontrol = 0;
end
if cov_single_ox(coord) > 0;
    sig.cov_single_ox = 1
else sig.cov_single_ox = 0;
end
if cov_single_oxp(coord) > 0;
    sig.cov_single_oxp = 1
else sig.cov_single_oxp = 0;
end
if cov_single_oc(coord) > 0;
    sig.cov_single_oc = 1
else sig.cov_single_oc = 0;
end
if cov_single_ocp(coord) > 0;
    sig.cov_single_ocp = 1
else sig.cov_single_ocp = 0;
end
if cov_single_yx(coord) > 0;
    sig.cov_single_yx = 1
else sig.cov_single_yx = 0;
end
if cov_single_yxp(coord) > 0;
    sig.cov_single_yxp = 1
else sig.cov_single_yxp = 0;
end
if cov_single_yc(coord) > 0;
    sig.cov_single_yc = 1
else sig.cov_single_yc = 0;
end
if cov_single_ycp(coord) > 0;
    sig.cov_single_ycp = 1
else sig.cov_single_ycp = 0;
end


clear cov_output
clear cov_full
cov_output(:,1) = hrf(:,1) .* cov_rxy.a(coord);
cov_output(:,2) = hrf(:,2) .* cov_rxy.b(coord);
cov_output(:,3) = hrf(:,3) .* cov_rxy.c(coord);
cov_full(:,1) = cov_output(:,1) + cov_output(:,2) + cov_output(:,3);
cov_output(:,4) = hrf(:,1) .* cov_rcy.a(coord);
cov_output(:,5) = hrf(:,2) .* cov_rcy.b(coord);
cov_output(:,6) = hrf(:,3) .* cov_rcy.c(coord);
cov_full(:,2) = cov_output(:,4) + cov_output(:,5) + cov_output(:,6);
cov_output(:,7) = hrf(:,1) .* cov_rxo.a(coord);
cov_output(:,8) = hrf(:,2) .* cov_rxo.b(coord);
cov_output(:,9) = hrf(:,3) .* cov_rxo.c(coord);
cov_full(:,3) = cov_output(:,7) + cov_output(:,8) + cov_output(:,9);
cov_output(:,10) = hrf(:,1) .* cov_rco.a(coord);
cov_output(:,11) = hrf(:,2) .* cov_rco.b(coord);
cov_output(:,12) = hrf(:,3) .* cov_rco.c(coord);
cov_full(:,4) = cov_output(:,10) + cov_output(:,11) + cov_output(:,12);

clear maxi
maxi(1) = max(max(cov_full)) + (abs(max(max(cov_full))) ./ 10);
maxi(2) = min(min(cov_full)) - (abs(min(min(cov_full))) ./ 10);

clear cov_amplitudes
% save peak cov_amplitudes
for n = 1:4;
    cov_amplitudes(n) = max(abs(cov_full(:,n)));
end

% young x as a proportion of old x
cov_amplitudes(5) = cov_amplitudes(1) ./ cov_amplitudes(3);
% young c as a proportion of young x
cov_amplitudes(6) = cov_amplitudes(2) ./ cov_amplitudes(1);
% young c as a proportion of old c
cov_amplitudes(7) = cov_amplitudes(2) ./ cov_amplitudes(4);
% old c as a proportion of old x
cov_amplitudes(8) = cov_amplitudes(4) ./ cov_amplitudes(3);


c = figure(3);
set(gcf,'Position',[60 60 1600 800]);
subplot(1,2,1);
plot(cov_full(:,1));
hold on
plot(cov_full(:,3));
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([maxi(2) maxi(1)]);
xlabel('Time (secs)');
ylabel('Amplitude');
if cov_sig.experimental == 1 & cov_sig.old == 1;
    legend(strcat('young exp - diff from elderly exp: ',num2str(cov_amplitudes(5))),strcat('elderly exp - diff from elderly control: ',num2str(cov_amplitudes(8))));
elseif cov_sig.experimental == 1 & cov_sig.old == 0;
    legend(strcat('young exp - diff from elderly exp: ',num2str(cov_amplitudes(5))),'elderly exp');
elseif cov_sig.experimental == 0 & cov_sig.old == 1;
    legend('young exp',strcat('elderly exp - diff from elderly control: ',num2str(cov_amplitudes(8))));
elseif cov_sig.experimental == 0 & cov_sig.old == 0;
    legend('young exp','elderly exp');
end
title(strcat('x = ',num2str(x),', y = ',num2str(y),', z = ',num2str(z)));
hold off

subplot(1,2,2);
plot(cov_full(:,2));
hold on
plot(cov_full(:,4));
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Amplitude');
ylim([maxi(2) maxi(1)]);
if cov_sig.young == 1 & cov_sig.control == 1;
    legend(strcat('young con - diff from young exp: ',num2str(cov_amplitudes(6))),strcat('elderly con - diff from young con: ',num2str(cov_amplitudes(7))));
elseif cov_sig.young == 1 & cov_sig.control == 0;
    legend(strcat('young con - diff from young exp: ',num2str(cov_amplitudes(6))),'elderly con');
elseif cov_sig.young == 0 & cov_sig.control == 1;
    legend('young con',strcat('elderly con - diff from young con: ',num2str(cov_amplitudes(7))));
elseif cov_sig.young == 0 & cov_sig.control == 0;
    legend('young con','elderly con');
end
if cov_sig.int == 1;
    title('cov significant interaction');
else
    title('cov no interaction');
end
hold off

% save as a table
cov_amplitudes = array2table(cov_amplitudes, ...
    'VariableNames',{'YoungX','YoungC','OldX','OldC','YxOx','YcYx','YcOc','OcOx'});


% run through cov_parametric
clear cov_outputP
clear cov_fullP
cov_outputP(:,1) = run(:,1) .* cov_pxy.a(coord);
cov_outputP(:,2) = run(:,2) .* cov_pxy.b(coord);
cov_outputP(:,3) = run(:,3) .* cov_pxy.c(coord);
cov_fullP(:,1) = cov_outputP(:,1) + cov_outputP(:,2) + cov_outputP(:,3);
cov_outputP(:,4) = run(:,1) .* cov_pcy.a(coord);
cov_outputP(:,5) = run(:,2) .* cov_pcy.b(coord);
cov_outputP(:,6) = run(:,3) .* cov_pcy.c(coord);
cov_fullP(:,2) = cov_outputP(:,4) + cov_outputP(:,5) + cov_outputP(:,6);
cov_outputP(:,7) = run(:,1) .* cov_pxo.a(coord);
cov_outputP(:,8) = run(:,2) .* cov_pxo.b(coord);
cov_outputP(:,9) = run(:,3) .* cov_pxo.c(coord);
cov_fullP(:,3) = cov_outputP(:,7) + cov_outputP(:,8) + cov_outputP(:,9);
cov_outputP(:,10) = run(:,1) .* cov_pco.a(coord);
cov_outputP(:,11) = run(:,2) .* cov_pco.b(coord);
cov_outputP(:,12) = run(:,3) .* cov_pco.c(coord);
cov_fullP(:,4) = cov_outputP(:,10) + cov_outputP(:,11) + cov_outputP(:,12);

clear maxiP
maxiP(1) = max(max(cov_fullP)) + (abs(max(max(cov_fullP))) ./ 10);
maxiP(2) = min(min(cov_fullP)) - (abs(min(min(cov_fullP))) ./ 10);

clear cov_amplitudesP
% save peak cov_amplitudesP
for n = 1:4;
    cov_amplitudesP(n) = max(abs(cov_fullP(:,n)));
end

% young x as a proportion of old x
cov_amplitudesP(5) = cov_amplitudesP(1) ./ cov_amplitudesP(3);
% young c as a proportion of young x
cov_amplitudesP(6) = cov_amplitudesP(2) ./ cov_amplitudesP(1);
% young c as a proportion of old c
cov_amplitudesP(7) = cov_amplitudesP(2) ./ cov_amplitudesP(4);
% old c as a proportion of old x
cov_amplitudesP(8) = cov_amplitudesP(4) ./ cov_amplitudesP(3);


d = figure(4);
set(gcf,'Position',[60 60 1600 800]);
subplot(1,2,1);
plot(cov_fullP(:,1));
hold on
plot(cov_fullP(:,3));
xbins = 0: (4*sec): (sec*(window.*2));
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([maxi(2) maxi(1)]);
xlabel('Time (secs)');
ylabel('Amplitude');
if cov_sig.Pexperimental == 1 & cov_sig.Pold == 1;
    legend(strcat('young exp - diff from elderly exp: ',num2str(cov_amplitudesP(5))),strcat('elderly exp - diff from elderly control: ',num2str(cov_amplitudesP(8))));
elseif cov_sig.Pexperimental == 1 & cov_sig.Pold == 0;
    legend(strcat('young exp - diff from elderly exp: ',num2str(cov_amplitudesP(5))),'elderly exp');
elseif cov_sig.Pexperimental == 0 & cov_sig.Pold == 1;
    legend('young exp',strcat('elderly exp - diff from elderly control: ',num2str(cov_amplitudesP(8))));
elseif cov_sig.Pexperimental == 0 & cov_sig.Pold == 0;
    legend('young exp','elderly exp');
end
title(strcat('x = ',num2str(x),', y = ',num2str(y),', z = ',num2str(z)));
hold off

subplot(1,2,2);
plot(cov_fullP(:,2));
hold on
plot(cov_fullP(:,4));
xbins = 0: (4*sec): (sec*(window.*2));
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Amplitude');
ylim([maxi(2) maxi(1)]);
if cov_sig.Pyoung == 1 & cov_sig.cov_pcontrol == 1;
    legend(strcat('young con - diff from young exp: ',num2str(cov_amplitudesP(6))),strcat('elderly con - diff from young con: ',num2str(cov_amplitudesP(7))));
elseif cov_sig.Pyoung == 1 & cov_sig.cov_pcontrol == 0;
    legend(strcat('young con - diff from young exp: ',num2str(cov_amplitudesP(6))),'elderly con');
elseif cov_sig.Pyoung == 0 & cov_sig.cov_pcontrol == 1;
    legend('young con',strcat('elderly con - diff from young con: ',num2str(cov_amplitudesP(7))));
elseif cov_sig.Pyoung == 0 & cov_sig.cov_pcontrol == 0;
    legend('young con','elderly con');
end
if cov_sig.Pint == 1;
    title('cov significant interaction');
else
    title('cov no interaction');
end
hold off

% save as a table
cov_amplitudesP = array2table(cov_amplitudesP, ...
    'VariableNames',{'YoungX','YoungC','OldX','OldC','YxOx','YcYx','YcOc','OcOx'});

% effects
effects(1,1) = sig.single_yx;
effects(1,2) = sig.single_yc;
effects(1,3) = sig.single_ox;
effects(1,4) = sig.single_oc;
effects(1,5) = sig.single_yxp;
effects(1,6) = sig.single_ycp;
effects(1,7) = sig.single_oxp;
effects(1,8) = sig.single_ocp;
clear n
for n = 1:4;
    effects(2,n) = max(full(:,n));
    effects(2,n+4) = max(fullP(1:257,n)) .* -1;
    effects(3,n) = min(full(:,n));
    effects(3,n+4) = min(fullP(1:257,n)) .* -1;
end
effects(4,1) = sig.cov_single_yx;
effects(4,2) = sig.cov_single_yc;
effects(4,3) = sig.cov_single_ox;
effects(4,4) = sig.cov_single_oc;
effects(4,5) = sig.cov_single_yxp;
effects(4,6) = sig.cov_single_ycp;
effects(4,7) = sig.cov_single_oxp;
effects(4,8) = sig.cov_single_ocp;
clear n
for n = 1:4;
    effects(5,n) = max(cov_full(:,n));
    effects(5,n+4) = max(cov_fullP(1:257,n)) .* -1;
    effects(6,n) = min(cov_full(:,n));
    effects(6,n+4) = min(cov_fullP(1:257,n)) .* -1;
end
effects(7,1) = x;
effects(7,2) = y;
effects(7,3) = z;

% save as a table
effects_table = array2table(effects, ...
    'VariableNames',{'YoungX','YoungC','ElderlyX','ElderlyC','YoungXp','YoungCp','ElderlyXp','ElderlyCp'}, ...
    'RowNames',{'Original','Max/Para_Neg','Min/Para_Pos','Covariate','Max/Para_NegC','Min/Para_PosC','Coordinates'});

% also save betas
beta_t(1,1) = rxy.a(coord);
beta_t(2,1) = rxy.b(coord);
beta_t(3,1) = rxy.c(coord);
beta_t(4,1) = abs(beta_t(1,1)) ./ (abs(beta_t(1,1)) + abs(beta_t(2,1)) + abs(beta_t(3,1)));
beta_t(5,1) = abs(beta_t(2,1)) ./ (abs(beta_t(1,1)) + abs(beta_t(2,1)) + abs(beta_t(3,1)));
beta_t(6,1) = abs(beta_t(3,1)) ./ (abs(beta_t(1,1)) + abs(beta_t(2,1)) + abs(beta_t(3,1)));
beta_t(7,1) = pxy.a(coord);
beta_t(8,1) = pxy.b(coord);
beta_t(9,1) = pxy.c(coord);
beta_t(10,1) = abs(beta_t(7,1)) ./ (abs(beta_t(7,1)) + abs(beta_t(8,1)) + abs(beta_t(9,1)));
beta_t(11,1) = abs(beta_t(8,1)) ./ (abs(beta_t(7,1)) + abs(beta_t(8,1)) + abs(beta_t(9,1)));
beta_t(12,1) = abs(beta_t(9,1)) ./ (abs(beta_t(7,1)) + abs(beta_t(8,1)) + abs(beta_t(9,1)));

beta_t(1,2) = rcy.a(coord);
beta_t(2,2) = rcy.b(coord);
beta_t(3,2) = rcy.c(coord);
beta_t(4,2) = abs(beta_t(1,2)) ./ (abs(beta_t(1,2)) + abs(beta_t(2,2)) + abs(beta_t(3,2)));
beta_t(5,2) = abs(beta_t(2,2)) ./ (abs(beta_t(1,2)) + abs(beta_t(2,2)) + abs(beta_t(3,2)));
beta_t(6,2) = abs(beta_t(3,2)) ./ (abs(beta_t(1,2)) + abs(beta_t(2,2)) + abs(beta_t(3,2)));
beta_t(7,2) = pcy.a(coord);
beta_t(8,2) = pcy.b(coord);
beta_t(9,2) = pcy.c(coord);
beta_t(10,2) = abs(beta_t(7,2)) ./ (abs(beta_t(7,2)) + abs(beta_t(8,2)) + abs(beta_t(9,2)));
beta_t(11,2) = abs(beta_t(8,2)) ./ (abs(beta_t(7,2)) + abs(beta_t(8,2)) + abs(beta_t(9,2)));
beta_t(12,2) = abs(beta_t(9,2)) ./ (abs(beta_t(7,2)) + abs(beta_t(8,2)) + abs(beta_t(9,2)));

beta_t(1,3) = rxo.a(coord);
beta_t(2,3) = rxo.b(coord);
beta_t(3,3) = rxo.c(coord);
beta_t(4,3) = abs(beta_t(1,3)) ./ (abs(beta_t(1,3)) + abs(beta_t(2,3)) + abs(beta_t(3,3)));
beta_t(5,3) = abs(beta_t(2,3)) ./ (abs(beta_t(1,3)) + abs(beta_t(2,3)) + abs(beta_t(3,3)));
beta_t(6,3) = abs(beta_t(3,3)) ./ (abs(beta_t(1,3)) + abs(beta_t(2,3)) + abs(beta_t(3,3)));
beta_t(7,3) = pxo.a(coord);
beta_t(8,3) = pxo.b(coord);
beta_t(9,3) = pxo.c(coord);
beta_t(10,3) = abs(beta_t(7,3)) ./ (abs(beta_t(7,3)) + abs(beta_t(8,3)) + abs(beta_t(9,3)));
beta_t(11,3) = abs(beta_t(8,3)) ./ (abs(beta_t(7,3)) + abs(beta_t(8,3)) + abs(beta_t(9,3)));
beta_t(12,3) = abs(beta_t(9,3)) ./ (abs(beta_t(7,3)) + abs(beta_t(8,3)) + abs(beta_t(9,3)));

beta_t(1,4) = rco.a(coord);
beta_t(2,4) = rco.b(coord);
beta_t(3,4) = rco.c(coord);
beta_t(4,4) = abs(beta_t(1,4)) ./ (abs(beta_t(1,4)) + abs(beta_t(2,4)) + abs(beta_t(3,4)));
beta_t(5,4) = abs(beta_t(2,4)) ./ (abs(beta_t(1,4)) + abs(beta_t(2,4)) + abs(beta_t(3,4)));
beta_t(6,4) = abs(beta_t(3,4)) ./ (abs(beta_t(1,4)) + abs(beta_t(2,4)) + abs(beta_t(3,4)));
beta_t(7,4) = pco.a(coord);
beta_t(8,4) = pco.b(coord);
beta_t(9,4) = pco.c(coord);
beta_t(10,4) = abs(beta_t(7,4)) ./ (abs(beta_t(7,4)) + abs(beta_t(8,4)) + abs(beta_t(9,4)));
beta_t(11,4) = abs(beta_t(8,4)) ./ (abs(beta_t(7,4)) + abs(beta_t(8,4)) + abs(beta_t(9,4)));
beta_t(12,4) = abs(beta_t(9,4)) ./ (abs(beta_t(7,4)) + abs(beta_t(8,4)) + abs(beta_t(9,4)));

% save as a table
beta_table = array2table(beta_t, ...
    'VariableNames',{'YoungX','YoungC','ElderlyX','ElderlyC'}, ...
    'RowNames',{'Canonical_reg','Temp_Derv_reg','Disp_Derv_reg','Can_prop','TD_prop','DD_prop','Canonical_para','Temp_Derv_para','Disp_Derv_para','CanP_propr','TDP_prop','DDP_prop'});




% save the relevant
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/outputs');
mkdir(strcat('coordinate_',num2str(x),'_',num2str(y),'_',num2str(z)));
cd(strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/2nd_level/outputs/coordinate_',num2str(x),'_',num2str(y),'_',num2str(z)));
save effects_table effects_table
save beta_table beta_table
saveas(a,'original_effect','jpg');
saveas(b,'original_parametric','jpg');
saveas(c,'covariate_effect','jpg');
saveas(d,'covariate_parametric','jpg');
