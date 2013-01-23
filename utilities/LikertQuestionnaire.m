function DATA = LikertQuestionnaire (DATA)
%
% Delivers just one questionnaire, whose items are to be found in 
% 'items.txt', which should include the whole path.
% Adapted code from the work of Mona Gavert, 2012.

format short

%% Open questions to probe implicit/explicit behavior

fid = fopen('../textfiles/ICU.txt');
ICU = textscan(fid,'%s','Delimiter','\t');
fclose(fid);

fid = fopen('../textfiles/AQ.txt');
AQ_ = textscan(fid,'%s','Delimiter','\t');
fclose(fid);

fid = fopen('../textfiles/BFS.txt');
BFS = textscan(fid,'%s','Delimiter','\t');
fclose(fid);

for i = 1:4
    option(i) = eval(sprintf('DATA.keymap.K%d',i));
end


tests = ['ICU';'AQ_';'BFS'];

for h = 1:length(tests)
    scale.ICU = ['Not at all true'; ' Somewhat true '; '   Very true   '; 'Definitely true'];
    scale.AQ_ = ['Definitely disagree'; ' Slightly disagree '; '  Slightly agree   '; ' Definitely agree  '];
    scale.BFS = ['    False    '; 'Slightly true'; ' Mainly true '; '  Very true  '];

    CQ = eval(tests(h,:));
    scale = scale.(tests(h,:));
    
    setforecolour(1,1,1);
    settextstyle('Arial', 36)
    preparestring(sprintf('Questionnaire  %d',h),1,0,70)
    preparestring('Ready? Press any key to continue...',1,0,-70)
    drawpict(1)
    clearpict(1)
    waitkeydown (inf);
    
    for jk = 1:length(CQ{1,1})
        
        setforecolour(1,1,1);
        settextstyle('Arial narrow', 30);
        todisp = cell2mat(CQ{1,1}(jk));
        stop = strfind(todisp, '  ');
        if isempty(stop)
            stop = length(todisp);
        end
        
        preparestring(todisp(1:stop),1,0,140);
        preparestring(todisp(stop+1:end),1,0,100);
    
        for k = 1:4
            settextstyle('Arial', 30);
            preparestring(sprintf('%u',k),1,-450+k*180, -30)
            settextstyle('Arial narrow', 28)
            preparestring(scale(k,:),1,-450+k*180, -60)
        end
        tcue = drawpict(1);

        % Highlight choice
        [k keyt n] = waitkeydown(inf, option);    
        setforecolour(1,1,0)
        i = find(option==k);
        settextstyle('Arial', 30);
        preparestring(sprintf('%u',i),1,-450+i*180, -30)
        settextstyle('Arial narrow', 28)
        preparestring(scale(i,:),1,-450+i*180, -60)
        drawpict(1);
        clearpict(1);
        wait(500);

        RT = keyt - tcue;

        DATA.CQ.(tests(h,:)).question(jk) = jk;
        DATA.CQ.(tests(h,:)).option(jk) = find(option==k);
        DATA.CQ.(tests(h,:)).RT(jk) = RT;    

    end
end