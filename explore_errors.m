clear all
sub = [301 304 306 309 310 312 313 316 318 319 320 322 323 324 326 328 330 331 333 334 336 340 341 342 401 406 407 410 411 412 413 414 416 418 420 422 423 424 425 426 427 428 429 430 431 432 433 434];

clear n
for n = 1:length(sub);
    if sub(n) > 399;
        cd(strcat('C:/Users/mdanv/OneDrive/PhD_Stuff/Experiment_3/design_2_base/testing/young/',num2str(sub(n))));
        data = importdata('RT_RESULTS.txt');
    else
        cd(strcat('C:/Users/mdanv/OneDrive/PhD_Stuff/Experiment_3/design_2_base/testing/old/',num2str(sub(n))));
        data = importdata('RT_RESULTS.txt');
    end

    try
        data = data.data;
    end

    % remove pactise trials
    data(find(data(:,1) < 9),:) = [];

    % remove missed trials
    data(find(data(:,5) == 0),:) = [];

    % count the number of experimental errors
    error_file(n,1) = sub(n);
    error_file(n,2) = length(find(data(:,5) == 1 & data(:,8) == 1));

    % run through each rule independently
    clear rule
    clear m
    clear counter
    clear total_len
    clear pre
    clear rt
    counter.pre = 0;
    counter.post = 0;
    counter.matchexp = 0;
    counter.matchall = 0;
    counter.unmatchexp = 0;
    counter.unmatchall = 0;
    counter.matchall2 = 0;
    counter.unmatchall2 = 0;
    pre = 0;
    post = 0;
    total_len = 0;
    

    for m = 1:4;
        clear name
        name = strcat('cue',num2str(m));
        % separate the rules
        rule.all.(name) = data(find(data(:,3) == m),:);
        rule.exp.(name) = data(find(data(:,3) == m & data(:,8) == 1),:);
        % now run through each rule to ascertain the number of errors pre
        % and post first correct

        % find the position of the first correct trial (if I cannot
        % find one I assume no correct trials and so all are pre correct)
        clear pos
        pos = find(rule.exp.(name)(:,5) == 2,1);
        % if this is in posiiton one, then confirm that there are no
        % errors pre and count all errors post (which is just all
        % errors)
        if pos == 1;
            counter.pre = counter.pre + 0;
            counter.post = counter.post + length(find(rule.exp.(name)(:,5) == 1));
            pre = pre + 0;
            % check rep errors post first
            clear err
            err = rule.exp.(name)(find(rule.exp.(name)(:,5) == 1),:);
            post = post + length(err(:,1)) - length(unique(err(:,7)));
        elseif pos > 1;
            % now look at the number of pre and post errors assuming not
            % right first time
            counter.pre = counter.pre + length(find(rule.exp.(name)(1:pos - 1,5) == 1));
            counter.post = counter.post + length(find(rule.exp.(name)(pos + 1:length(rule.exp.(name)(:,1)),5) == 1));
            % now count the number of repeated errors pre the first correct
            pre = pre + (pos - 1) - length(unique(rule.exp.(name)(1:pos - 1,7)));
            clear precheck
            precheck = (pos - 1) - length(unique(rule.exp.(name)(1:pos - 1,7)));
            % check rep errors post first
            clear err
            err = rule.exp.(name)(find(rule.exp.(name)(:,5) == 1),:);
            post = post + length(err(:,1)) - length(unique(err(:,7))) - precheck;
        else        
            % cannot find a first correct then all are pre correct
            counter.pre = counter.pre + length(find(rule.exp.(name)(:,5) == 1));
            counter.post = counter.post + 0;
            pre = pre + length(find(rule.exp.(name)(:,5) == 1)) - length(unique(rule.exp.(name)(1:pos - 1,7)));
        end

        % Now look up how often an error was repeated within a rule
        clear temp
        clear temp2
        % load the rule
        temp = rule.exp.(name);
        % isolate only error trials
        temp2 = temp(find(temp(:,5) == 1),:);
        % check for if there are any error trials
        try 
            % arbitrary operation but throws up an error if is empty array
            temp2(1);
            % then count the number of error trials and subtract the number
            % of unique targets, which leaves us with the number of
            % persistent errors
            clear len
            len = length(temp2(:,1)) - length(unique(temp2(:,7)));
        catch
            % if no errors then set to zero
            clear len
            len = 0;
        end
        total_len = total_len + len;

    end

    % count the number of errors which match the previous trial
    clear x
    for x = 2:length(data(:,1));
        % find all errors which are preceded by a correct trial (must be
        % experimental trial x as can only make an error on experimental)
        if data(x,5) == 1 & data(x-1,5) == 2;
            if data(x,7) == data(x-1,7);
                counter.matchall = counter.matchall + 1;
            % also count cases where there is an error following
            % correct and does not match
            else 
                counter.unmatchall = counter.unmatchall + 1;
            end
        end
        % now look at just cases where the preceding was an experimental
        % trial
        if data(x,5) == 1 & data(x-1,5) == 2 & data(x-1,8) == 1;
            if data(x,7) == data(x-1,7);
                counter.matchexp = counter.matchexp + 1;
            % also count cases where there is an error following
            % correct and does not match
            else 
                counter.unmatchexp = counter.unmatchexp + 1;
            end
        end
    end

    % count the number of exp errors which match the previous exp trial
    clear test
    test = data;
    test(find(test(:,8) == 2),:) = [];
    clear x
    for x = 2:length(test(:,1));
        % find all errors which are preceded by a correct trial (must be
        % experimental trial x as can only make an error on experimental)
        if test(x,5) == 1 & test(x-1,5) == 2;
            if test(x,7) == test(x-1,7);
                counter.matchall2 = counter.matchall2 + 1;
            % also count cases where there is an error following
            % correct and does not match
            else 
                counter.unmatchall2 = counter.unmatchall2 + 1;
            end
        end
    end
    
    % save the reaction time of the control trials
    clear summary
    summary = data(find(data(:,8) == 2 & data(:,2) > 0),:);
    rt.mean = mean(summary(:,2));
    rt.median = median(summary(:,2));




    % set the number of errors pre and post correct
    error_file(n,3) = counter.pre;
    error_file(n,4) = counter.post;
    if counter.matchall + counter.unmatchall > 0;
        error_file(n,5) = counter.matchall;
        error_file(n,6) = (counter.matchall ./ (counter.matchall + counter.unmatchall)) .* 100;
    else
        error_file(n,5:6) = -999;
    end
    if counter.matchexp + counter.unmatchexp > 0;
        error_file(n,7) = counter.matchexp;
        error_file(n,8) = (counter.matchexp ./ (counter.matchexp + counter.unmatchexp)) .* 100;
    else
        error_file(n,7:8) = -999;
    end
    if counter.matchall2 + counter.unmatchall2 > 0;
        error_file(n,9) = counter.matchall2;
        error_file(n,10) = (counter.matchall2 ./ (counter.matchall2 + counter.unmatchall2)) .* 100;
    else
        error_file(n,9:10) = -999;
    end
    error_file(n,11) = total_len;
    error_file(n,12) = pre;
    error_file(n,13) = post;
    error_file(n,14) = rt.mean;
    error_file(n,15) = rt.median;
end

errors = array2table(error_file,'VariableNames',{'sub','num_errors','num_pre_err','num_post_err','prepotent_err_all','perc','Prepotent_err_exp','perc2','Prepotent_err_expONLY','perc3','num_repeated_err','num_repeated_error_pre','num_repeated_error_post','mean_ctrl_rt','median_ctrl_rt'});
    
cd('C:/Users/mdanv/OneDrive/PhD_Stuff/Experiment_3/design_2_base/testing/Analysis');     

save errors errors

