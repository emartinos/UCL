function depgen1
% Highest-level script to call all matlab-coded tasks for DEPRESSION-GENETICS BEHAVIOURAL battery.
% Edit items '..._dir = ...' to suit machine used. It is assumed that
% matlab path has been adjusted so that scripts find what (and only what)
% they need.

%% %%%%%%%%%%%%%% Preliminaries - constants and user inputs %%%%%%%%%%%%%

clear all % THIS IS DANGEROUS IF PUT ANYWHERE ELSE !
rng('default'); rng('shuffle'); % reset random number generator & reinitialize it via clock.

%% * * * * * * * * Labels & debugging related constants * * * * * * * * * * * :
%
depgen1par.codeTesting = 1; % ~0 for code testing and debugging, 0 for normal operation
depgen1par.taskNum = 5;     % Number of tasks to run. 7 for expt., less for
                          % debugging.
depgen1par.exp_flow = '0';  % Task flow - whether we're (re)starting ('0' at
                          % this stage) or continuing ('n' for next task).

% Labels also define basic order of tasks (which will be randomized in expt):
depgen1par.labels =  {'Gender (F=0,M=1)','Age (y)','Fee for today','Fee for later','Later fee delay (days)'...
        '1. JTC (unused)','2. GNG1 / Go-NoGo','3. Trust (unused)',...
        '4. DID / Self-Other',...
        '5. TST / Two-step-task',...
        '6. MVS / Mean-Variance-Skewness'...
        '7. predator / human avoidance'};
% Filename fragments used within the task programs for writing to disk:
depgen1par.nFrag = {'fishes','GNG1','trust','DID','TST','MVS','predator'};

depgen1par = cogBatTaskOrder(depgen1par); % edit this fn. for debug order etc ...
% depgen1par.taskOrder = [6,7,5,2,4]; % MVS first
% depgen1par.taskOrder = [7,6,5,2,4]; % Predator first
% depgen1par.taskOrder = [7,6,5,2,4]; % Predator first


%% * * * * * * * * * * * * Directory structure * * * *  * * * * * * * * * * * :
%
% Programs will use the following as a base directory and branch out to look for 
% code and data-storage directories:
baseStr = 'C:\Users\experiment\'; % or ...
homeDir = [getenv('HOMEDRIVE') getenv('HOMEPATH') ];
tasksDir= '\Ubuntu One\dep_gen_study\scripts';

depgen1par.data_dir =  [homeDir,'\depgen_data\detailed\']; % [baseStr,'data\detailed\'];  % for individual output files
depgen1par.zip_dir =   [homeDir,'\depgen_data\']; % [baseStr,'data\']; % One zipped file per task will go here at the very end
% Untested - for use in WTCN workstation
%depgen1par.data_dir = [homeDir,'\Dropbox\data\detailed\'];  % for individual output files
%depgen1par.zip_dir = [homeDir,'\Dropbox\data\']; % One zipped file per task will go here at the very end
% '\\abba\stimuli\Task_repository\NeuroSciPsychNet\practiceData'; 

% * * * * * * Base directories for task scripts that need them * *  
%
depgen1par.TS_dir     =[homeDir,tasksDir,'\TwoStep2']; % For planning-habit task
% might work in : depgen1par.AEC_dir ='\\abba\stimuli\Task_repository\NeuroSciPsychNet\TwoStep2'; 
% or even:        'C:\Users\mmoutou\Dropbox\DevCompPsych\Task_temp_code\TwoStep2' ;
depgen1par.AEC_dir    =[homeDir,tasksDir,'\Predator']; % For Approach - Avoidance task
depgen1par.fishes_dir =[homeDir,tasksDir,'\fishes']; % For JTC 'fishes' task
depgen1par.trust_dir  =[homeDir,tasksDir,'\trust']; % For Trust Task
depgen1par.goNoGo_dir =[homeDir,tasksDir,'\GNG1_RewPun_fMRI']; % For Go-NoGo Task
depgen1par.DID_dir = [homeDir,tasksDir,'\DID']; % Delegated Intertemporal Task (Self-Other-Self )
addpath(depgen1par.data_dir);

%% * * * * * * * *  constants related to fees for tasks * * * * * * * *   
%
depgen1par.fee = {[0.0, 0.0, 0],zeros(1,7),'WARNING: FEES ONLY ROUGHLY MAP TO TASK OUTCOMES'};
  % Baseline 'flat' fee for whole battery, in pounds; then delayed fee, in pounds; 
  % then delay time for the delayed fee, in days; Then fees for each task, for monitoring purposes.
depgen1par.delayedPayment = 0.00; % Amount to be payed 
% The following define linear maps between play-money/points (*x) and real money (*y).
% For GNG2, assuming NperCond=16 so there are 64 potential-win trials, each
% winning one play-pound, and this corresp. to 5 real pounds, and P(success|correct)=0.85
% 64*0.85 - 64*0.15 = 0.7 * 64 = 44.8
MPT = 5.0; % Max Payment per Task - all others scale
depgen1par.gng1x = [-64,-60, 0      , 0.7*64,  0.9*64,  64     ];
depgen1par.gng1y = [  0,  0, 0.2*MPT, 0.8*MPT, 1.0*MPT, 1.0*MPT];
% see GNG0 in redit1.m if needed; has NperCond=10 only, with similar payoffs as above.
% Predator: Median in pilot was 5.2 tokens/trial, 10th and 90th centile were 3.9 and 6.9
depgen1par.pred_x = [0.0, 2.0, 4.0,     5.2,     6.9,     100    ];
depgen1par.pred_y = [0.0, 0.0, 0.2*MPT, 0.4*MPT, 0.8*MPT, 1.0*MPT];
% Fishes: remf. fishes.m returns fraction of max. points won. 
depgen1par.fish_x = [0.0, 0.4,      0.8,     1.0    ];
depgen1par.fish_y = [0.0, 0.08*MPT, 0.6*MPT, 1.0*MPT];
% DID3: just one value needed, to convert max. points to max. payment:
depgen1par.DID_GBPperPt = MPT / 200.0 ; % pounds per point
% TST: Rem. realistic winnings depend heavily on random walks; -ve fractions are not possible.
depgen1par.TST_x = [0.0, 0.4,     0.6,     1.0    ];
depgen1par.TST_y = [0.0, 0.2*MPT, 0.6*MPT, 1.0*MPT];
% Trust: rather strange reward fn - this game has no objective best outcome,
% fn. below may roughly reflect likely efforts by the I to establish cooperation:
depgen1par.trust_x = [0.0,     0.75,    1.5,     3.0    ];
depgen1par.trust_y = [0.5*MPT, 0.2*MPT, 0.8*MPT, 1.0*MPT];
% Simpler for MVS:
depgen1par.MVSmin = 0.0;   depgen1par.MVSmax = MPT;

%  * * * * * * * * * * * *  VERY FEW user inputs  * * * * * * * * * * * * 
% Age and gender is for tasks (e.g.intertemporal discount) where a 
% 'parnter' has to be chosen.
depgen1par.ptCode  = input('\n       Participant code: ', 's');
% Checksum for typos etc: 
%while luhn(depgen1par.ptCode,'validate') ~= 1 
%    depgen1par.ptCode = input('Sorry, invalid pt. code - please try again; Pt code: '); 
%end
depgen1par.age     = 0;   depgen1par.sex     = 'N/A';  % initialization fillers
                                                   % HAVE TO BE OVERWRITTEN further down.
batLogFileName = [depgen1par.data_dir,depgen1par.ptCode,'_batteryLog.mat'];
if exist(batLogFileName,'file')==0         % If this is the first time we encounter
    depgen1par = depgenPtDetails( depgen1par );  % this pt., ask for their gender and age.
else % load gender and age from existing log file.
    load(batLogFileName);             depgen1par.age  = battery.age;
    if battery.gender < 0.5; depgen1par.sex = 'f'; else depgen1par.sex = 'm'; end;
end

%% %%%%%%%%%%%%%%%  Initial instructions etc. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% batteryInstructions(depgen1par,0);

done = 0;
currentTask = 0;
%% %%%%%%%%%%%%%%%  Loop over tasks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while currentTask >=0 && done < depgen1par.taskNum % values of currentTask < 0 ...
                                                        % ... used as flags below.
    [done, currentTask, depgen1par] = getBehBattState(depgen1par); % This may be the first time ...
    % this battery is started, but alternatively it may have been started and stopped for a 
    % break etc., so read in how far we are, if at all. Note that if done == depgen1par.taskNum
    % we need to set a flag to skip the next two steps.
    
    % for debug do just one task:  if done == 0; currentTask = 4; done = depgen1par.taskNum; end;
    disp([' currentTask: ',num2str(currentTask),'  done: ',num2str(done)]);
   
    % doTask returns both the points won in the task and an update of the 
    % fee structure within depgen1par :
    [depgen1par, pointsWon] =  doTask(currentTask,  depgen1par);

    % Now update the log file and pause here until experimenter either resumes or breaks:
    depgen1par = updateAndPauseBattery(depgen1par,pointsWon,0);
    depgen1par
 
end
%% ********************* Tidy up output files & Wrap up ***********************
%
% This part is not reached if the experimenter breaks (via
% updateAndPauseBattery) as that fn. deliberately aborts with an error code
% to reminder experimenter what's gone on.
disp([num2str(done),' of ',num2str(depgen1par.taskNum),' tasks in battery appear completed']);
java.lang.Runtime.getRuntime.gc;  % Clear up garbage ...

% First supplement the csv formatted summary log file :
batLogFileName = [depgen1par.data_dir,depgen1par.ptCode,'_batteryLog.mat'];
load(batLogFileName);
batLogCSVFName = [depgen1par.zip_dir,'\',depgen1par.ptCode,'_batteryLog.csv'];
csvLogFID = fopen(batLogCSVFName,'a');  % the text / csv file already on disk
fprintf(csvLogFID,'\n\"%s\"','Scores:' );
for i=1:depgen1par.taskNum
  fprintf(csvLogFID,',%f', battery.score(i)  );
end
fprintf(csvLogFID,'\n\"%s\"','Fees:' );
for i=1:3
  fprintf(csvLogFID,',%f', battery.earnings{1}(i));
end
fclose(csvLogFID);

% Create zip files for each task and dispose of originals :
% debug: for i=currentTask:currentTask
for k=1:depgen1par.taskNum
    i = depgen1par.taskOrder(k);
    wildName = [depgen1par.data_dir,'*',depgen1par.ptCode,'*',depgen1par.nFrag{i},'*'];
    zipName  = [depgen1par.zip_dir,depgen1par.ptCode,'_',...
                depgen1par.nFrag{i},'_',datestr(now,'yyyy-mm-dd_HH_MM'),'.zip']
    zip(zipName,wildName);
    delete(wildName); % Get rid of originals of files that were successfully tidied up
end

% Finally display the bare essentials for experimenter to pay participant:
disp(' '); % 
disp(['Performance related fee due today is      : ',num2str(depgen1par.fee{1}(1)),' pounds.']);
disp(['Amount from Intertemporal Delay task is   : ',num2str(depgen1par.fee{1}(2)),' pounds.']);
disp(['... and this additional fee is payable in : ',num2str(depgen1par.fee{1}(3)),' days.']);
clear all;
end % of whole function depgen1 ********************************************
%*************************************************************************