function [point, ix, min_ix, stats]  = SKEW_pickstimpoints(A, amounts, reps, practice)
%function to select out a set independent stimuli from a 2-d surface
test = 0;

if test
reps = 5;
n=20000
A = repmat([1 10], n, 1).*rand(n,2)
cov(A)
%find average points
stats.M = mean(A);
stats.wid = max(A) - min(A);

else
    %ask for xmax, xmin points, ymax, ymin points
    stats.xmax = input('input maximum variance:  ');
    stats.xmin = input('input mimimum variance:  ');
    stats.ymax = input('input maximum skewness:  ');
    stats.ymin = input('input mimimum skewness:  ');
    stats.M = mean([stats.xmax stats.ymax; stats.xmin stats.ymin]);
    stats.wid = [stats.xmax - stats.xmin,  stats.ymax-stats.ymin];
end

%pick grid points along axes
if practice ==1 %practice session - 20 points
    np.x = 5;
    np.y = 4;
elseif practice ==2
    np.x = 10;
    np.y = 6; 
else
    
np.x = 10;
np.y = 10;
end
st = [double('x') double('y')]
for str = 1:2
% ix.(char(st(str))) = min(A(:,str)):1/np.(char(st(str))):max(A(:,str))
ix.(char(st(str))) = stats.M(str) - stats.wid(str).*.9/2: stats.wid(str)/np.(char(st(str))) : stats.M(str) + stats.wid(str).*.9/2;
ix.(char(st(str))) = ix.(char(st(str))) - mean(ix.(char(st(str)))) +stats.M(str); %mean correct
end

%generate grid of points
grid = fullfact([length(ix.x), length(ix.y)]);
for i = 1:size(grid,1)
    ix.grid(i,:) = [ix.x(grid(i, 1)) ix.y(grid(i,2))]
end



%go through grid, and for each point find the stimulus point closest to it
B = [A, ones(size(A,1),1)]; %B has a list of ones to tick off as points are used
for rep = 1:reps %how many reps
for p = 1:length(ix.grid)
    K = repmat(ix.grid(p,:),size(A,1),1)-A; %x and y distances between grid and stimuli
    K2 = sqrt((K(:,1)./stats.wid(1)).^2 + (K(:,2)./stats.wid(2)).^2); 
    % normalised Euclidean distance (we want the selected points 
    % to be as close as poss to the grid in both stimulus dimensions 
    % this requires the scale of both dimensions to be normalised
    % (otherwise the dimension with the larger scale will be more important
    % for the distance calculation) - changed on 13-7-9
    [dist(p+(rep-1)*length(ix.grid)) min_ix(p+(rep-1)*length(ix.grid))] = min(K2.*B(:,3)); %find minimum distance point (out of not yet chosen)
    point(p+(rep-1)*length(ix.grid),:) = B(min_ix(p+(rep-1)*length(ix.grid)), 1:2); %save point
    B(min_ix(p+(rep-1)*length(ix.grid)),3) = Inf; %set to a very large number if used point
end
end

%plot so we can check if ok

plot(A(:,1), A(:,2), '.', 'MarkerSize', 2);
hold on 
plot(ix.grid(:,1), ix.grid(:,2), '.g', 'Markersize', 18)
hold on
plot(point(:,1), point(:,2), '.r')

%how correlated are the generated stimulus points?
[stats.r stats.p] = corrcoef(point);