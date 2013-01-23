function [LISTS, point, ix, min_ix, stats] = SKEWselectstimfromlist(LISTS, amounts)
%function to select out stimuli from list of all possible stimuli

calculate =2;
plotting = 1;
practice = 1;
saveop = 1;
limitseg = [0]; %impose a limit on the segment numbers?
reps =1; %how many stimuli to pick for each grid point?

if practice==1
EVx = .45
tol = .05 
savestr = 'SKEW_list_practice_130_45_05';
elseif practice == 2
    EVx = .65
    tol = .02
    savestr = 'SKEW_list_testsess1_130_65_02';
end

LISTS.selected.EVmin = EVx-tol;
LISTS.selected.EVmax = EVx+tol;

if calculate==1
    strg = 'evf';
elseif calculate>=2
    strg = 'sf';
end

strgg = [strg 'PLIST'];
if ~limitseg
LISTS.selected.Y = LISTS.(char(strgg))(find(LISTS.(char(strgg))(:,length(amounts)+1)>EVx-tol & LISTS.(char(strgg))(:,length(amounts)+1)<EVx+tol), :);
else %select out only gambles with certain range of options
    crit  = find((LISTS.(char(strgg))(:,length(amounts)+1)>EVx-tol & LISTS.(char(strgg))(:,length(amounts)+1)<EVx+tol) & ...
        sum(LISTS.(char(strgg))(:,1:length(amounts))>0,2)>=limitseg(1) & sum(LISTS.(char(strgg))(:,1:length(amounts))>0,2)>=limitseg(2));
LISTS.selected.Y = LISTS.(char(strgg))(crit, :);
end


if plotting
    %plot the selected gambles
    A = LISTS.selected.Y;
%     plot3(A(:,end-2), A(:,end-1), A(:, end), '.')  
     plot(A(:,end-1), A(:, end), '.')  
    
    %     set(gca, 'xlim', [0.05 0.15], 'ylim', [-1.5, 1.5])
end

%use the grid select program to select out a grid of stimuli
A = A(:, end-1:end);
[point, ix, min_ix, stats]  = SKEW_pickstimpoints(A, amounts, reps, practice);

%now check a few things about selected list
Gridchosen = LISTS.selected.Y(min_ix, :);
check =0
if check
    Sk = Gridchosen(:, end);
    Va = Gridchosen(:, end-1);
    EV = Gridchosen(:, end-2);
    Ent= LISTS.Entropy(min_ix);

    plot(Va,Sk, '.'); %this should look the same as before i.e. a grid
plot3(EV, Va, Sk, '.') ; %check no induced correlation between EV and either dimension

%check the entropy
plot3(Ent, Va, Sk, '.');

%and see if orthogonal
stats.Orthog.SkVa = Sk'*Va;
stats.Orthog.SkEV = Sk'*EV;
stats.Orthog.SkEnt =  Sk'*Ent;
stats.Orthog.VaEV =  Va'*EV;
stats.Orthog.VaEnt =  Va'*Ent;


%make a new vector that states how many segments the pie charts have
Stims = Gridchosen(:, 1:size(amounts, 2));
for jj = 1:size(Gridchosen, 1)
    nseg(jj) = sum(Stims(jj, :)>0);    
end
plot3(nseg, Va, Sk, '.'); %make sure that number of segments not correlated with either stim dimension
[stats.rnseg, stats.pnseg] = corrcoef([nseg', Va, Sk, EV])
end
LISTS.Gridchosen.list = Gridchosen;

if saveop == 1
    LISTS.Gridchosen.stats = stats;
    save(savestr, 'LISTS');
end