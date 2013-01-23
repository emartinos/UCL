function  [data] = GNGb0_real_like_practice ( practNperCond, xloc1,xloc2, LKey,RKey )
% real_like_practice is a 'dry run' for the fMRI / scanning task, it 
% saves a file with all its results in dryRunData, and returns the same.
          
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
trialTarget=repmat([1 1],    [1,nPerCond]  );  % [1 2] would be [real_trial sham_trial] - but here practicing for outside scanner.
trialType  =repmat([1 2 3 4],[1,2*nPerCond]);  % 1 go reward; 2 go punishment; 3 no-go reward; 4 no-go punishment
% Randomize the sequence of presentation of all 4 trial types now in
% trialType. This will determine the cues presented at each trial.
randTrialType=trialType(randperm(size(trialType,2)));

trialNumber=[randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))' randperm(length(trialTarget))'];

trialCounter=[0 0 0 0]; % Helps count trials locally

TargetTime=c.minTargetTime + rand(1,realPracticeTrialN)*c.TargetTimeSpan;
trialsITI=c.minITI + rand(1,realPracticeTrialN)*c.minITI;
 
preparestring('Now you will train on the task exactly as it will be',c.InstructScreen,0,190);
preparestring('for real, so this time you will not get explanations',c.InstructScreen,0,150);
preparestring('about your successes or failures.',c.InstructScreen,0,110);
preparestring('... When you are ready press key to move on.', c.InstructScreen,100,-275);
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
    % I'm calling the following dryRunData in the sense that there is no
    % fMRI scan involved (in this function).
    dryRunData(count,:)=[count localData];
end

%% Save some dryRun data
timeStr = datestr(now,'yyyy-mm-dd_HH_MM');
fName = [c.data_dir,'\',c.subj_name,'_GNGb0_dryRunData_',num2str(c.session),'_',timeStr];
save(fName,'dryRunData');
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

preparestring(['End of these training trials - Thanks for your effort!'],c.InstructScreen)   
% preparestring(['You would have won ' num2str(sum(dryRunData(:,17))) ' ''coins'' in this run'],c.InstructScreen)
drawpict(c.InstructScreen);
wait(2000);
clearpict(c.InstructScreen);

data = dryRunData;

