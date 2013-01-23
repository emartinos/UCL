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
 
preparestring('In each trial you will see one of four images; These signal',params.InstructScreen,0,150);
preparestring('what the best thing to do is. Images will be followed by a cross,',params.InstructScreen,0,110);
preparestring('then a circle may appear. The circle means that it''s time to',params.InstructScreen,0,70);
preparestring('decide what to do. Sometimes you MUST PRESS the key used for responding.',params.InstructScreen,0,30);
preparestring('Sometimes you MUST NOT PRESS anything to get the best result.',params.InstructScreen,0,-10);
preparestring('On each trial you will see if you win money (up arrow), lose money',params.InstructScreen,0,-50);
preparestring('(down arrow) or neither of the two (horizontal line). Your job is to',params.InstructScreen,0,-90);
preparestring('find out the best response to each image, so as to win the most overall.',params.InstructScreen,0,-130);
preparestring('...Press space-bar to continue',params.InstructScreen,250,-275);

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
    
preparestring(['Thanks! This is the end of this part of the Respond-Hold Back task.'],params.InstructScreen)
%preparestring(['You have won ' num2str(sum(LearnVerData(:,17))) ' ''coins'' in this task'],params.InstructScreen)
drawpict(params.InstructScreen);
wait(5000);
clearpict(params.InstructScreen);

data = LearnVerData;

