clear all
cd('/MRIWork/MRIWork06/nr/matthew_danvers/Study_3/create_run/fourth_iteration');
load('total.mat');
load('data.mat');
% create an ordered column
clear n
for n = 1:length(total.whole_run(:,1));
    total.whole_run(n,1) = n;
end

% sort by cue then condition
total.whole_run = sortrows(total.whole_run, 5);
total.whole_run = sortrows(total.whole_run, 7);

% find all experimental trials and set column 6 to the appropriate target
clear n
for n = 1:length(total.whole_run(:,1));
    if total.whole_run(n,7) == 1;
        if total.whole_run(n,5) <= data.num_targets;
            total.whole_run(n,6) = total.whole_run(n,5);
        else
            total.whole_run(n,6) = data.num_targets - (total.whole_run(n,5) - data.num_targets);
        end
    end
end

% work out the number of trials pertaining to a specifc cue in the control condition
newdata.num_events = length(find(total.whole_run(:,7) == 2 & total.whole_run(:,5) == 1));

% create a vector of possible target locations which matches the number of
% cue repetitions in the control condtion
clear n
for n = 1:newdata.num_events ./ data.num_targets;
    for m = 1:data.num_targets;
        newdata.allocations(m + (data.num_targets .* (n - 1)),1) = m;
    end
end

% now randomise this vector and apply to each run
clear n
for n = 1:data.num_cues;
    % randomise vector
    newdata.allocations(:,2) = rand(1,length(newdata.allocations(:,1)));
    newdata.allocations = sortrows(newdata.allocations, 2);
    % apply to the relevant cue in the control condition
    total.whole_run(find(total.whole_run(:,5) == n & total.whole_run(:,7) == 2),6) = newdata.allocations(:,1);
end

% now check the number of each target location in each block by first separatng
% the blocks
clear n
clear t
t(1) = 0;
newdata.temp_file = total.whole_run(find(total.whole_run(:,7) == 2),:);
for n = 1:data.tot_num_blocks;
    clear a
    a = strcat('block',num2str(n));
    newdata.(a) = newdata.temp_file(find(newdata.temp_file(:,8) == n),:);
    % next look at each target location within a bloc, check none come up
    % more regularly than expected (num trial / num blocks / num cues,
    % rounded up to nearest whole
    clear m
    for m = 1:data.num_cues;
        if length(newdata.(a)(find(newdata.(a)(:,6) == m),6)) > ceil((data.numtri_c ./ data.tot_num_blocks) ./ data.num_targets);
            t(1) = 1;
        end
    end
end

    
% re-order the run
total.whole_run = sortrows(total.whole_run,1);

% now check whether there are repetitions, should have no repetitions
clear n
newdata.check = total.whole_run(find(total.whole_run(:,7) == 2),:);
newdata.check = sortrows(newdata.check,5);
t(2) = 0;
for n = 2:length(newdata.check(:,1));
    if newdata.check(n,5) == newdata.check(n-1,5) & newdata.check(n,6) == newdata.check(n-1,6);
    t(2) = 1;
    end
end

% loop through until the control condition never repeats the same pairing
% location on sequential trials.
while t(1) == 1 | t(2) == 1;
    % now randomise this vector and apply to each run
    clear n
    for n = 1:data.num_cues;
        % randomise vector
        newdata.allocations(:,2) = rand(1,length(newdata.allocations(:,1)));
        newdata.allocations = sortrows(newdata.allocations, 2);
        % apply to the relevant cue in the control condition
        total.whole_run(find(total.whole_run(:,5) == n & total.whole_run(:,7) == 2),6) = newdata.allocations(:,1);
    end

    % now check the number of each target location in each block by first separatng
    % the blocks
    clear n
    clear t
    t(1) = 0;
    newdata.temp_file = total.whole_run(find(total.whole_run(:,7) == 2),:);
    for n = 1:data.tot_num_blocks;
        clear a
        a = strcat('block',num2str(n));
        newdata.(a) = newdata.temp_file(find(newdata.temp_file(:,8) == n),:);
        % next look at each target location within a bloc, check none come up
        % more regularly than expected (num trial / num blocks / num cues,
        % rounded up to nearest whole
        clear m
        for m = 1:data.num_cues;
            if length(newdata.(a)(find(newdata.(a)(:,6) == m),6)) > ceil((data.numtri_c ./ data.tot_num_blocks) ./ data.num_targets);
                t(1) = 1;
            end
        end
    end
    
    % re-order the run
    total.whole_run = sortrows(total.whole_run,1);

    % now check whether there are repetitions, should have no repetitions
    clear n
    newdata.check = total.whole_run(find(total.whole_run(:,7) == 2),:);
    newdata.check = sortrows(newdata.check,5);
    t(2) = 0;
    for n = 2:length(newdata.check(:,1));
        if newdata.check(n,5) == newdata.check(n-1,5) & newdata.check(n,6) == newdata.check(n-1,6);
        t(2) = 1;
        end
    end
    t
end

newdata.whole_run = total.whole_run;


% now arrange in a way that matches experiment builder
newdata.EB(:,1) = newdata.whole_run(:,2);
newdata.EB(:,2) = newdata.EB(:,1) + data.cue_spec;
newdata.EB(:,3) = newdata.whole_run(:,3);
newdata.EB(:,4) = newdata.EB(:,3) + data.targ_spec;
newdata.EB(:,5) = newdata.whole_run(:,4);
newdata.EB(:,6) = newdata.EB(:,5) + data.feed_spec;
newdata.EB(:,7) = newdata.whole_run(:,5);
newdata.EB(:,8) = newdata.whole_run(:,6);
newdata.EB(:,9) = newdata.whole_run(:,7);
newdata.EB(:,10) = (data.trilen .* 1000) - 700;

% now generate cue names
for n = 1:length(newdata.EB(:,1));
    clear a
    a = strcat('cue_x',num2str(newdata.EB(n,7)),'.jpg');
    clear b
    b = strcat('cue_c',num2str(newdata.EB(n,7)),'.jpg');
    if newdata.EB(n,9) == 1;
        newdata.cues{n,1} = a;
    else
        newdata.cues{n,1} = b;
    end
end

        
save finaldata newdata
