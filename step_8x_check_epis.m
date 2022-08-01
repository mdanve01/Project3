clear all
sub = [301 304 306 309 310 312 313 316 318 319 320 322 323 324 326 328 330 331 333 334 336 340 341 342 401 406 407 410 411 412 413 414 416 418 420 422 423 424 425 426 427 428 429 430 431 432 433 434];

for m = 1:length(sub);
    
    clear sub1
    sub1 = num2str(sub(m));
    
    cd(strcat('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/eye_movements_and_rules/data/sub-',sub1,'/func'));
    
    images = niftiread(strcat('swufRH_',sub1,'_EMAR.nii'));
    
    % make a new view
    % but do not do all scans, look at every nth
    for n = 1:floor(length(images(1,1,1,:)) ./ 50);
        for m = 1:length(images(1,1,:,1));
            for o = 1:length(images(1,:,1,1));
%                 image_coronal(:,m,o,n) = images(:,o,m,floor(n .* 10));
%                 image_sagittal(o,m,:,n) = images(:,o,m,floor(n .* 10));
                image_horizontal(:,:,:,n) = images(:,:,:,floor(n .* 49));
            end
        end
    end
    
    'images ready, press a key'

    clear n
    figure(100);
    set(gcf,'Position',[60 60 2000 800]);
    w = waitforbuttonpress;
    for n = 1:length(image_horizontal(1,1,1,:));
        subplot(2,3,1);
        imagesc(image_horizontal(:,:,10,n));
        subplot(2,3,2);
        imagesc(image_horizontal(:,:,30,n));
        subplot(2,3,3);
        imagesc(image_horizontal(:,:,50,n));
        subplot(2,3,4);
        imagesc(image_horizontal(:,:,70,n));
        subplot(2,3,5);
        imagesc(image_horizontal(:,:,90,n));
        subplot(2,3,6);
        imagesc(image_horizontal(:,:,110,n));
        num = num2str(n);
        title(strcat(sub1,'  ',num))
    end
end


