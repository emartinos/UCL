function  [data] = GNGb0_learning_task_display ( params, xloc1,xloc2, LKey,RKey )
% learning_task_display ( params, xloc1,xloc2, LKey,RKey )
% real_like_practice is for the learning version of the experiment, usu. outside the scanner. 
% It saves a file with all its results in LearnVerData, and returns the same.
          
% - - Constants - - 
nPerCond = 1; % A minimum, default value of practice trials per condition.
if (params.NperCond > nPerCond)  % i.e. ignore input argument if too small!
    nPerCond = params.NperCond;
end
realPracticeTrialN = 4*2*nPerCond; % = 4 conditions x 2 sham/targeted x nPerCond

%  Matrices for presentation of stimuli during learning w.out f/b:
if params.session_training ~= 2 % this function will be used for learning or
                                % already trained mainly, defensive coding here ...
    trialTarget=repmat([1 1],    [1,nPerCond]  );  % 1: real trial; No sham trials !
else
    trialTarget=repmat([1 2],    [1,nPerCond]  );  % 1 real trial; 2 sham trial
    disp('Warning: learning_task_display used with *.session_training flag at 2 !');
end 
trialType  =repmat([1 2 3 4],[1,2*nPerCond]);  % 1 go reward; 2 go punishment; 3 no-go reward; 4 no-go punishment
% Randomize the sequence of presentation of all 4 trial types now in
% trialType. This will determine the cues presented at each trial.
randTrialType=trialType(randperm(size(trialType,2)));

trialNumber=[randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))'];

trialCounter=[0 0 0 0]; % Helps count trials locally

TargetTime=params.minTargetTime + rand(1,realPracticeTrialN)*params.TargetTimeSpan;
trialsITI=params.minITI + rand(1,realPracticeTrialN)*params.minITI;
 
preparestring('每个实验中你会看到四个图片中的一个; 这些信号',c.InstructScreen,0,150);
preparestring('表明应做的事. 图片之后会有一个十字,',c.InstructScreen,0,110);
preparestring('然后是一个圆圈. 圆圈表明你必须立即做决定',c.InstructScreen,0,70);
preparestring('要做什么. 有时你必须按键来回应.',c.InstructScreen,0,30);
preparestring('有时你要不按键来得到好的结果.',c.InstructScreen,0,-10);
preparestring('每个实验你会看到是否赢钱（上箭头），输钱',c.InstructScreen,0,-50);
preparestring('(下箭头) 或者不赢不输 (黄色横线).你的任务是',c.InstructScreen,0,-90);
preparestring('找到每个图片的最佳反应, 以赢取最多的钱.',params.InstructScreen,0,-130);
preparestring('...按空格继续',params.InstructScreen,250,-275);

drawpict(params.InstructScreen);
waitkeydown(inf,71);
clearpict(params.InstructScreen);

for count=1:realPracticeTrialN 

    trialCue=randTrialType(count);
    trialCounter(trialCue)=trialCounter(trialCue)+1;
    CurrentTrial=trialNumber(trialCounter(trialCue),trialCue);
    CurrentTrialTarget=trialTarget(CurrentTrial);

    Time2Target=TargetTime(count);
    ITI_trial=trialsITI(count);

    [localData] = GNGb0_task_display(trialCue,Time2Target,CurrentTrialTarget, ...
                          xloc1,xloc2,params.TargetDisplayTime, ...
                          ITI_trial,params.randCSs,params.scr,LKey,RKey);

    LearnVerData(count,:)=[count localData];
end

fName = [params.data_dir,'\',params.subj_name,'_GNGb0_LearnVerData_', datestr(now,'yyyy-mm-dd_HH_MM')];
save(fName,'LearnVerData');
DateStr = datestr(now,'yyyy-mm-dd_HH_MM');
whereWeWere = pwd;
cd(params.data_dir);
fName = [params.subj_name,'_GNGb0_workspace_',num2str(params.session),'_',DateStr];
eval( ['save ' fName] );
cd(whereWeWere);

preparestring('+',params.InstructScreen)
drawpict(params.InstructScreen);
wait(1000);
clearpict(params.InstructScreen);
    
preparestring(['谢谢! 这一部分的回应-阻止任务结束了.'],params.InstructScreen)
%preparestring(['You have won ' num2str(sum(LearnVerData(:,17))) ' ''coins'' in this task'],params.InstructScreen)
drawpict(params.InstructScreen);
wait(5000);
clearpict(params.InstructScreen);

data = LearnVerData;

