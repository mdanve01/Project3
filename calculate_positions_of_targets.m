clear all
% set the resolution
x = 1024;
y = 768;

% sets the pole coordinates depending upon the orientation wanted
top = 270;
bottom = 90;

% set whether you want the first coordinate to be at the top or bottom
first = top;

% need to calcualte positions around a circle.
radius = 240;

% set the numebr of targets
num_tar = 3;

% the full circle is 360 degrees, I want a target every 'd' degrees saved
% in the 'targ' variable
d = 360 ./ num_tar;
clear n
for n = 1:num_tar;
    targ(n) = first + ((n - 1) .* d);
    if targ(n) > 360;
        targ(n) = targ(n) - 360;
    end
end

% radian is the standard unit of angular measure, and is calculated for
% each of these positions. In half a circle there are pi radians, and so a
% radian = 180 / pi
rad = 180 ./ pi;
clear n
for n = 1:num_tar;
    radian(n) = targ(n) ./ rad;
end

% calculate x,y
clear n
for n = 1:num_tar;
    coordinate(n,1) = (radius .* cos(radian(n))) + (x ./ 2);
    coordinate(n,2) = (radius .* sin(radian(n))) + (y ./ 2);
end

% plot to check
clear n
figure(1);
for n = 1:num_tar;
    scatter(coordinate(n,1),coordinate(n,2));
    hold on
end
xlim([0 x]);
ylim([0 y]);
% reverse the y axis as it runs from top to bottom in Eyelink coordinates
ax = gca; 
ax.YDir = 'reverse';;
hold off;


% check distances between targets, calculates the hypotenuse for every
% neighbouring pair.
clear n
for n = 1:num_tar-1;
    distances(n) = sqrt(((coordinate(n,1)-coordinate(n+1,1))^2) + ((coordinate(n,2)-coordinate(n+1,2))^2));
end
distances(num_tar) = sqrt(((coordinate(num_tar,1)-coordinate(1,1))^2) + ((coordinate(num_tar,2)-coordinate(1,2))^2));

% check that all hypotenuse are equal when rounded up to the nearest
% coordiante
tot_diff = round(max(distances) - min(distances));
if tot_diff == 0;
    "all hypotenuse of equal distance"
else
    "hypotenuse differ"
end
