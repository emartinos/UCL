function LISTS = SKEWlistmaker(PROBS, AMOUNTS)
%Skewness listmaker 2: construct a list or lists of lotteries, of matched EV, 
% but varying in skew  and variance
% pin = .1; %interval to increment probability
% PROBS=[0:pin:.9];       %what probabilities to use, needs to be even
% AMOUNTS= [0:.1:1.1];    %what amounts to use , needs to be even for rest of code to work!


calculate = 3; %calculate the stats of the gambles
calculate_selected = 0; %switch to 1 if you want to calculate the var/skew just of selection for speed
save_list = 1; %save the list as SKEW_list
selectev = 1; %select out certain EV range
plotting = 0;
test = 0;
EVx = .6;
tol = .02;

%save parameters
    if test
        savestr = '_test';
    else
        savestr = input('\n\nWhat should the list be called: SKEW_list...?', 's');
    end


A = []; B=[]; C = []; D = []; E = []; EV = []; Var = []; Skew = [];
amounts = AMOUNTS;
probs = PROBS;
%now make a list of all possible amount x probability combinations, from
%which we will select appropriately
%need to do this in parts, as fullfact is limited


%there are length(amounts) possible spaces to put length(probs)
%possible probabilities
%if 1 probability level - no legal combs as no p=1
rr = 1; PLIST.A =[];
disp('evaluating plevel 1')
for a = 2:length(probs)
    selection = [probs(a)];
    if sum(selection) >.99 & sum(selection)<1.01
        PLIST.A(rr, :) = selection;
        rr = rr + 1;
    end
end
%if 2 p levels, work out legal combs:
rr = 1;
disp('evaluating plevel 2')

for b = 2:length(probs)
    for a = 2:length(probs)
        selection = [probs(a) probs(b)];
        if sum(selection) > 1
            break
        elseif sum(selection) == 1
            PLIST.B(rr, :) = selection;
            rr = rr + 1;
        end
    end
end
%if 3 p levels
rr = 1;
disp('evaluating plevel 3')

for c = 2:length(probs)
    for b = 2:length(probs)
        for a = 2:length(probs)
            selection = [probs(a) probs(b) probs(c)];
            if sum(selection) > 1
                break
            elseif  sum(selection) >.99 & sum(selection)<1.01
                PLIST.C(rr, :) = selection;
                rr = rr + 1;
            end
        end
    end
end
%if 4 p levels
rr = 1;
disp('evaluating plevel 4')

for d = 2:length(probs)
    for c = 2:length(probs)
        for b = 2:length(probs)
            for a = 2:length(probs)
                selection = [probs(a) probs(b) probs(c) probs(d)];
                if sum(selection) > 1
                    break
                elseif  sum(selection) >.99 & sum(selection)<1.01
                    PLIST.D(rr, :) = selection;
                    rr = rr + 1;
                end
            end
        end
    end
end

%if 5 p levels
rr = 1;
disp('evaluating plevel 5')

for e = 2:length(probs)
    for d = 2:length(probs)
        for c = 2:length(probs)
            for b = 2:length(probs)
                for a = 2:length(probs)
                    selection = [probs(a) probs(b) probs(c) probs(d) probs(e)];
                    if sum(selection) > 1
                        break
                    elseif  sum(selection) >.99 & sum(selection)<1.01
                        PLIST.E(rr, :) = selection;
                        rr = rr + 1;
                    end
                end
            end
        end
    end
end

%if 6 p levels
rr = 1;
disp('evaluating plevel 6')

for f = 2:length(probs)
    for e = 2:length(probs)
        for d = 2:length(probs)
            for c = 2:length(probs)
                for b = 2:length(probs)
                    for a = 2:length(probs)
                        selection = [probs(a) probs(b) probs(c) probs(d) probs(e) probs(f)];
                        if sum(selection) > 1
                            break
                        elseif  sum(selection) >.99 & sum(selection)<1.01
                            PLIST.F(rr, :) = selection;
                            rr = rr + 1;
                        end
                    end
                end
            end
        end
    end
end

%if 7 p levels
rr = 1;
disp('evaluating plevel 7')

for g = 2:length(probs)
    for f = 2:length(probs)
        for e = 2:length(probs)
            if sum([probs(g) probs(f) probs(e)])>1
                break
            end
            for d = 2:length(probs)
                for c = 2:length(probs)
                    for b = 2:length(probs)
                        for a = 2:length(probs)
                            selection = [probs(a) probs(b) probs(c) probs(d) probs(e) probs(f) probs(g)];
                            if sum(selection) > 1
                                break
                            elseif  sum(selection) >.99 & sum(selection)<1.01
                                PLIST.G(rr, :) = selection;
                                rr = rr + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

%if 8 p levels
rr = 1;
disp('evaluating plevel 8')

for h = 2:length(probs)
    
    for g = 2:length(probs)
        if sum([probs(g) probs(h)])>1
            break
        end
        for f = 2:length(probs)
            if sum([probs(h) probs(g) probs(f)])>1
                break
            end
            for e = 2:length(probs)
                if sum([probs(e) probs(f) probs(g) probs(h)])>1
                    break
                end
                for d = 2:length(probs)
                    if sum([probs(d) probs(e) probs(f) probs(g) probs(h)])>1
                        break
                    end
                    for c = 2:length(probs)
                        if sum([probs(c) probs(d) probs(e) probs(f) probs(g) probs(h)])>1
                            break
                        end
                        for b = 2:length(probs)
                            if sum([probs(b) probs(c) probs(d) probs(e) probs(f) probs(g) probs(h)])>1
                                break
                            end
                            for a = 2:length(probs)
                                selection = [probs(a) probs(b) probs(c) probs(d) probs(e) probs(f) probs(g) probs(h)];
                                if sum(selection) > 1
                                    break
                                elseif  sum(selection) >.99 & sum(selection)<1.01
                                    PLIST.H(rr, :) = selection;
                                    rr = rr + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


%if 9 p levels
rr = 1;
disp('evaluating plevel 9')

for i = 2:length(probs)
    for h = 2:length(probs)
        for g = 2:length(probs)
            if sum([probs(i) probs(h) probs(g)])>1
                break
            end
            for f = 2:length(probs)
                sa = [probs(f) probs(g) probs(h) probs(i)];
                if sum(sa)>1
                    break
                end
                for e = 2:length(probs)
                    sa = [ probs(e) probs(f) probs(g) probs(h) probs(i)];
                    if sum(sa)>1
                        break
                    end
                    for d = 2:length(probs)
                        sa = [probs(d) probs(e) probs(f) probs(g) probs(h) probs(i)];
                        if sum(sa)>1
                            break
                        end
                        for c = 2:length(probs)
                            sa = [probs(c) probs(d) probs(e) probs(f) probs(g) probs(h) probs(i)];
                            if sum(sa)>1
                                break
                            end
                            for b = 2:length(probs)
                                sa = [probs(b) probs(c) probs(d) probs(e) probs(f) probs(g) probs(h) probs(i)];
                                if sum(sa)>1
                                    break
                                end
                                for a = 2:length(probs)
                                    selection = [probs(a) probs(b) probs(c) probs(d) probs(e) probs(f) probs(g) probs(h) probs(i)];
                                    if sum(selection) > 1
                                        break
                                    elseif  sum(selection) >.99 & sum(selection)<1.01
                                        PLIST.I(rr, :) = selection;
                                        rr = rr + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

%if 10 p levels
rr = 1; PLIST.J = [];
disp('evaluating plevel 10')
for j=2:length(probs)
    for i = 2:length(probs)
        for h = 2:length(probs)
            if sum([probs(j) probs(i) probs(h)])>1
                break
            end
            for g = 2:length(probs)
                sa = [probs(g) probs(h) probs(i) probs(j)];
                if sum(sa)>1
                    break
                end              
                for f = 2:length(probs)
                    sa = [probs(f) probs(g) probs(h) probs(i) probs(j)];
                    if sum(sa)>1
                        break
                    end
                    for e = 2:length(probs)
                        sa = [ probs(e) probs(f) probs(g) probs(h) probs(i) probs(j)];
                        if sum(sa)>1
                            break
                        end
                        for d = 2:length(probs)
                            sa = [probs(d) probs(e) probs(f) probs(g) probs(h) probs(i) probs(j)];
                            if sum(sa)>1
                                break
                            end
                            for c = 2:length(probs)
                                sa = [probs(c) probs(d) probs(e) probs(f) probs(g) probs(h) probs(i) probs(j)];
                                if sum(sa)>1
                                    break
                                end
                                for b = 2:length(probs)
                                    sa = [probs(b) probs(c) probs(d) probs(e) probs(f) probs(g) probs(h) probs(i) probs(j)];
                                    if sum(sa)>1
                                        break
                                    end
                                    for a = 2:length(probs)
                                        selection = [probs(a) probs(b) probs(c) probs(d) probs(e) probs(f) probs(g) probs(h) probs(i) probs(j)];
                                        if sum(selection) > 1
                                            break
                                        elseif  sum(selection) >.99 & sum(selection)<1.01
                                            PLIST.J(rr, :) = selection;
                                            rr = rr + 1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
%now that we have an exhaustive list of allowed probabilities, we need to
%find all the ways of arranging them in length(amounts) boxes

%use nchoosek, which will return the combinations, not permutations, of n,
%chosen k at a time

disp('evaluating tPLIST.A')
tPLIST.A = skewlist1(amounts, PLIST.A);
disp('evaluating tPLIST.B')
tPLIST.B = skewlist1(amounts, PLIST.B);
disp('evaluating tPLIST.C')
tPLIST.C = skewlist1(amounts, PLIST.C);
disp('evaluating tPLIST.D')
tPLIST.D = skewlist1(amounts, PLIST.D);
disp('evaluating tPLIST.E')
tPLIST.E = skewlist1(amounts, PLIST.E);
disp('evaluating tPLIST.F')
tPLIST.F = skewlist1(amounts, PLIST.F);
disp('evaluating tPLIST.G')
tPLIST.G = skewlist1(amounts, PLIST.G);
disp('evaluating tPLIST.H')
tPLIST.H = skewlist1(amounts, PLIST.H);
disp('evaluating tPLIST.I')
tPLIST.I = skewlist1(amounts, PLIST.I);
disp('evaluating tPLIST.J')
tPLIST.J = skewlist1(amounts, PLIST.J);

%concatenate the tPLISTs

fPLIST = [tPLIST.A; tPLIST.B; tPLIST.C; tPLIST.E; tPLIST.F; tPLIST.G; tPLIST.H; tPLIST.I; tPLIST.J];
str = ['length of fPLIST: ' num2str(length(fPLIST))]


if calculate >=1
    % %calculate the EV of each row on the list
    disp('calculating EV')
    EV=fPLIST*amounts';
    LISTS.evfPLIST = [fPLIST EV];
    for rr = double('A'):double('J')
        LISTS.evtPLIST.(char(rr)) = tPLIST.(char(rr))*amounts';
    end
    skewsavelist(save_list, savestr, LISTS)
end
% 
if calculate>=2
    %calculate the variance and skew of each row on the list
    disp('calculating variance and skew')
    for i = 1:length(fPLIST)
        disp([str ' now on number: ' num2str(i)])
%         Var(i) = fPLIST(i,:)*((amounts - EV(i)).^2)';
        k = find(fPLIST(i,:)>0);
        Var(i) = fPLIST(i,k)*((amounts(k) - EV(i)).^2)';
        if Var(i)~=0
%             Skew(i) = (fPLIST(i,:)*((amounts - EV(i)).^3)')./sqrt(Var(i)).^3;
            Skew(i) = (fPLIST(i,k)*((amounts(k) - EV(i)).^3)')./sqrt(Var(i)).^3;
        else
            Skew(i) = 0;
        end
    end
    LISTS.sfPLIST=[fPLIST EV Var' Skew'];
    skewsavelist(save_list, savestr, LISTS)
end
%some other statistical features to calculate
%lower partial moment
%downside risk
if calculate>=3
    %entropy
    %entropy just depends on number of outcomes and their probabilities, not on
    %loss function
    %i.e. sum(p.log(p)), but need to exclude 0 entries
    disp('calculating entropy')
    Entropy =zeros(length(fPLIST),1);
    for gg =1:length(fPLIST)
        disp([str  ' Entropy calculation;' ' now on number: ' num2str(gg)])
        Entropy(gg) = fPLIST(gg,fPLIST(gg,:)>0)*(log(fPLIST(gg,fPLIST(gg,:)>0)'));
    end
    LISTS.Entropy = Entropy;
    skewsavelist(save_list, savestr, LISTS)
end

LISTS.PLIST =  PLIST;
LISTS.tPLIST = tPLIST;
LISTS.fPLIST = fPLIST;

skewsavelist(save_list, savestr, LISTS)

if test
    LISTS.selected.test = LISTS.selected.Z(floor(rand(10,1)*length(LISTS.selected.Z)),:);
end

function skewsavelist(save_list, str, LISTS)

if save_list
     cd('\\abba\stimuli\Task_repository\NeuroSciPsychNet\MeanVarSkew3');
    % cd('C:\Documents and Settings\msymmond\Desktop\SKEWNESS\code');
    ver = version;

    if str2num(ver(1))>6
        save(['SKEW_list' str], 'LISTS', '-v6')
    else
        save(['SKEW_list' str], 'LISTS')
    end
end

function  tLIST = skewlist1(amounts, LIST)

kk = size(LIST,2);
V = nchoosek(1:length(amounts), kk);
tLIST = zeros(size(V,1)*size(LIST,1), length(amounts));
tt = 1;
for pp = 1:size(LIST,1)
    for vv =  1:size(V,1)
        tLIST(tt, V(vv,:)) = LIST(pp,:);
        tt = tt+1;
    end
end

