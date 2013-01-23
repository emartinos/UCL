function TotalWon = GNGb0_full_training(code, dataDir, goNoGoDir, debug)
% function TotalWon = GNGb0_full_training(code, dataDir, goNoGoDir, debug)
% function for the Go-NoGo experiment after Marc Guitart, adapted for
% behavioural use for the depression genetics study.
% Based on GNGi1, has flow control for full training version to be run
% before any other versions of GNG. This includes possibility to repeat
% training with same stimuli if pt. hasn't learnt.
%
% Commonly adjusted parameters: (NSPN defaults shown here):
% c.NperCond = 20, c.cog_disp = 1, c.scanner=0 ...
% 
% cd ( [getenv('HOMEDRIVE') getenv('HOMEPATH') '\nspn_data\detailed\'] )
% noWinnings = GNGb0_brief_training(['GNGbBT_' datestr(now,'yyyymmddHHMM') 'a'],'.',[getenv('HOMEDRIVE') getenv('HOMEPATH') '\Dropbox\task_code\GNG0_instructed'],1)


%% ************** Default arguments :   *****************************************
if nargin < 4
    % debug = input('press 0 for ''normal'' GNGb0 program, 1 for debug version: ');
    debug = 0;
end
if nargin < 3
  goNoGoDir = [getenv('HOMEDRIVE') getenv('HOMEPATH') '\Dropbox\task_code\GNG0_instructed'] ;
  % goNoGoDir =  '.';
end
if nargin < 1
  code    = ['GNGb0' datestr(now,'yyyymmddHHMM')];
end
if nargin < 2
  dataDir = [getenv('HOMEDRIVE') getenv('HOMEPATH') '\nspn_data\detailed\' code '_', datestr(now,'yyyy-mm-dd')];  
  if exist(dataDir,'dir') ~= 7; mkdir(dataDir); end;
  % dataDir = '.';
  % [getenv('HOMEDRIVE') getenv('HOMEPATH') '\nspn_data\detailed'];
end 

%% A global variable  c.* which will be set during initialization only. 
%  Not necessarily but v. conveniently as global (naughty naughty !)

global c; %

c.session_training = 2; % session_training is 0 in the Learning version, where pts. 
                        % have to discover themselves the right response to each stimulus,
                        % 1 if already trained, 2 if they will JUST receive training here.
c.Psuccess= 0.8;     % Chance of success if correct response was made
c.bad_dec_prob =1;   % If 1, BAD decisions get GOOD outcomes probabilistically with Py = 1-c.Psuccess 
                     % but if 0, BAD decisions deterministically lead to BAD
                     % outcomes. SEE NEXT LINE BEFORE CHANGING THIS: 
if c.session_training ~= 0; c.bad_dec_prob= 0; end; % probabilistic losses for
                     % 'discovery' / learning version only.
c.RTmax = 700;       % 500 for real thing?
c.money = 1.0;       % base amount used for rewards / punishments. Was 0.5

c.session = 1; % For scanning, this default will be enquired about later  
c.minITI = 250;              % Original was 750
c.TargetDisplayTime=800;    % Originally was TargetDisplayTime=1500;
c.minTargetTime= 250; % minimum Time - to - Target, as in the original.
% The following sets the range, or alternatively the sd of a uniform
% distro, for the range of Time - to - Target. sdTargetTime= 938 corrsponds
% to approx. the original time range of 3250 ms
c.sdTargetTime= 938;  c.TargetTimeSpan = sqrt(12.0)*c.sdTargetTime; 

c.screen_res = 3; % Cogent resolution. 1=640x480, 2=800x600, 3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200
c.InstructScreen=1;
c.doTrainingKey = keyCode('SPACE',1); % We'll ask this to be 'SPACE' to (re)do the training in the
  % training versions, or 'RETURN' to move on to the next stage / end the program.

% %%%%%%%%%%%%%%% Scanning dependent / related : %%%%%%%%%%%%%%%%%%%
%
c.scanner =0; % c.scanner = input('press 0 if outside scanner, 1 for scanner, 2 for emulscan: ');

% - - - - - - - - - Remind the user which version exactly we are using - - - - - - 
remStr = ['Session type (0=discover/learning, 1=already trained today, 2=training given here): ',...
          num2str(c.session_training)];
disp(' '); disp(remStr);
remStr = ['Scanning env. (0=outside scanner, 1=fMRI, 2=emulscan): ',num2str(c.scanner)];
disp(remStr); disp(' ');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if c.scanner ~= 0 % Change various defaults for scanning environment
  c.session = input('enter 0 for training session and 1 to 4 for scan session no. : ');
  if nargin < 3  % If user hasn't deliberately specified goNoGoDir
    goNoGoDir = '.';
  end
  %stuff below not needed - moved to approx. l 30
%   if nargin < 2  % If user hasn't deliberately specified dataDir
%     scanSaveFDir = ['.\',code, '_',datestr(now,'yyyy-mm-dd')]; % we will store ALL 
%                        % results for this participant for this day together
%     if exist(scanSaveFDir,'dir') ~= 7; mkdir(scanSaveFDir); end;
%     dataDir = scanSaveFDir;
%   end
end
    
if debug == 0  % Running the program for real
  if c.scanner == 0
    if c.session_training == 2  % For training with instructions etc.
       c.NperCond = 10;
    else
      c.NperCond = 18; % Number of trials per condition for most behavioural studies / 
          % outside scanner. 16 should give ~18 min task overall, 18 nearer to 22 ...
    end
  else
    c.NperCond = 10; %  shorter blocks if scanning conditions
  end
else % Running the program to debug - as brief as meaningful
    c.NperCond = 2;
    c.Psuccess= 0.9;
end

c.NumDummies=6;
c.SlicesVol=40;

% - - - - - - - - - directory structure to be used etc  - - - - - - - - - - - - - - 
c.subj_name       = code; % originally: input('Participant s initials: ', 's');
c.subj_number     =0; % this is a dummy, for backward-comp. Originally: input('Participant number: '); 
c.data_dir        = dataDir; % Make sure this is AFTER SCANNER OPTIONS !
c.prog_dir        = goNoGoDir;
c.tempNetDir      = ''; % Empty;
% If c.tempNetDir is not empty, which will be the case if we want to make the 
% outputs of the behavioural expt. available for other expts, esp. scanning, 
% set up the `temporary' directory where today's files will go (and some may have already gone)
if strcmp(c.tempNetDir,'') ~= 1
  tempDir = [c.tempNetDir,'\',c.subj_name,'_', datestr(now,'yyyy-mm-dd')];
end

randomization = 0; % default, will be kept esp. if c.session_training = 0, i.e. 'discovery' version,
                   % e.g. within NSPN behavioural battery that we don't want interrupted by prompts.
if c.session_training == 1 % pt already trained TODAY -> always attempt to read from file
  randomization = 1;
elseif c.session_training == 2 % instructed training: give choice to experimenter
  randomization=0;  % specifically for depgen herrel etc.
  % randomization=input('0 if stimuli have NOT been ready-made randomized, 1 if they have: ');
end

% c.scr = input('press 0 if no scr, 1 if scr is measured: ');
c.scr = 0;
c.context = 1; % Signifies the 'context', i.e. keyboard layout mainly, of NSPN Dell Laptop.
c.discrim = 0; % If c.discrim is 0 there is only one Go response to make, a single button press.
               % Otherwise there is a discrimination task to do. 
% for display
if debug ~= 0
    c.cog_disp = 0;  % Cogent  windowed (= 0) for debug
else 
  if c.scanner ~= 1  % i.e. not actually in scanner
    c.cog_disp = 1;  % Cogent single-screen full-window = 1 for behavioural or emuslcanning
  else 
    c.cog_disp = 2;  % On second monitor for inside scanner.
  end
end

%% - - - - - - - - - end 'constant' structure initialization - - - - - - - - - - - - - - 


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Cogent Configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure Cogent is clear:
clear global cogent; 

% windowed display: config_display(0, ... or full screen: config_display(1, ...
config_display(c.cog_disp, c.screen_res, [0 0 0], [1 1 1], 'Helvetica', 30, 7, 0);
config_keyboard;
% config_data('Pictures2.dat');

fName = [c.data_dir,'\',c.subj_name,'_GNGb0_Cogent',datestr(now,'yyyy-mm-dd_HH_MM'),'.log'];
config_log( fName );
if c.scr==1
    startportb(888);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% preparing matrices and stimuli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch randomization  
 case 0   % i.e. need to create new randomized order of stimuli.
  Stimuli={'S1.bmp','S2.bmp','S3.bmp','S4.bmp'};
  StimOrd=randperm(4);
  fName = [c.data_dir,'\',c.subj_name,'_GNGb0_StimOrd_',datestr(now,'yyyy-mm-dd_HH_MM'),'.csv'];
  csvwrite(fName,StimOrd);   % Don't need mat file, as originally was: save(fName,'StimOrd');
  CSs=[Stimuli(StimOrd(1)),Stimuli(StimOrd(2)),Stimuli(StimOrd(3)),Stimuli(StimOrd(4))];
  RandCSs=CSs; 
  % Save these separately for use by GNG paradigms that need them ready-randomized:
  fName = [c.data_dir,'\',c.subj_name,'_GNGb0_RandCSs'];
  save(fName,'RandCSs');
  
 case 1   % i.e. need to load file with order of stimuli
  if strcmp(c.tempNetDir,'') == 1  % i.e. a networked directory from which to read
                                   % this up the RandCSs has NOT been specified 
    fileNToLoad =  [c.data_dir,'\',c.subj_name,'_GNGb0_RandCSs.mat'];
  else
    fileNToLoad = [tempDir,'\',c.subj_name,'_GNGb0_RandCSs.mat'];
  end
  if strcmp( ls(fileNToLoad),'') % i.e. if the file to load is not there
    disp(' '); disp(' '); 
    disp(['Could not find the file with the order of the stimuli, ']);
    disp([fileNToLoad ':']);
    error('Please check participant ID and ensure stimulus order file is available');
  else
    load (fileNToLoad);
  end
  
end
c.randCSs = RandCSs; 

%%% Trial type matrices.
% Matrices for simple 'target practice':
TrialTarget=repmat([1 2],[1,c.NperCond]);   % 1 real trial; 2 sham trial

RandTrialTarget=TrialTarget(randperm(size(TrialTarget,2)));

% Matrices for presentation of stimuli during learning with feedback:
TrialTypeLearning=repmat([1 2 3 4],[1,c.NperCond]);
RandTrialTypeLearning=TrialTypeLearning(randperm(size(TrialTypeLearning,2)));

%  Matrices for presentation of stimuli during the real thing (also learning w.out f/b ?):
TrialType=repmat([1 2 3 4],[1,2*c.NperCond]);  % 1 go reward; 2 go punishment; 3 no-go reward; 4 no-go punishment
% Randomize the sequence of presentation of all 4 trial types now in TrialType :
RandTrialType=TrialType(randperm(size(TrialType,2)));

TrialNumber=[randperm(length(TrialTarget))' randperm(length(TrialTarget))' randperm(length(TrialTarget))' randperm(length(TrialTarget))'];

TrialCounter=[0 0 0 0];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% other variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TargetTime=c.minTargetTime + rand(1,length(TrialType))*c.TargetTimeSpan;
% TargetDisplayTime=1000;                    % Originally was TargetDisplayTime=1500;
ITI=c.minITI + rand(1,length(TrialType))*c.minITI;

if c.scanner==1
    port=1;  %for scanner
    config_serial(1);
   % config_keyboard_monitoring('led');
    
    % Scanner keys are hardcoded here to save time:
    LeftKey         =80;              %m
    RightKey        =81;  
else
    port = 0; % may use this for scanning emulation, emulscan
    if c.scanner == 2  % scanner emulation
      config_emulscan('trio',c.SlicesVol,100000); % No specific 'quattro' constant ...
      start_emulscan
    end % setting up and starting emulscan
end

if c.discrim == 0
    xlocation1 = 0;      xlocation2 = 0;
else
    xlocation1 =-100;    xlocation2 =+100;
end
ylocation      =0;

start_cogent;

% Find out which keys the participant will use:
if c.scanner == 0
    clearpict;
    settextstyle('Arial narrow', 24);
    preparestring(' ~ Respond vs. Hold back task ~ ', 0, 0, 160 );
    preparestring('In the task that follows sometimes you will have to respond, sometimes not. ', 0, 0, 120 );
 	preparestring('(You will only need to use one key for responding; please', 0, 0, -60 )
    preparestring('ask the researcher what to do if you aren''t using a keyboard).', 0, 0, -100 )

    % setforecolour(1,1,1);
    if c.discrim == 0 % If no discrimiation is involved, only one response key needed
        [RightKey, kbdMap] = get1ResponseKey(c, 'SPACE',0);
        LeftKey = RightKey;
    else % Original version, with discrimination:
        preparestring('Please press the left key to continue...', 0 )
        drawpict;
        LeftKey = waitkeydown(inf);
        clearpict;
        wait(100);
        preparestring('Please press the right key to continue...', 0 )
        drawpict;
        RightKey = waitkeydown(inf);
    end 
else   % Scanner keys are hardcoded here to save time:
  LeftKey         =29;      % 28 is numeric 2        %m
  RightKey        =28;      % 29 is numeric 1
end
%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Target practice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if c.session==0 || c.session_training < 1  % Target practice if starting on discovery version
        % OR if deliberately chosen to do training session in scanner.         
    GNGb0_target_practice( c.InstructScreen, c.NperCond, ... % originally not c.NperCond but length(RandTrialTarget), which is 2*c.NperCond
                     c.discrim, xlocation1,xlocation2,c.TargetDisplayTime,ITI, ...
                     LeftKey, RightKey, c.subj_number, c );
end
%% 

if c.session_training == 2 % Only for the training / instructed, non-learning version !
       %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % % Cues and Task Learning
       % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       preparestring('~ the best responses for the Respond-Hold Back task ~', c.InstructScreen,0,275);
       preparestring('First you will see each image and what the BEST response',1,0,150);
       preparestring('for each really is. TAKE YOUR TIME learning each one.',1,0,110);
       preparestring('Then you will practice performing the task.',1,0,70);
       preparestring('First you will see the image; WAIT until a',1,0,30);
       preparestring('circle appears. Only then must you do the task',1,0,-10);
       preparestring('(PRESS or NOT PRESS the response key).',1,0,-50);
       preparestring('These training trials will not count towards your score',1,0,-90);
       preparestring('...Press a key to continue', c.InstructScreen,250,-275);
       drawpict(c.InstructScreen);
       waitkeydown(inf);
       clearpict(c.InstructScreen);

       % This loop allows for experimenter to repeat the training if the pt. has
       % learnt little: 
       while c.doTrainingKey ~= keyCode('RETURN',1)    
         preparepict(loadpict(c.randCSs{1}),c.InstructScreen,0,150);
         preparestring(['The task is PRESS to win ' num2str(c.money) ' pounds'],c.InstructScreen,0,-50);
         preparestring('... Press key to move on WHEN YOU ARE READY', c.InstructScreen,100,-275);
         drawpict(c.InstructScreen);
         waitkeydown(inf);
         clearpict(c.InstructScreen);

         preparepict(loadpict(c.randCSs{2}),c.InstructScreen,0,150);
         preparestring(['The task is PRESS to avoid losing ' num2str(c.money) ' pounds'],c.InstructScreen,0,-50);
         preparestring('... Press key to move on WHEN YOU ARE READY', c.InstructScreen,100,-275);
         drawpict(c.InstructScreen);
         waitkeydown(inf);
         clearpict(c.InstructScreen);
         
         preparepict(loadpict(c.randCSs{3}),c.InstructScreen,0,150);
         preparestring(['The task is DO NOT PRESS to win ' num2str(c.money) ' pounds'],c.InstructScreen,0,-50);
         preparestring('... Press key to move on WHEN YOU ARE READY', c.InstructScreen,100,-275);
         %     preparestring('...Press space-bar to continue', c.InstructScreen,250,-275);
         drawpict(c.InstructScreen);
         waitkeydown(inf);
         clearpict(c.InstructScreen);
         
         preparepict(loadpict(c.randCSs{4}),c.InstructScreen,0,150);
         preparestring(['The task is DO NOT PRESS to avoid losing ' num2str(c.money) ' pounds'],c.InstructScreen,0,-50);
         preparestring('... Press key to move on WHEN YOU ARE READY', c.InstructScreen,100,-275);
         %     preparestring('...Press space-bar to continue', c.InstructScreen,250,-275);
         drawpict(c.InstructScreen);
         waitkeydown(inf);
         clearpict(c.InstructScreen);

         preparestring('Get ready',c.InstructScreen,0,0);
         drawpict(c.InstructScreen);
         wait(1000);
         clearpict(c.InstructScreen);
    
         %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Learning the task with feedback        % -  still part of  instructed, non-learning version 
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         TargetTime=c.minTargetTime + rand(1,length(TrialType))*c.TargetTimeSpan;
         % Originally also had here: TargetDisplayTime=1500;
         ITI=c.minITI + rand(1,length(TrialType))*c.minITI;
         
         for count=1:(2*c.NperCond) % Originally 1:length(RandTrialTypeLearning) which is 4*c.NperCond
           TrialCue=RandTrialTypeLearning(count);
           Time2Target=TargetTime(count);
           ITI_trial=ITI(count);

           [data] = GNGb0_task_display_training (TrialCue,Time2Target,1, ...
                                        xlocation1,xlocation2,c.TargetDisplayTime, ...
                                        ITI_trial,c.randCSs,c.scr,LeftKey,RightKey);
           TaskDataLearning(count,:)=[count data];
         end

         %% Save some data
         timeStr = datestr(now,'yyyy-mm-dd_HH_MM');
         fName = [c.data_dir,'\',c.subj_name,'_GNGb0_TaskDataLearning_',num2str(c.session),'_',timeStr];
         save(fName,'TaskDataLearning');
         fName = [c.subj_name,'_GNGb0_Cogent_output_',num2str(c.session),'_',timeStr];  
         whereWeWere = pwd;
         cd(c.data_dir); % Sorry, this is v. sloppy, I didn't have the time to find things out ...
         eval( ['save ' fName] );
         cd(whereWeWere);    
         %% 
      
         % preparestring(['You would have won ' num2str(sum(TaskDataLearning(:,12))) ' pounds in this run'],c.InstructScreen)
         % drawpict(c.InstructScreen);
         % wait(2000);
         clearpict(c.InstructScreen);

         preparestring('+',c.InstructScreen)
         drawpict(c.InstructScreen);
         wait(1000);
         clearpict(c.InstructScreen);

         %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % Training on real-like task        % -  still part of  instructed, non-learning version 
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
         TaskData = GNGb0_real_like_practice( c.NperCond, ... % practice trials per condition. Total = this x 4 x 2
                                   xlocation1,xlocation2, ...
                                   LeftKey, RightKey );
         % NB GNGb0_real_like_practice also saves data as *dryRunData* - no need to save separately.
         
         % Now find some summary stats so that experimenter can decide to repeat
         % training or not :
         % REM: TaskData columns: 2-> trial type (G2W etc); 8-> decide or sham (1 or 2) ; 
         % 13 -> pt response - correct is 1 for Go trials, 0 for NoGo trials.
         G=size(find((TaskData(:,2)==1 | TaskData(:,2)==2) & TaskData(:,8)==1 & TaskData(:,13)==1),1)/size(find((TaskData(:,2)==1 | TaskData(:,2)==2) & TaskData(:,8)==1),1);
         NG=size(find((TaskData(:,2)==3 | TaskData(:,2)==4) & TaskData(:,8)==1 & TaskData(:,13)==0),1)/size(find((TaskData(:,2)==3 | TaskData(:,2)==4) & TaskData(:,8)==1),1);
       
         clearpict(c.InstructScreen);
         preparestring('Well done so far!',c.InstructScreen,0,60);         
         preparestring(['Go=',num2str(0.01*round(G*100)),', NoGo=',num2str(0.01*round(NG*100))],c.InstructScreen,0,0);
         preparestring('Experimenter: Please press',c.InstructScreen,0,-40);         
         preparestring('<SPACE> for another round of training,',c.InstructScreen,0,-80);         
         preparestring('<RETURN> to end',c.InstructScreen,0,-120);         
         drawpict(c.InstructScreen);        
         
         c.doTrainingKey = waitkeydown(inf);
         clearpict(c.InstructScreen);
        
       end % of while c.doTrainingKey ~= keyCode('RETURN',1);
       TotalWon = 0; % Training only - researcher doesn't have to pay pt. for this part.
       
end % end of block for instructed, non-discovery / non-learning version.
    

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if c.session ~=0, i.e. the real thing, not training ! %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if c.session ~= 0 && c.scanner == 0 && c.session_training < 2 % Learning version, outside scanner
    TaskData = GNGb0_learning_task_display( c , ... % total trials = c.NperCond x 4 x 2
                                   xlocation1,xlocation2, ...
                                   LeftKey, RightKey );
    TotalWon=sum(TaskData(:,17));    
  
elseif c.session ~= 0 && c.scanner ~= 0 && c.session_training < 2 % scanner version, has sham trials
                                        % where no circle appears.
    TargetTime=c.minTargetTime + rand(1,length(TrialType))*c.TargetTimeSpan;
    % Originally also had here: TargetDisplayTime=1500;
    ITI=c.minITI + rand(1,length(TrialType))*c.minITI;
    
    if c.scanner==1
        DummySlicesWait = c.NumDummies*c.SlicesVol;
        STWF = DummySlicesWait+1;   % Slice To Wait For
    else
        StartSlice1=0; SliceTime1=0;
    end
    
    clearpict(c.InstructScreen); 
    preparestring('In each trial you will now see one of four images; These signal',c.InstructScreen,0,150);
    preparestring('what the best thing to do is. Images will be followed by a cross,',c.InstructScreen,0,110);
    % preparestring('then a circle MAY appear. The circle means that you must decide',c.InstructScreen,0,70);
    % Replaced by '... will appear ...' for training with a view to behavioural experiment:
    preparestring('then a circle will appear. The circle means that you must decide',c.InstructScreen,0,70);
    preparestring('what to do. Sometimes you MUST PRESS the key used for responding.',c.InstructScreen,0,30);
    preparestring('Sometimes you MUST NOT PRESS anything to get the best result.',c.InstructScreen,0,-10);
    preparestring('On each trial you will see if you win money (up arrow), lose money',c.InstructScreen,0,-50);
    preparestring('(down arrow) or neither of the two (yellow line).',c.InstructScreen,0,-90);
    preparestring('... press a key to continue',c.InstructScreen,250,-175);
    drawpict(c.InstructScreen);
    waitkeydown(inf);
    clearpict(c.InstructScreen);
    
    preparestring('Get ready',c.InstructScreen,0,0);
    drawpict(c.InstructScreen);
    
    if c.scanner==1
        [StartSlice1,    SliceTime1] = waitslice(port,STWF);
    else
        wait(1000);
    end
    
    clearpict(c.InstructScreen);
    
    TotalWon=0;

    for count=1:length(RandTrialType)
        if c.scanner == 2
            disp('REMINDER: SCANNER EMULATOR, NOT THE REAL SCANNER, IS BEING USED');
        end
        TrialCue=RandTrialType(count);
        TrialCounter(TrialCue)=TrialCounter(TrialCue)+1;
        CurrentTrial=TrialNumber(TrialCounter(TrialCue),TrialCue);
        CurrentTrialTarget=TrialTarget(CurrentTrial);

        Time2Target=TargetTime(count);
        ITI_trial=ITI(count);

        [data] = GNGb0_task_display(TrialCue,Time2Target,CurrentTrialTarget, ...
                               xlocation1,xlocation2,c.TargetDisplayTime, ...
                               ITI_trial,c.randCSs,c.scr,LeftKey,RightKey);
        TaskData(count,:)=[count data];
    end
    timeStr = datestr(now,'yyyy-mm-dd_HH_MM');
    fName = [c.data_dir,'\',c.subj_name,'_GNGb0_TaskData_run_',num2str(c.session),'_',timeStr];
    save(fName,'TaskData');
    all_data=struct('StartSlice1',StartSlice1,'SliceTime1',SliceTime1,'TaskData',TaskData);
    fName = [c.data_dir,'\',c.subj_name,'_GNGb0_AllTaskData_run_',num2str(c.session),'_',timeStr];
    save(fName, 'all_data');
    
    preparestring('+',c.InstructScreen)
    drawpict(c.InstructScreen);
    if c.scanner ~= 0 
      waitkeydown(40000);
    else
      wait(1000)
    end
    clearpict(c.InstructScreen);

    TotalWon=TotalWon+sum(TaskData(:,17));
    %preparestring(['You won ' num2str(sum(TaskData(:,17))) ' pounds in this run'],c.InstructScreen)
    preparestring('Thanks for your efforts - and well done!',c.InstructScreen,0,0);
    preparestring('Please press a key to exit the Respond vs. Hold Back task.',c.InstructScreen,0,-175);
    drawpict(c.InstructScreen);
    waitkeydown(inf);
    clearpict(c.InstructScreen);

end % 'real' testing for either learning or instructed versions.

%% Tidy up **************************************************************

% If c.tempNetDir is not empty, which will be the case if we want to make the 
% outputs of the behavioural expt. available for other expts, esp. scanning, 
% copy over the output files to the appropr. temporary dir :
if strcmp(c.tempNetDir,'') ~= 1
  % must have already set: tempDir = [c.tempNetDir,'\',c.subj_name,'_', datestr(now,'yyyy-mm-dd')];
  if exist(tempDir,'dir') ~= 7; mkdir(tempDir); end;
  copyfile([c.data_dir,'\*',c.subj_name,'*'],tempDir);
end
  
%% Stop emulscan if necessary, then stop Cogent
if c.scanner == 2
  % lastslice(port) 
  stop_emulscan;
end

stop_cogent;
%%

% Display some summary statistics:
A=TaskData((TaskData(:,2)==1 | TaskData(:,2)==2) & TaskData(:,8)==1,:);
% A_B=TaskData((TaskData(:,2)==1 | TaskData(:,2)==2) & TaskData(:,8)==2,:);
B=TaskData((TaskData(:,2)==3 | TaskData(:,2)==4) & TaskData(:,8)==1,:);
% B_B=TaskData((TaskData(:,2)==3 | TaskData(:,2)==4) & TaskData(:,8)==2,:);
G=size(find((TaskData(:,2)==1 | TaskData(:,2)==2) & TaskData(:,8)==1 & TaskData(:,13)==1),1)/size(find((TaskData(:,2)==1 | TaskData(:,2)==2) & TaskData(:,8)==1),1)
NG=size(find((TaskData(:,2)==3 | TaskData(:,2)==4) & TaskData(:,8)==1 & TaskData(:,13)==0),1)/size(find((TaskData(:,2)==3 | TaskData(:,2)==4) & TaskData(:,8)==1),1)

stop_cogent;
clear global cogent;
clear global c;

end % Of whole function GNGb0  ********************************************
%*************************************************************************
