clear all
sub = [301 304 306 309 310 312 313 316 318 319 320 322 323 324 326 328 330 331 333 334 336 340 341 342 401 406 407 410 411 412 413 414 416 418 420 422 423 424 425 426 427 428 429 430 431 432 433 434];

clear n
for n = 1:length(sub);
    if sub(n) > 399;
        cd(strcat('F:/Experiment_3/design_2_base/testing/young/',num2str(sub(n))));
        design = importdata('design.mat');
        design.feed.all = sortrows([design.feed.one; design.feed.two; design.feed.thr],1);
    else
        cd(strcat('F:/Experiment_3/design_2_base/testing/old/',num2str(sub(n))));
        design = importdata('design.mat');
        design.feed.all = sortrows([design.feed.one; design.feed.two; design.feed.thr],1);
    end

    % load the HRF function
    cd('F:/Experiment_3/design_2_base/testing/Analysis');
    data.hrf = importdata('hrftd.mat');
    % check how many cells per second
    data.sec = length(data.hrf(:,1)) ./ 32.125;
    % calculate the length of the design matrix in cells
    clear x
    x = max([design.feed.all; design.incorCue12_missAll]);
    clear y
    y = ceil(x .* data.sec) + length(data.hrf(:,1));

    % create the faux design matrix
    cond.design(1:y,1:33) = 0;

    % loop through each variable and convolve with the HRF

    % 1 = exp cue correct
    % 2 = exp cue correct para
    % 3 = con cue correct
    % 4 = con cue correct para
    % 5 = incorrect cues, cue12, all missed events
    % 6 = target one saccaded to
    % 7 = target two saccaded to
    % 8 = target three saccaded to
    % 9 = feedback target 1
    % 10 = feedback target 2
    % 11 = feedback target 3


    % exp cue correct
    clear nn
    for nn = 1:length(design.cue_cor_X_22(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.cue_cor_X_22(nn,1) .* data.sec);
            cond.design(x:x+256,m) = cond.design(x:x+256,m) + data.hrf(:,m);
        end
    end

%     % exp cue para
%     clear nn
%     for nn = 1:length(design.cue_cor_X_22(:,1));
%         clear m
%         for m = 1:3;
%             clear x
%             x = ceil(design.cue_cor_X_22(nn,1) .* data.sec);
%             cond.design(x:x+256,m + 3) = (cond.design(x:x+256,m + 3) + data.hrf(:,m)) .* design.cue_cor_X_22(nn,2);
%         end
%     end
%     cond.design(:,4) = cond.design(:,4) - max(cond.design(:,4));
%     cond.design(:,5) = cond.design(:,5) - max(cond.design(:,5));
%     cond.design(:,6) = cond.design(:,6) - max(cond.design(:,6));

    % con cue
    clear nn
    for nn = 1:length(design.cue_cor_C(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.cue_cor_C(nn,1) .* data.sec);
            cond.design(x:x+256,m + 6) = cond.design(x:x+256,m + 6) + data.hrf(:,m);
        end
    end

%     % con cue para
%     clear nn
%     for nn = 1:length(design.cue_cor_C(:,1));
%         clear m
%         for m = 1:3;
%             clear x
%             x = ceil(design.cue_cor_C(nn,1) .* data.sec);
%             cond.design(x:x+256,m + 9) = (cond.design(x:x+256,m + 9) + data.hrf(:,m)) .* design.cue_cor_C(nn,2);
%         end
%     end
%     cond.design(:,10) = cond.design(:,10) - max(cond.design(:,10));
%     cond.design(:,11) = cond.design(:,11) - max(cond.design(:,11));
%     cond.design(:,12) = cond.design(:,12) - max(cond.design(:,12));

    % junk regressor
    clear nn
    for nn = 1:length(design.incorCue12_missAll(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.incorCue12_missAll(nn,1) .* data.sec);
            cond.design(x:x+256,m + 12) = cond.design(x:x+256,m + 12) + data.hrf(:,m);
        end
    end

    % targets
    clear nn
    for nn = 1:length(design.targ.one(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.targ.one(nn,1) .* data.sec);
            cond.design(x:x+256,m + 15) = cond.design(x:x+256,m + 15) + data.hrf(:,m);
        end
    end

    clear nn
    for nn = 1:length(design.targ.two(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.targ.two(nn,1) .* data.sec);
            cond.design(x:x+256,m + 18) = cond.design(x:x+256,m + 18) + data.hrf(:,m);
        end
    end

    clear nn
    for nn = 1:length(design.targ.thr(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.targ.thr(nn,1) .* data.sec);
            cond.design(x:x+256,m + 21) = cond.design(x:x+256,m + 21) + data.hrf(:,m);
        end
    end

    % feedback
    clear nn
    for nn = 1:length(design.feed.one(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.feed.one(nn,1) .* data.sec);
            cond.design(x:x+256,m + 24) = cond.design(x:x+256,m + 24) + data.hrf(:,m);
        end
    end

    clear nn
    for nn = 1:length(design.feed.two(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.feed.two(nn,1) .* data.sec);
            cond.design(x:x+256,m + 27) = cond.design(x:x+256,m + 27) + data.hrf(:,m);
        end
    end

    clear nn
    for nn = 1:length(design.feed.thr(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.feed.thr(nn,1) .* data.sec);
            cond.design(x:x+256,m + 30) = cond.design(x:x+256,m + 30) + data.hrf(:,m);
        end
    end

    cond.design2 = cond.design;
    cond.design2(:,25:33) = [];
    cond.design2(:,25:27) = 0;
    % try the new feedback all option
    clear nn
    for nn = 1:length(design.feed.all(:,1));
        clear m
        for m = 1:3;
            clear x
            x = ceil(design.feed.all(nn,1) .* data.sec);
            cond.design2(x:x+256,m + 24) = cond.design2(x:x+256,m + 24) + data.hrf(:,m);
        end
    end

    % create a correlation matrix
    cond.correlate = corrcoef(cond.design);
    cond.correlate2 = corrcoef(cond.design2);

    % remove 1s
    clear nn
    for nn = 1:length(cond.correlate(:,1));
        cond.correlate(nn,nn) = 0;
    end
    clear nn
    for nn = 1:length(cond.correlate2(:,1));
        cond.correlate2(nn,nn) = 0;
    end

    clear max_j
    cond.max_correlate = max(max(abs(cond.correlate)));
    cond.max_correlate2 = max(max(abs(cond.correlate2)));

    cond.max_interest = max(max(abs(cond.correlate(1:12,:))));
    cond.max_interest2 = max(max(abs(cond.correlate2(1:12,:))));

    table(n,1) = sub(n);
    table(n,2) = cond.max_correlate;
    table(n,3) = cond.max_interest;
    table(n,4) = cond.max_correlate2;
    table(n,5) = cond.max_interest2;

    save table table

    if sub(n) > 399;
        cd(strcat('F:/Experiment_3/design_2_base/testing/young/',num2str(sub(n))));
        save cond cond
    else
        cd(strcat('F:/Experiment_3/design_2_base/testing/old/',num2str(sub(n))));
        save cond cond
    end
end



