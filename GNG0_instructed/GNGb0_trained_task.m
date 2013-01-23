function  [data] = GNGb0_trained_task( practNperCond, xloc1,xloc2, LKey,RKey )
% real_like_practice is a 'dry run' for the fMRI / scanning task, it 
% saves a file with all its results in trainedData, and returns the same.
          
% - - Constants - - 
global c; % This contains the various constants set during initialization.
% - - - - - - - - - 
nPerCond = 1; % A minimum, default value of practice trials per condition.
if (practNperCond > nPerCond)  % i.e. ignore input argument if too small!
    nPerCond = practNperCond;
end
realPracticeTrialN = 4*2*nPerCond; % = 4 conditions x 2 sham/targeted x nPerCond

%  Matrices for presentation of stimuli during learning w.out f/b:
% trialTarget=repmat([1 2],    [1,nPerCond]  );  % 1 real trial; 2 sham trial, if practicing for scanner
trialTarget=repmat([1 c.sham],    [1,nPerCond]  );  % [1 2] would be [real_trial sham_trial].
trialType  =repmat([1 2 3 4],[1,2*nPerCond]);  % 1 go reward; 2 go punishment; 3 no-go reward; 4 no-go punishment
% Randomize the sequence of presentation of all 4 trial types now in
% trialType. This will determine the cues presented at each trial.
randTrialType=trialType(randperm(size(trialType,2)));

trialNumber=[randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))'];

trialCounter=[0 0 0 0]; % Helps count trials locally

TargetTime=c.minTargetTime + rand(1,realPracticeTrialN)*c.TargetTimeSpan;
trialsITI=c.minITI + rand(1,realPracticeTrialN)*c.minITI;

% ~~~~~~~~~~~~~~~~~~ Instruction screen ~~~~~~~~~~~~~~~

mayORwill = '可能'; if c.sham == 1 mayORwill = '将要'; end;
clearpict(c.InstructScreen); 
preparestring('每个实验中你会看到四个图片中的一个; 这些信号',c.InstructScreen,0,150);
preparestring('表明应做的事. 图片之后会有一个十字,',c.InstructScreen,0,110);
preparestring(['然后一个圆圈 ' mayORwill '出现. 圆圈表明你必须立即做决定'],c.InstructScreen,0,70);
preparestring('要做什么. 有时你必须按键来回应.',c.InstructScreen,0,30);
preparestring('有时你要不按键来得到好的结果.',c.InstructScreen,0,-10);
preparestring('每个实验你会看到是否赢钱（上箭头），输钱',c.InstructScreen,0,-50);
preparestring('(下箭头) 或者不赢不输 (黄色横线).',c.InstructScreen,0,-90);
preparestring('... 按任意键继续',c.InstructScreen,250,-175);
drawpict(c.InstructScreen);
waitkeydown(inf);
clearpict(c.InstructScreen);

for count=1:realPracticeTrialN

    trialCue=randTrialType(count);
    trialCounter(trialCue)=trialCounter(trialCue)+1;
    CurrentTrial=trialNumber(trialCounter(trialCue),trialCue);
    CurrentTrialTarget=trialTarget(CurrentTrial);

    Time2Target=TargetTime(count);
    ITI_trial=trialsITI(count);

    [localData] = GNGb0_task_display(trialCue,Time2Target,CurrentTrialTarget, ...
                          xloc1,xloc2,c.TargetDisplayTime, ...
                          ITI_trial,c.randCSs,c.scr,LKey,RKey);
    % I'm calling the following trainedData in the sense that there is no
    % fMRI scan involved (in this function).
    trainedData(count,:)=[count localData];
end

%% Save some trained task data
timeStr = datestr(now,'yyyy-mm-dd_HH_MM');
fName = [c.data_dir,'\',c.subj_name,'_GNGb0_trainedData_',num2str(c.session),'_',timeStr];
save(fName,'trainedData');
fName = [c.subj_name,'_GNGb0_Cogent_output_',num2str(c.session),'_',timeStr];  
whereWeWere = pwd;
cd(c.data_dir); % Sorry, this is v. sloppy, I didn't have the time to iron things out ...
eval( ['save ' fName] );
cd(whereWeWere);    
%% 

preparestring('+',c.InstructScreen)
drawpict(c.InstructScreen);
wait(1000);
clearpict(c.InstructScreen);

preparestring(['End of this task - Thanks for your effort!'],c.InstructScreen)   
% preparestring(['You would have won ' num2str(sum(trainedData(:,17))) ' ''coins'' in this run'],c.InstructScreen)
drawpict(c.InstructScreen);
wait(2000);
clearpict(c.InstructScreen);

data = trainedData;

