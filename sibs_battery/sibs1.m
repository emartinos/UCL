function sibs1
% Highest-level script to call all matlab-coded tasks for
% HERITABILITY-RELIABILITY MINI-battery.
% Edit items '..._dir = ...' to suit machine used. It is assumed that
% matlab path has been adjusted so that scripts find what (and only what)
% they need.

%% %%%%%%%%%%%%%% Preliminaries - constants and user inputs %%%%%%%%%%%%%

clear all % THIS IS DANGEROUS IF PUT ANYWHERE ELSE !
rng('default'); rng('shuffle'); % reset random number generator & reinitialize it via clock.

%% * * * * * * * * Labels & debugging related constants * * * * * * * * * * * :
%
sibs1par.codeTesting = 0; % ~0 for code testing and debugging, 0 for normal operation
sibs1par.taskNum = 3;     % Number of tasks to run. 3 for sibs, 5 for depression genetics,
                          % 7 for nspn expt., less for debugging.
sibs1par.maxTaskNum = 8;  % Size of task 'pool' from which we'll select a few to run.                
sibs1par.exp_flow = '0';  % Task flow - whether we're (re)starting ('0' at
                          % this stage) or continuing ('n' for next task).

% Labels also define basic order of tasks (which will be randomized in expt):
sibs1par.labels =  {'Gender (F=0,M=1)','Age (y)','Fee for today','Fee for later','Later fee delay (days)'...
        '1. JTC (unused)','2. GNG1 (discovery Go-NoGo)','3. Trust (unused)',...
        '4. DID / Self-Other (unused)',...
        '5. TST / Two-step-task',...
        '6. MVS / Mean-Variance-Skewness'...
        '7. predator / human avoidance (unused)'...
        '8. GNG0 (trained Go-NoGo)'};
% Filename fragments used within the task programs for writing to disk:
sibs1par.nFrag = {'fishes','GNG1','trust','DID','TST','MVS','predator','GNGb0'};

sibs1par = sibsBatTaskOrder(sibs1par); % edit this fn. for debug order etc ...
% sibs1par.taskOrder = [6,5,8]; % MVS first
% sibs1par.taskOrder = [8,6,5]; % GNG0 first


%% * * * * * * * * * * * * Directory structure * * * *  * * * * * * * * * * * :
%
% Programs will use the following as a base directory and branch out to look for 
% code and data-storage directories:
baseStr = 'C:\Users\experiment\'; % or ...
homeDir = [getenv('HOMEDRIVE') getenv('HOMEPATH') ];
% for Oxford version may be: tasksDir= '\Ubuntu One\dep_gen_study\scripts';
tasksDir= '\Dropbox\task_code';

sibs1par.data_dir =  [homeDir,'\sibs_data\detailed\']; % [baseStr,'data\detailed\'];  % for individual output files
sibs1par.zip_dir =   [homeDir,'\sibs_data\']; % [baseStr,'data\']; % One zipped file per task will go here at the very end
% Untested - for use in WTCN workstation
%sibs1par.data_dir = [homeDir,'\Dropbox\data\detailed\'];  % for individual output files
%sibs1par.zip_dir = [homeDir,'\Dropbox\data\']; % One zipped file per task will go here at the very end
% '\\abba\stimuli\Task_repository\NeuroSciPsychNet\practiceData'; 

% * * * * * * Base directories for task scripts that need them * *  
%
sibs1par.TS_dir     =[homeDir,tasksDir,'\TwoStep2']; % For planning-habit task
% might work in : sibs1par.AEC_dir ='\\abba\stimuli\Task_repository\NeuroSciPsychNet\TwoStep2'; 
% or even:        'C:\Users\mmoutou\Dropbox\DevCompPsych\Task_temp_code\TwoStep2' ;
sibs1par.AEC_dir    =[homeDir,tasksDir,'\Predator']; % For Approach - Avoidance task
sibs1par.fishes_dir =[homeDir,tasksDir,'\fishes']; % For JTC 'fishes' task
sibs1par.trust_dir  =[homeDir,tasksDir,'\trust']; % For Trust Task
sibs1par.goNoGo_dir =[homeDir,tasksDir,'\GNG1_RewPun_fMRI']; % For Go-NoGo Task
sibs1par.DID_dir = [homeDir,tasksDir,'\DID']; % Delegated Intertemporal Task (Self-Other-Self )
addpath(sibs1par.data_dir);

%% * * * * * * * *  constants related to fees for tasks * * * * * * * *   
%
sibs1par.fee = {[0.0, 0.0, 0],zeros(1,7),'WARNING: FEES ONLY ROUGHLY MAP TO TASK OUTCOMES'};
  % Baseline 'flat' fee for whole battery, in pounds; then delayed fee, in pounds; 
  % then delay time for the delayed fee, in days; Then fees for each task, for monitoring purposes.
sibs1par.delayedPayment = 0.00; % Amount to be payed 
% The following define linear maps between play-money/points (*x) and real money (*y).
% For GNG2, assuming NperCond=16 so there are 64 potential-win trials, each
% winning one play-pound, and this corresp. to 5 real pounds, and P(success|correct)=0.85
% 64*0.85 - 64*0.15 = 0.7 * 64 = 44.8
MPT = 5.0; % Max Payment per Task - all others scale
sibs1par.gng1x = [-64,-60, 0      , 0.7*64,  0.9*64,  64     ];
sibs1par.gng1y = [  0,  0, 0.2*MPT, 0.8*MPT, 1.0*MPT, 1.0*MPT];
% see GNG0 in redit1.m if needed; has NperCond=10 only, with similar payoffs as above.
% Predator: Median in pilot was 5.2 tokens/trial, 10th and 90th centile were 3.9 and 6.9
sibs1par.pred_x = [0.0, 2.0, 4.0,     5.2,     6.9,     100    ];
sibs1par.pred_y = [0.0, 0.0, 0.2*MPT, 0.4*MPT, 0.8*MPT, 1.0*MPT];
% Fishes: remf. fishes.m returns fraction of max. points won. 
sibs1par.fish_x = [0.0, 0.4,      0.8,     1.0    ];
sibs1par.fish_y = [0.0, 0.08*MPT, 0.6*MPT, 1.0*MPT];
% DID3: just one value needed, to convert max. points to max. payment:
sibs1par.DID_GBPperPt = MPT / 200.0 ; % pounds per point
% TST: Rem. realistic winnings depend heavily on random walks; -ve fractions are not possible.
sibs1par.TST_x = [0.0, 0.4,     0.6,     1.0    ];
sibs1par.TST_y = [0.0, 0.2*MPT, 0.6*MPT, 1.0*MPT];
% Trust: rather strange reward fn - this game has no objective best outcome,
% fn. below may roughly reflect likely efforts by the I to establish cooperation:
sibs1par.trust_x = [0.0,     0.75,    1.5,     3.0    ];
sibs1par.trust_y = [0.5*MPT, 0.2*MPT, 0.8*MPT, 1.0*MPT];
% Simpler for MVS:
sibs1par.MVSmin = 0.0;   sibs1par.MVSmax = MPT;

%  * * * * * * * * * * * *  VERY FEW user inputs  * * * * * * * * * * * * 
% Age and gender is for tasks (e.g.intertemporal discount) where a 
% 'parnter' has to be chosen.
codeCell  = inputdlg('Participant ID:','ID',1); sibs1par.ptCode = codeCell{1};

% Checksum for typos etc: 
%while luhn(sibs1par.ptCode,'validate') ~= 1 
%    sibs1par.ptCode = input('Sorry, invalid pt. code - please try again; Pt code: '); 
%end
sibs1par.age     = 0;   sibs1par.sex     = 'N/A';  % initialization fillers
                                                   % HAVE TO BE OVERWRITTEN further down.
batLogFileName = [sibs1par.data_dir,sibs1par.ptCode,'_batteryLog.mat'];
if exist(batLogFileName,'file')==0         % If this is the first time we encounter
    sibs1par = sibsPtDetails( sibs1par );  % this pt., ask for their gender and age.
else % load gender and age from existing log file.
    load(batLogFileName);             sibs1par.age  = battery.age;
    if battery.gender < 0.5; sibs1par.sex = 'f'; else sibs1par.sex = 'm'; end;
end

%% %%%%%%%%%%%%%%%  Initial instructions etc. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

done = 0;
currentTask = 0;
%% %%%%%%%%%%%%%%%  Loop over tasks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while currentTask >=0 && done < sibs1par.taskNum % values of currentTask < 0 ...
                                                        % ... used as flags below.
    [done, currentTask, sibs1par] = getSibsBattState(sibs1par); % This may be the first time ...
    % this battery is started, but alternatively it may have been started and stopped for a 
    % break etc., so read in how far we are, if at all. Note that if done == sibs1par.taskNum
    % we need to set a flag to skip the next two steps.
    
    % for debug skip tasks etc:  if done == 0; currentTask = 6; done = 1; end;
    disp([' currentTask: ',num2str(currentTask),'  done: ',num2str(done)]);
   
    % doDepGenTask returns both the points won in the task and an update of the 
    % fee structure within sibs1par :
    [sibs1par, pointsWon] =  doDepGenTask(currentTask,  sibs1par);

    % Now update the log file and pause here until experimenter either resumes or breaks:
    sibs1par = updateSibsBattery(sibs1par,pointsWon,0);
    sibs1par
 
end
%% ********************* Tidy up output files & Wrap up ***********************
%
% This part is not reached if the experimenter breaks (via
% updateAndPauseBattery) as that fn. deliberately aborts with an error code
% to reminder experimenter what's gone on.
disp([num2str(done),' of ',num2str(sibs1par.taskNum),' tasks in battery appear completed']);
java.lang.Runtime.getRuntime.gc;  % Clear up garbage ...

% First supplement the csv formatted summary log file :
batLogFileName = [sibs1par.data_dir,sibs1par.ptCode,'_batteryLog.mat'];
load(batLogFileName);
batLogCSVFName = [sibs1par.zip_dir,'\',sibs1par.ptCode,'_batteryLog.csv'];
csvLogFID = fopen(batLogCSVFName,'a');  % the text / csv file already on disk
fprintf(csvLogFID,'\n\"%s\"','Scores:' );
for i=1:sibs1par.maxTaskNum
  fprintf(csvLogFID,',%f', battery.score(i)  );
end
fprintf(csvLogFID,'\n\"%s\"','Fees:' );
for i=1:3
  fprintf(csvLogFID,',%f', battery.earnings{1}(i));
end
fclose(csvLogFID);

% Create zip files for each task and dispose of originals :
% debug: for i=currentTask:currentTask
for k=1:sibs1par.taskNum
    i = sibs1par.taskOrder(k);
    wildName = [sibs1par.data_dir,'*',sibs1par.ptCode,'*',sibs1par.nFrag{i},'*'];
    zipName  = [sibs1par.zip_dir,sibs1par.ptCode,'_',...
                sibs1par.nFrag{i},'_',datestr(now,'yyyy-mm-dd_HH_MM'),'.zip']
    zip(zipName,wildName);
    delete(wildName); % Get rid of originals of files that were successfully tidied up
end

% Finally display the bare essentials for experimenter to pay participant:
cMode.Interpreter='none';   % set to 'tex' for nice symbols, tho matlab tex intereter is rubbish.
cMode.WindowStyle='modal';  % Force user to take notice of these !
m1 = ['Overall score today is ',num2str(100*sibs1par.fee{1}(1)),' points.']
m2 = ''; m3 = '';
if  ~isempty(find(sibs1par.taskOrder==taskIndex('DID'))) % if DID is in the tasks we did
   m2 = ['  The score for the Intertemporal Delay task is ',num2str(100*sibs1par.fee{1}(2)),' points']
   m3 = [' in ',num2str(sibs1par.fee{1}(3)),' days.']
end
msgbox([m1,m2,m3],cMode);    


%  disp(' '); % 
%  disp(['Performance related fee due today is      : ',num2str(sibs1par.fee{1}(1)),' pounds.']);
%  if  ~isempty(find(sibs1par.taskOrder==taskIndex('DID'))) % if DID is in the tasks we did
%    disp(['Amount from Intertemporal Delay task is   : ',num2str(sibs1par.fee{1}(2)),' pounds.']);
%    disp(['... and this additional fee is payable in : ',num2str(sibs1par.fee{1}(3)),' days.']);
%  end
clear all;
end % of whole function sibs1 ********************************************
%*************************************************************************