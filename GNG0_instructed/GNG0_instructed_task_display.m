function  [data] = GNG0_instructed_task_display ( params, xloc1,xloc2, LKey,RKey )
% function  [data] = GNG0_instructed_task_display ( params, xloc1,xloc2, LKey,RKey )
% This version for the nonlearning / instructed version of the experiment, usu. outside the scanner. 
% It saves a file with all its results in InstructedData, and returns the same.
          
% - - Constants - - 
nPerCond = 1; % A minimum, default value of practice trials per condition.
if (params.NperCond > nPerCond)  % i.e. ignore input argument if too small!
    nPerCond = params.NperCond;
end
realPracticeTrialN = 4*2*nPerCond; % = 4 conditions x 2 sham/targeted x nPerCond

%  Matrices for presentation of stimuli w.out f/b:
if params.scanner == 0 % this function will be mostly used outside scanner
    trialTarget=repmat([1 1],    [1,nPerCond]  );  % 1: real trial; No sham trials !
else
    trialTarget=repmat([1 2],    [1,nPerCond]  );  % 1 real trial; 2 sham trial
    disp('Reminder: instructed_task_display used with *.scanner nonzero. ');
end 
trialType  =repmat([1 2 3 4],[1,2*nPerCond]);  % 1 go reward; 2 go punishment; 3 no-go reward; 4 no-go punishment
% Randomize the sequence of presentation of all 4 trial types now in
% trialType. This will determine the cues presented at each trial.
randTrialType=trialType(randperm(size(trialType,2)));

trialNumber=[randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))'];

trialCounter=[0 0 0 0]; % Helps count trials locally

TargetTime=params.minTargetTime + rand(1,realPracticeTrialN)*params.TargetTimeSpan;
trialsITI=params.minITI + rand(1,realPracticeTrialN)*params.minITI;
 
preparestring('现在你要开始 ''玩真钱了'': ',params.InstructScreen,0,150);
preparestring('在这部分你赚的游戏币越多,',params.InstructScreen,0,110);
preparestring('结束时你就会得到更多的真钱.',params.InstructScreen,0,70);
preparestring('若有任何问题请询问研究人员, 当你准备好时 ...',params.InstructScreen,0,30);

preparestring('...按空格键继续',params.InstructScreen,250,-275);

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

    [localData] = task_display0(trialCue,Time2Target,CurrentTrialTarget, ...
                          xloc1,xloc2,params.TargetDisplayTime, ...
                          ITI_trial,params.randCSs,params.scr,LKey,RKey);

    InstructedData(count,:)=[count localData];
end

fName = [params.data_dir,'\',params.subj_name,'_GNG0_InstructedData']
save(fName,'InstructedData');
DateStr = datestr(now,'yyyy-mm-dd_HH_MM');
whereWeWere = pwd;
cd(params.data_dir);
fName = [params.subj_name,'_GNG0_workspace_1_',DateStr]; % The _1_ refers to this being 'the real thing', not training.
eval( ['save ' fName] );
% was: eval( ['save Cogent_results_' params.subj_name '_' num2str(params.subj_number) '_' num2str(params.session) '_' DateStr] );
cd(whereWeWere);

preparestring('+',params.InstructScreen)
drawpict(params.InstructScreen);
wait(500);
clearpict(params.InstructScreen);
    
preparestring(['你赢了 ' num2str(sum(InstructedData(:,17))) ' ''元'' 在此任务中'],params.InstructScreen)
drawpict(params.InstructScreen);
wait(5000);
clearpict(params.InstructScreen);

data = InstructedData;

