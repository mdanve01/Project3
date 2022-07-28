% set a range of values to test
% specific to the square to give us a decent sized stimulus
ran = 90:110;
% larger range for remaining shapes
ran2 = 1:500;

% work through options for the square stimulus, checking the size options and
% their associated areas
% here column 1 is the area, column 2 is the length of a side
for n = 1:length(ran);
    % square
    cuex1(n,1) = ran(n) ^ 2;
    cuex1(n,2) = ran(n);
end

% now work through the other shapes, looking for those with areas that sit
% between the min and max of the square. Helps narrow it down to sensible
% options.
cuex2 = 0;
clear n
for n = 1:length(ran2);
    % circle (here ran(n) denotes the radius, not the diameter)
    clear a
    a = pi .* ran2(n) ^ 2;
    if a <= max(cuex1(:,1)) & a >= min(cuex1(:,1));
        cuex2(length(cuex2(:,1)) + 1,1) = a;
        cuex2(length(cuex2(:,1)),2) = ran2(n);
    end
end
cuex2(1,:) = [];

cuex3 = 0;
clear n
for n = 1:length(ran2);
    % equilateral triangle
    clear a
    % this is half the width multiplied by the height (calculated as the square route of the squared hypotenuse - half the width squared) 
    a = (ran2(n) ./ 2) .* round(sqrt((ran2(n) ^ 2) - ((ran2(n) ./ 2) ^ 2)));
    if a <= max(cuex1(:,1)) & a >= min(cuex1(:,1));
        cuex3(length(cuex3(:,1)) + 1,1) = a;
        % width
        cuex3(length(cuex3(:,1)),2) = ran2(n);
        % height
        cuex3(length(cuex3(:,1)),3) = round(sqrt((ran2(n) ^ 2) - ((ran2(n) ./ 2) ^ 2)));
    end
end
cuex3(1,:) = [];

cuec1 = 0;
clear n
for n = 1:length(ran2);
    % hexagon - the width of the rectangle is twice the height, the height
    % of the triangles is half the height
    clear a
    a = (ran2(n) .* (ran2(n) .* 2)) + ((ran2(n) .* 2) .* round(ran2(n) ./ 2));
    if a <= max(cuex1(:,1)) & a >= min(cuex1(:,1));
        cuec1(length(cuec1(:,1)) + 1,1) = a;
        cuec1(length(cuec1(:,1)),2) = ran2(n);
        cuec1(length(cuec1(:,1)),3) = round(ran2(n) ./ 2);
    end
end
cuec1(1,:) = [];



cuec2 = 0;
clear n
for n = 1:length(ran2);
    % rhombus: with equal length sides, so based upon the square. This
    % calculates the height/width though for ease of creating
    clear a
    a = ((round(sqrt((ran2(n) ^ 2) .* 2)) ./ 2) .* (round(sqrt((ran2(n) ^ 2) .* 2)) ./ 2)) .* 2;
    if a <= max(cuex1(:,1)) & a >= min(cuex1(:,1));
        cuec2(length(cuec2(:,1)) + 1,1) = a;
        cuec2(length(cuec2(:,1)),2) = round(sqrt((ran2(n) ^ 2) .* 2));
    end
end
cuec2(1,:) = [];


    
cuec3 = 0;
clear n
for n = 1:length(ran2);
    % rectangle (the long edge is 1.5x whatever the short edge is)
    clear a
    a = ran2(n) .* round((ran2(n) .* 1.5));
    if a <= max(cuex1(:,1)) & a >= min(cuex1(:,1));
        cuec3(length(cuec3(:,1)) + 1,1) = a;
        % the below is the short edge
        cuec3(length(cuec3(:,1)),2) = ran2(n);
        % and the long edge
        cuec3(length(cuec3(:,1)),3) = round(ran2(n) .* 1.5);
        
    end
end
cuec3(1,:) = [];



% trapezoid
cuec4 = 0;
for n = 1:length(ran2);
    % the retangle has a width half that of its height
    % the triangle has a width a quarter of its height
    clear a
    a = (ran2(n) .* round(ran2(n) ./ 2)) + (round((ran2(n) ./ 4)) .* ran2(n));
    if a <= max(cuex1(:,1)) & a >= min(cuex1(:,1));
        cuec4(length(cuec4(:,1)) + 1,1) = a;
        % width rectangle
        cuec4(length(cuec4(:,1)),2) = round(ran2(n) ./ 2);
        % height rectangle
        cuec4(length(cuec4(:,1)),3) = ran2(n);
        % width triangle (2 of these)
        cuec4(length(cuec4(:,1)),4) = round((ran2(n) ./ 4));
    end
end
cuec4(1,:) = [];



% parallelogram - this can be based upon the exact same components as the
% trapezoid and so makes for a good match.
cuex4 = cuec4;



% now I look for the best fit
clear n
% cycle through each square area and find an area of minimum difference for
% every other shape
for n = 1:length(cuex1(:,1));
    % first save the area
    area(n,1) = cuex1(n,1);
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuex2(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuex2(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,3) = lowest;
    area(n,2) = cuex2(lowest,1);
    
    
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuex3(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuex3(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,4) = lowest;
    area(n,3) = cuex3(lowest,1);
    
    
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuex4(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuex4(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,5) = lowest;
    area(n,4) = cuex4(lowest,1);
    
    
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuec1(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuec1(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,6) = lowest;
    area(n,5) = cuec1(lowest,1);
    
    
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuec2(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuec2(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,7) = lowest;
    area(n,6) = cuec2(lowest,1);
    
    
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuec3(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuec3(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,8) = lowest;
    area(n,7) = cuec3(lowest,1);
    
    
    clear m
    % now cycle through each other shape
    clear diff
    for m = 1:length(cuec4(:,1));
        % find the difference of each, and look for the minimum difference
        diff(m) = abs(cuex1(n,1) - cuec4(m,1));
    end
    clear lowest
    lowest = find(diff == min(diff),1);
    % then save the coordinate for the relevant row in cuex1 and the minimum diff area
    cuex1(n,9) = lowest;
    area(n,8) = cuec4(lowest,1);
end


% now look at each row of areas
clear n
for n = 1:length(area(:,1));
    area(n,9) = range(area(n,1:8));
end

% find the minimum variability
% square
final = cuex1(find(area(:,9) == min(area(:,9)),1),:);
% circle (radius)
final(2,3) = cuex2(final(1,3),2);
% equilateral triangle (width then height)
final(2,4) = cuex3(final(1,4),2);
final(3,4) = cuex3(final(1,4),3);
% parallelogram (width rectangle, height, width each triangle at the side)
final(2,5) = cuex4(final(1,5),2);
final(3,5) = cuex4(final(1,5),3);
final(4,5) = cuex4(final(1,5),4);
% hexagon (height of the rectangle, height of the triangle)
final(2,6) = cuec1(final(1,6),2);
final(3,6) = cuec1(final(1,6),3);
% rhombus (width/height)
final(2,7) = cuec2(final(1,7),2);
% rectangle (height then width)
final(2,8) = cuec3(final(1,8),2);
final(3,8) = cuec3(final(1,8),3);
% trapezoid (width rectangle, height, width each triangle at the side)
final(2,9) = cuec4(final(1,9),2);
final(3,9) = cuec4(final(1,9),3);
final(4,9) = cuec4(final(1,9),4);
