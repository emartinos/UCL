function listout = SKEW_generatestimuluslists(numblocks, trials_per_block, sure_amounts, entryix)
% This function loads a stimulus list, pre-generated with SKEWLIST_maker. It
% is used in SKEW_get_list2 as per LIST = SKEW_generatestimuluslists(...
% Iinput arguments are:
%   sure amounts
%   number of trials
% Mkael Symmonds 16-7-9; Adaptations by Michael Moutoussis for NSPN


if entryix ==1
    entrystr = 'test';
elseif entryix==2
    entrystr = 'pilotsession1';
elseif entryix ==3;
    entrystr = 'pilottesting1';
elseif entryix ==4;
    entrystr = 'pilottesting2';
% elseif entryix ==6;
%     entrystr = 'pilottesting3';
elseif entryix == 5
    entrystr = 'NSPNscanning1';
elseif entryix == 6
    entrystr = 'NSPNscanning1';
elseif entryix == 10
    entrystr = 'scannertest1';
elseif entryix == 11
    entrystr = 'scannertest2';
end


%generate or load the list
switch entrystr
    case 'test'
        replistno = 1;
        load('SKEW_list_test.mat')
        listin = LISTS.selected.test;
        
    case {'pilotsession1', 'scannertest1'}
        replistno = 1;
        load('SKEW_list_testsess1_130_65_02.mat')
        % originally: load('SKEW_list_practice_130_45_05.mat')
        listin = LISTS.Gridchosen.list;
        
        listin = listin(randperm(size(listin,1)), :);
        surelist1 = reshape(repmat(sure_amounts, ceil(numblocks./length(sure_amounts)),1),numblocks,1);
        surelist2 = surelist1(randperm(length(surelist1)));
        surelistfin = surelist2(1:numblocks); %this will be properly randomised if the number of blocks is a multiple of number of sure amounts
        list = [];
        for jj = 1:numblocks./replistno
            list = [list; repmat(-surelistfin(jj),1,size(listin,2)); listin(((jj-1)*trials_per_block)+1:jj*trials_per_block,:)];
        end
        listout = list;
        
        
    case {'pilottesting1', 'pilottesting2', 'pilottesting3', 'scannertest2'}
        replistno = 3;
        if strcmp(entrystr, 'pilottesting1') | strcmp (entrystr, 'scannertest2')
            load('SKEW_list_testsess1_130_65_02.mat')
            listin = LISTS.Gridchosen.list;
        else
            load('SKEW_list_testsess1_130_65_02_pm.mat')
            listin = LISTS.Gridchosen2;
        end
        lout = [];
        for p = 1:replistno
            %randomise order of list
            listin = listin(randperm(size(listin,1)), :);
            %now insert a sure amount line every <trials_per_block>.
            
            %generate a randomised list of the sure amounts.
            % surelist1 = reshape(repmat(sure_amounts, ceil(numblocks./length(sure_amounts)),1),numblocks,1);
            % surelist2 = surelist1(randperm(length(surelist1)));
            % surelistfin = surelist2(1:numblocks); %this will be properly randomised if the number of blocks is a multiple of number of sure amounts
            surelistfin = ones(1,size(listin,1))*sure_amounts(p);    
            
            %now combine together list with the entries for the sure amounts 
            list = [];
            for jj = 1:numblocks./replistno
                list = [list; repmat(-surelistfin(jj),1,size(listin,2)); listin(((jj-1)*trials_per_block)+1:jj*trials_per_block,:)];
            end
            lout = [lout; list];
        end
        %randomise the blocks - rix is start trial of each block,
        %randomised order
        rix = (randperm(numblocks)*(trials_per_block+1))- trials_per_block;
        listout = [];
        for k =1:length(rix)
            listout = [listout; lout(rix(k):rix(k)+trials_per_block, :)];
        end
        
    case 'NSPNscanning1' % This uses MEG-style input files.
        % Attempt to change to RS3_generatestimululist code
        replistno = 1;
        % A = load('EV_Var_list_RD1.mat')
        A = load('pies_spec.mat')
        
        listin = [A.trl_set];
        listin = repmat(listin, replistno,1);
        listin = listin(randperm(size(listin,1)), :); %this line randomises
                                                      %the order of stimulus
                                                      %presentation

        % Prepare to insert sure amount information:
        surelist1 = reshape(repmat(sure_amounts, ceil(numblocks./length(sure_amounts)),1),numblocks,1);
        surelist2 = surelist1(randperm(length(surelist1)));
        surelistfin = surelist2(1:numblocks); %this will be properly randomised if the number of blocks is a multiple of number of sure amounts
 
       list = [];
        for jj = 1:numblocks./replistno
            list = [list; repmat(-surelistfin(jj),1,size(listin,2)); listin(((jj-1)*trials_per_block)+1:jj*trials_per_block,:)];
        end
        listout = list;
        
        %for kk=1:size(listin,1)
        %   rp = randperm(4);
        %   listout(kk,:) = listin(kk, [rp, rp+4]); %this randomises the order of segments within a pie stimulus
        %end

    case 'NSPNscanning2' %'old-fashioned' type stimuli for orinal fMRI code
        
        replistno = 1;
        load('MVS3opt5_stim_list.mat')
        listin = LISTS.Gridchosen.list;
        
        listin = listin(randperm(size(listin,1)), :);
        
        surelist1 = reshape(repmat(sure_amounts, ceil(numblocks./length(sure_amounts)),1),numblocks,1);
        surelist2 = surelist1(randperm(length(surelist1)));
        surelistfin = surelist2(1:numblocks); %this will be properly randomised if the number of blocks is a multiple of number of sure amounts
        list = [];
        for jj = 1:numblocks./replistno
            list = [list; repmat(-surelistfin(jj),1,size(listin,2)); listin(((jj-1)*trials_per_block)+1:jj*trials_per_block,:)];
        end
        listout = list;                
        
end

