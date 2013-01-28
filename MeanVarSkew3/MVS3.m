function MVS3_earnings_summary = MVS3(dataDir, code, age, sex, paramset)
%% BEHAVIOURAL PREFERENCES AND NEURAL RESPONSES TO VARIANCE AND SKEWNESS 
% fMRI scanning and behaviourall using scanning emulation (emulscan). Usage e.g.:
% MVS3('\\abba\stimuli\Task_repository\NeuroSciPsychNet\practiceData', '001', 67, 'm',5)
% paramset refers to argument of MVS3_getparameters.
%
% Commonly adusted:
%   In MVS3_getparameters.m : 
%    usually under: elseif paramset == 5 % emulation-scanning for NSPN version 1
%     PARAMETERS.trials_per_block = 20;    % number of trials per block
%     PARAMETERS.number_of_blocks = 4;    % total number of blocks
%     PARAMETERS.NUM.post = 0; % 8 dummy volumes post for real scanning, set to 0 for behav. study.
%     PARAMETERS.screen_display = 1;                  %0 for small window, 1 for full screen

% Original by Mkael Symmonds - adapted by Michael Moutoussis for NeuroScience in Psychiatry
% Originally m file was called 'skewness_master7'

%Experimental setup - behavioural and scanning experiment
%program to present sequential pie-chart lotteries on the screen and
%register choices, between an on screen gamble or an offscreen sure amount
%either with timing for scanning experiment, or with
%timings for behavioural experiment
%
% - instruction screens
% - sure amount screen, wait
% - fixation cross, wait; variable ISI
% - pie on screen, wait
% - cue for response at certain time
% - await response within a certain time after cue: press keys
% - store response and stimuli
% - fixation cross again, wait
% - every 10 trials, select one gamble and run for real
% - store the outcome of this in a cumulative total winnings array
% - every 10 trials, present a new sure amount
% - cycle until all 250 trials presented
% - calculate payout
% - summary statistics of performance
% - save file with structure containing subject name, date/time, stimuli,
% - responses and reaction times
%

%FORMAT FOR DATA OUTPUT FROM PROGRAM
%
% SUBJECT.run_type   - the type of scanning run
% SUBJECT.run_params - the one letter abbreviation for the run type ('s',
% 'b', 'p', 't'
% SUBJECT.code     - the number identifier for the subject. If no number
% is entered, then the data file returned is called 'testfile.mat', and
% 'testfile.txt.'
% SUBJECT.gender     - gender, or N/A
% SUBJECT.age        - age, or N/A

% HEADER.matlab      - MATLAB version
% HEADER.cogent      - cogent version
% HEADER.date        - date of study (clock time)
% HEADER.version     - version and title of study

% PARAMETERS.trials_per_block =   n;
% PARAMETERS.sureamounts      =   sureamounts;
% PARAMETERS.gambles.amounts        =  
% PARAMETERS.gambles.probs        =  
% PARAMETERS.gambles.colours        =  
% PARAMETERS.gamblekey =          gamblekey;
% PARAMETERS.surekey =            surekey;
% PARAMETERS.ISItime =            ISItime;
% PARAMETERS.stimuluson_time  =   stimtime;
% PARAMETERS.cuescreen_time
% PARAMETERS.Outcomegraphic.
% PARAMETERS.number_of_blocks =   number of blocks
% PARAMETERS.number_of_trials =   number of choice trials
% PARAMETERS.total_number_of_presentation_screens = target + choice screens
% PARAMETERS.feedback=            

% DATA.exp_data_columns =          column headings for data array structure
% DATA.gamble =                  list of actual presented stimuli sequence
% DATA.exp_data =                  array of screen_number (rows) x 8 columns recording the experimental data
% 'trial number', 'current sure amount', 'gamble' , 'time of stimulus start', 'error code', 'choice',
% 'time of first keypress', 'reaction time', 'outcome'

%SLICE.start_experiment
%SLICE.
%SLICE.
%T.start_experiment


%results returned in files SKEW_SUBJECTNUMBER.mat, and SKEW_SUBJECTNUMBER.txt
%cogent log in file SKEW_SUBJECTNUMBER.log

%% Default arguments :
if nargin < 5
  paramset = input(['Press 5 for code testing, 6 for NSPN behavioural task, 7 for scanning: ']);
end
if nargin < 4
  sex = 'f';
  sexDigit = input(['Gender: press ''0'' (zero) for female, ''1'' (one) for male: ']);
  if sexDigit > 0.5 sex = 'm'; end;
end
if nargin < 3
  age    = input(['Age: input age in years: ']);
end
if nargin < 2
  code    = ['MVS' datestr(now,'yyyymmddHHMM')];
end
if nargin < 1
  dataDir = [getenv('HOMEDRIVE') getenv('HOMEPATH') '\nspn_data\detailed'];
end


%originally: clear all
clear global cogent;  clear('DATA');  % clear what may have been leftover by other progs
cwd = pwd;
addpath(cwd)
%% change directory-------------------------------------------------------%
% The last entry, usu. set to 0, is whether to ask user for this directory
% explicitly:
[computersetup, data_directory] = MVS3_set_data_directory(dataDir,0);
try
  cd(data_directory);
end
%% study parameters-------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% PARAMETERS FOR STUDY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% was: qstring = ['What parameter list? Enter the following:\n''1'' for test set\n''2'' for practicesess1\n''3'' for test pilot session 1\n''4'' for test pilot session 2\n\n''5'' for scanning session 1(emulscan)\n''10'' for scanning test\n''11'' for scanning test2\n\n'];

% qstring = ['Which parameter list? Enter :\n''1'' for test set\n\n''5'' for scanning or emulation scanning\n\n''6'' for 4-sector stimuli scanning or emulation scanning\n''11'' for scanning type 2\n\n>> '];
% scanning or behaviroural (scanning-emulation) with MEG-protocol (simplified) stimuli.
% paramset = input(qstring);

%get parameters for run
[PARAMETERS] =                   MVS3_getparameters(paramset);
PARAMETERS.computer  =           computersetup;

%% get stimulus list ---------------------------------------------------------%
%  %%%%%%%%%%%% GENERATE LIST/GET STIMULUS LIST FROM FILE %%%%%%%%%%%%%%%%%%%%%%%%
%  The following calls *_generatestimuluslists.m which in turn usually calls such as
%         load('MVS3opt5_stim_list.mat')
%         listin = LISTS.Gridchosen.list;
%  from which the actual list of stimuli is generated :

[SKEW_list, PARAMETERS.JITTERtimes] = MVS3_get_list(paramset, PARAMETERS);

% PARAMETERS.NUM.slicetot=SKEW_calculate_run_length(PARAMETERS, SKEW_list);
% 
% PARAMETERS.NUM.slicetot_per_run=PARAMETERS.NUM.slicetot;
% PARAMETERS.NUM.volumes=ceil(PARAMETERS.NUM.slicetot_per_run./PARAMETERS.NUM.slice);
%%

for run_number = 1:PARAMETERS.run_numbers
    RUNLIST = SKEW_list(:,:,run_number);
    RUNJITTERLIST = PARAMETERS.JITTERtimes(run_number,:);
% fprintf('The number of volumes for run %g is %g\t\n', run_number, PARAMETERS.NUM.volumes(run_number));
% fprintf('The number of slices for run %g is %g\n\n', run_number, PARAMETERS.NUM.slicetot_per_run(run_number));
% fprintf('The time for run %g is %g\n', run_number, PARAMETERS.NUM.volumes(run_number)*(PARAMETERS.TIMINGS.tr)./60);
% end

%% create data structure -------------------------------------------------------------%
% create data strucure for experiment, used in storing data for each trial
DATA.exp_data.numbers = zeros(size(SKEW_list,1), 10);            % initialize data array to preallocate memory
DATA.exp_data.times = zeros(size(SKEW_list,1), 16); 
DATA.stimuli = zeros(size(SKEW_list,1), size(SKEW_list,2));            %store sequential gambles
DATA.exp_data_columns = {'trial number',}; %%FILL THIS IN
%this helps to remember what the data mean!!

%% subject details--------------------------------------------------------%
%% %%%%%%%%%%% RECORD DETAILS FOR SUBJECT AND RESULTS FILE %%%%%%%%%%%%%%%
%fprintf('\nIf you have selected param. code 5 please select s in the following:\n')
[SUBJECT result]  = MVS3_record_subject_details(code, age, sex);
SUBJECT.parameter_set=paramset;

%% configure cogent settings ---------------------------------------------%
config_display(PARAMETERS.screen_display, PARAMETERS.screen_resolution); % display settings
config_keyboard

switch SUBJECT.run_params
 case {'s'} % This is a remnant from when it might not have been 's', when used SKEW_record_subject_details
  if PARAMETERS.port ~= 0
    config_serial(1)
  end
 otherwise
end

%------------------------------------------------------------------------%
%% configure HEADER
date = clock;

HEADER.date = clock;
HEADER.matlab = version;
HEADER.version.cogent = 'Cogent2000v1.25';
HEADER.version.title = 'Neural Responses to mean-variance-skewness adapted from Symmonds et al for NSPN team by Michael Moutoussis';
HEADER.datakey = strvcat ('trial number', 'current target', 'condition code' , 'time of stimulus start',...
    'error code', 'choice', 'time of first keypress', 'reaction time', 'outcome', 'block total', 'target reached?');
% HEADER.datacode =strvcat ('current trial number', )

%% %%%%%%%%%%%%%%%%  Now we are ready to start the experiment ! %%%%%%%%%%%%%%%%%%%%
if PARAMETERS.port ~= 0 % i.e. if we are not going to run emulscan, stop here and
  % wait for experimenter to signal that all other gear is ready :
  fprintf('This is the start of run %g', run_number);

  exp_go = 0;
  while exp_go~=1 
      exp_go = input('\nEnter ''1'' to start with scanning \n\n>> ');
      if isempty(exp_go) 
          exp_go = 0;
      end
  end
end
%% start cogent and scale screen
start_cogent
HEADER.subjectdetails = ['subject: ' SUBJECT.code ', started at: ' datestr(now,30)];


%% create sprites/text functions-------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%CREATE SPRITES AND TEXT FUNCTIONS%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sprite list
%
%------------------------------------------------------------------------%

%% generate fixation cross - sprite number 6
cgmakesprite (6, 20, 20, 0, 0, 0);          %create sprite with black background
cgsetsprite (6);                          %ready sprite to draw into
cgpencol (1, 1, 1);                       %white pen colour
cgfont ('Arial',20);                       %'+' sign is 20 pixels
cgtext ('+',0,0);
cgsetsprite (0);                          %set draw location back to offscreen
%------------------------------------------------------------------------%
%% generate sure amount text sprites - numbers 20 and 21 (low and high
%% target). NEED TO CHANGE NUMBER OF ARGUMENTS IF MORE THAN 2 TARGETS
MVS3_sureamounts(num2str(PARAMETERS.trials_per_block), PARAMETERS.sure_amounts);

%% set key codes for key presses
keymap = getkeymap;
abortkey = keymap.Escape;       %abort if escape key is pressed

%% Pt. instructions & response key selection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instructions 
MVS3_pt_instructions(PARAMETERS,0);
  
% Key selection:
if paramset==1
    gamblekey = keymap.G;     %gamble key = G
    surekey = keymap.S;       %sure key = S
else
    cgfont('Arial',20);
    reps = [0 0];
    while sum(reps) ~=2
        for i = 1:2
            cgtext('按"G" 键 (用此键选择投注):',0,0);
            cgflip(0,0,0);
            [ky tim rp] = waitkeydown(inf);
            ky1(i) = ky(1);
            cgtext('按 "S" 键 (用此键选择确定数额):',0,0);
            cgflip(0,0,0);
            [ky tim rp] = waitkeydown(inf);
            ky2(i) = ky(1);
        end
        reps =[(ky1(1)==ky1(2) && ky1(1)==keyCode('G',PARAMETERS.context))...
               (ky2(1)==ky2(2) && ky2(1)==keyCode('S',PARAMETERS.context))    ];
           
    end
    
    gamblekey = ky1(1);
    surekey = ky2(1);
end

%save key codes
PARAMETERS.keys.gamblekey =          gamblekey;
PARAMETERS.keys.surekey =            surekey;
PARAMETERS.keys.abortkey =           abortkey;
%% 

switch SUBJECT.run_params
    case {'b', 'p', 't'}   % This is a leftover which can be tidied away.       
        fprintf('Error - invalid run parameter code (was b, p or t)\n\n\n');
        stop_cogent
        clear all;
        
    case {'s'}
        %for SCANNING + EMULSCANNING
        if PARAMETERS.port==0 % && paramset==5 % originally: strcmp(PARAMETERS.port, 'net')
            % was config_emulscan('allegra',48,PARAMETERS.NUM.volumes,0);
            % In the following line, not sure about the sum(), it assumes
            % that this number of volues will have to cover several runs if
            % run_numbers is > 1
            %config_emulscan('allegra',48,sum(PARAMETERS.NUM.volumes));

            % just put a big number and we'll see ...
            config_emulscan('allegra',48,100000);
            start_emulscan
        end

        %% Start Experiment : %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Show instructions
        %load stimuli list - including gambles and sure amounts
        %present fix cross (for ITItime)+jitter
        %log time of presentation of fix as start of trial
        %present stimulus (pie) - after ITItime
        %log time of presentation of pie
        %wait stimtime until presenting response cue
        %log keypresses during response window
        %record correct and incorrent presses, and choices
        %?error screen if necessary
        %present next stimulus
        %present the next sure amount screen at the end of a block
        %record results in a results .mat file
            
        T.start_experiment = time;   % record the time of the beginning of the trial sequence (cogent time)
        current_sureamount = -1000;  % dummy starting value for the current sure amount
        trial_counter = 1;  %trials only counted for gamble presentations, not sure amount screens
        %set font name,size%
        cgfont(PARAMETERS.fontname,PARAMETERS.fontsize)
        %cycle through stimulus list
        for screen_number=1:size(SKEW_list,1)
            
            if screen_number==1                  
                cgflip(0, 0, 0);
                cgdrawsprite (6, 0, 0); %fixation cross
                T.trialstart =cgflip (0, 0, 0);
                waitslice(PARAMETERS.port, 1); % to use up any left over large slice numbers from previous runs
                %%
                disp('Waiting for dummy slices ...');
                [SLICE.start_experiment T.start_experiment]=waitslice(PARAMETERS.port, PARAMETERS.NUM.slice*PARAMETERS.NUM.dummy +1);  
                
                SLICE.trialstart=SLICE.start_experiment;
                %SLICE.start_experiment is the actual slice number of the start of the
                %experiment(i.e. after the dummy scans)
            else
                cgflip(0, 0, 0);                            % show blank screen
                cgdrawsprite (6, 0, 0);                     % fixation cross
                cgflip (0, 0, 0);              %present cross on screen and clear offscreen
                [SLICE.trialstart T.trialstart] =  lastslice(PARAMETERS.port);
            end
            disp('Waiting for length of ISI');
            waitslice(PARAMETERS.port, SLICE.trialstart + PARAMETERS.TIMINGS.ISI + RUNJITTERLIST(screen_number));      %wait for length of ISI
            
            %% draw stimulus
            
            if RUNLIST(screen_number,1)>=0                     %if stim is a pie gamble
                
                DATA.stimuli.gamble(screen_number,:) = RUNLIST(screen_number, :); %store actual presented stimulus in DATA.carddraw
                
                %draw gamble onscreen
                [PIE(trial_counter).data]  = MVS3_drawgamble(RUNLIST(screen_number, :), PARAMETERS.gamble.cixf, 0,-1, current_sureamount, 0);   %get ready to draw gamble (T.stimulusstart = time)
                cgflip(0,0,0);               %present picture on screen 
                [SLICE.stimulusstart T.stimulusstart] =  lastslice(PARAMETERS.port)
                %                 
                T.stimulusstart = time;
                % wait until end of presentation time of stimulus
                clearkeys %get keypresses during this time (not meant to press a key)
                waitslice(PARAMETERS.port, SLICE.stimulusstart + PARAMETERS.TIMINGS.stimuluson);
                
                if PARAMETERS.cue_on == 1
                    %?check if key has been pressed too early?
                    %***********
                    readkeys
                    %wait for length of stimtime for one of the keys to be pressed
                    [KEY.time1.out,KEY.time1.time,KEY.time1.npress] = getkeydown; %([gamblekey surekey 52]) - for specific keys only to be recorded;
                    if KEY.time1.npress>0                      %if a key has been pressed
                        if any(KEY.time1.out==abortkey)             % escape key stops the program
                            break;
                        else
                            KEY.time1.error = -1;              %record a key error - key pressed before cue
                            choice = PARAMETERS.NullValue;               %a dummy number for invalid trial
                        end
                    else                                %if no key is pressed
                        KEY.time1.error = 0;                  %record no key error
                        choice = PARAMETERS.NullValue;                   %dummy number for an invalid trial
                        KEY.time1.time(1) = PARAMETERS.NullValue;              %dummy number for an invalid trial
                    end
                    
                    %***********
                    % clear keyboard buffer to avoid garbage from previous keypresses
                    clearkeys;   % cogent will store all keypresses from now on until 'readkeys' below
                    
                    
                else
                    KEY.time1.time = [];
                    KEY.time1.error = 0;
                    KEY.time1.npress = 0;
                end
                
                [SLICE.cuestart, T.cuestart] = lastslice(PARAMETERS.port);
                key_selection = 0;
                pressed = 0;
                %while loop put in on 16-7-9 for indication of key press
                while time < T.cuestart + PARAMETERS.TIMINGS.cuetime
                    %now draw gamble with cue
                    MVS3_drawgamble(RUNLIST(screen_number, :), PARAMETERS.gamble.cixf, PARAMETERS.cue_on, PIE(trial_counter).data(1), current_sureamount, key_selection); 
                    cgflip(0,0,0);    
                                        
                    %% key presses
                    
                    if ~pressed
                        % read keyboard input: gamblekey - for gamble, surekey - for sure, or escape (for exit) keys
                        
                        readkeys;                           %get key presses during trial
                        
                        [KEY.out,KEY.time,KEY.npress] = getkeydown;
                        %record choi
                        if KEY.npress>0                      %if a key has been pressed
                            pressed = 1; %tell the while loop a key has been pressed so that it doesn't overwrite
                            if any(KEY.out==abortkey)             % escape key stops the program
                                break;
                            elseif KEY.out(1) == gamblekey         %if first key pressed is gamble
                                choice=1;                           %choice is gamble
                                KEY.error=0;                % a valid key press
                                key_selection = 1;
                            elseif KEY.out(1) == surekey       %if first key pressed is space
                                choice=0;                   %choice is sure
                                KEY.error=0;                %a valid key press
                                key_selection = 2;
                            else
                                KEY.error = 1;                   %record a key error - wrong key
                                choice = PARAMETERS.MistakeCode; % dummy number for wrong key trial
                                key_selection = 3;    
                            end
                        else                                %if no key is pressed
                            KEY.error = 2;                  %record a key error - no key
                            choice = PARAMETERS.NullValue;      %dummy number for an invalid trial
                            KEY.time(1) = PARAMETERS.NullValue; %dummy number for an no key trial
                        end
                    end
                end
                % data logging: columns 'trial_counter', 'target_level', 'condition','T.stimulusstart','KEY.error','choice','KEY.time','RT'
                DATA.exp_data.numbers(screen_number,1) = screen_number;   
                DATA.exp_data.numbers(screen_number,2) = trial_counter; %trial number
                DATA.exp_data.numbers(screen_number,3) = current_sureamount;                         %current target level
                DATA.exp_data.numbers(screen_number,4) = KEY.time1.error; % was a key pressed too early
                DATA.exp_data.numbers(screen_number,5) = -KEY.time1.npress; %number of times wrong key pressed
                DATA.exp_data.numbers(screen_number,6) = KEY.error; %was there a main key error
                DATA.exp_data.numbers(screen_number,7) = KEY.npress; %number of times key pressed
                DATA.exp_data.numbers(screen_number,8) = choice; %choice gamble or sure
                
                DATA.exp_data.times(screen_number,1) = screen_number;
                DATA.exp_data.times(screen_number,2) = trial_counter;
                DATA.exp_data.times(screen_number,3) = T.start_experiment; 
                DATA.exp_data.times(screen_number,4) = T.trialstart;                        % time at which stimulus was presented
                DATA.exp_data.times(screen_number,5) = T.stimulusstart;
                DATA.exp_data.times(screen_number,6) = KEY.time1.time(1);
                DATA.exp_data.times(screen_number,7) = T.cuestart;
                DATA.exp_data.times(screen_number,8) = KEY.time(1);
                DATA.exp_data.times(screen_number,16) = KEY.time(1) - DATA.exp_data.times(screen_number,4); %RT
                
                DATA.exp_data.slices(screen_number,1) = screen_number;
                DATA.exp_data.slices(screen_number,2) = trial_counter;
                DATA.exp_data.slices(screen_number,3) = SLICE.start_experiment; 
                DATA.exp_data.slices(screen_number,4) = SLICE.trialstart;                        % time at which stimulus was presented
                DATA.exp_data.slices(screen_number,5) = SLICE.stimulusstart;
                DATA.exp_data.slices(screen_number,6) = KEY.time1.time(1);
                DATA.exp_data.slices(screen_number,7) = SLICE.cuestart;
                DATA.exp_data.slices(screen_number,8) = KEY.time(1);
                DATA.exp_data.slices(screen_number,16) = KEY.time(1) - DATA.exp_data.times(screen_number,4); %RT
                
                
                
                
                % **FEEDBACK / OUTCOME SCREEN **
                
                if isequal(trial_counter/PARAMETERS.trials_per_block, floor(trial_counter/PARAMETERS.trials_per_block)) %block end when trial_counter/n is an integer
                    %% * * * * * Lotteries to be actually played and paid * * * * 
                    %fixation cross, text
                    cgflip(0, 0, 0);                        % show blank screen
                    cgdrawsprite (6, 0, 0);                 % fixation cross
                    [SLICE.lasttrialstart T.lasttrialstart]= lastslice(PARAMETERS.port);                    %T.trialstart records time that fixation cross is presented
                    cgflip (0, 0, 0);                       %present cross on screen and clear offscreen
                    waitslice(PARAMETERS.port, SLICE.lasttrialstart + PARAMETERS.TIMINGS.endblock1);      %wait for length of ISI
                    cgpencol(1,1,1)
                    % text('Selecting one lottery from block:', 0, 0)
                    [SLICE.lasttrialtext1 T.lasttrialtext1] = lastslice(PARAMETERS.port);
                    % flip(0,0,0)
                    % waitslice(PARAMETERS.port, SLICE.lasttrialtext1 + PARAMETERS.TIMINGS.endblock2); %change these timings
                    %select one of the last n trials
                    selected_trial = trial_counter - floor(rand*PARAMETERS.trials_per_block); %select a number from block
                    [RoulT, RoulS, out_ang, out_amt]          =  MVS3_skewness_drawroulette(PARAMETERS, current_sureamount, PIE(selected_trial).data, PARAMETERS.gamble.cixf,    DATA.exp_data.numbers(screen_number - (trial_counter - selected_trial),8)); %find the choice made for the selected outcome

                    T.lasttrialtext2 = RoulT.texta;
                    T.lasttrialtext3 = RoulT.textb;
                    T.lasttrialoutstart = RoulT.startout;
                    T.lasttrialspinend = RoulT.endspin;
                    T.lasttrialend = RoulT.end;
                    
                    %% *********STORE DATA ABOUT BLOCK OUTCOME*******************
                    DATA.exp_data.numbers(screen_number,9) = out_ang  %record end of block total
                    DATA.exp_data.numbers(screen_number,10) = out_amt;  %record outcome of block
                    
                    DATA.exp_data.times(screen_number,9) = T.lasttrialstart;
                    DATA.exp_data.times(screen_number,10) = T.lasttrialtext1;
                    DATA.exp_data.times(screen_number,11) = T.lasttrialtext2;
                    DATA.exp_data.times(screen_number,12) = T.lasttrialtext3;
                    DATA.exp_data.times(screen_number,13) = T.lasttrialoutstart;
                    DATA.exp_data.times(screen_number,14) = T.lasttrialspinend;
                    DATA.exp_data.times(screen_number,15) = T.lasttrialend;
                    
                    DATA.exp_data.slices(screen_number,9) = SLICE.lasttrialstart;
                    DATA.exp_data.slices(screen_number,10) = SLICE.lasttrialtext1;
                    DATA.exp_data.slices(screen_number,11) = RoulS.texta;
                    DATA.exp_data.slices(screen_number,12) = RoulS.textb;
                    DATA.exp_data.slices(screen_number,13) = RoulS.startout;
                    DATA.exp_data.slices(screen_number,14) = RoulS.endspin;
                    DATA.exp_data.slices(screen_number,15) = RoulS.end;
                else
                    DATA.exp_data.numbers(screen_number, 9:10) = PARAMETERS.NullValue;
                    DATA.exp_data.times(screen_number,9:15) = PARAMETERS.NullValue;  %record dummy values if not block end
                    DATA.exp_data.slices(screen_number,9:15) = PARAMETERS.NullValue;     
                end
                trial_counter = trial_counter + 1;          %move trial counter on by 1 for every actual trial
                 %********************************************************
            else %******if stimulus is for a sure amount screen***********
                 %******************************************************
                current_sureamount= -RUNLIST(screen_number,1); %current target specified by the array target_levels
                sprite_number_to_draw = 20 + find(current_sureamount==PARAMETERS.sure_amounts)-1; %draw sprite number 20 for lowest target, 21 for next, etc.
                
                cgdrawsprite(sprite_number_to_draw,0,0)        %put sprite in centre of offscreen
                [SLICE.surestart, T.surestart] = lastslice(PARAMETERS.port);      %record start time for target
                cgflip(0,0,0)               %present picture on screen
                % wait until end of presentation time of stimulus
                %waituntil(T.surestart + PARAMETERS.TIMINGS.surescreen); % added by MM instead of line below.
                waitslice(PARAMETERS.port, SLICE.surestart + PARAMETERS.TIMINGS.surescreen);
                
                DATA.exp_data.numbers(screen_number,1) = screen_number;      % trial_counter column records a dummy result for this screen
                DATA.exp_data.numbers(screen_number,3) = current_sureamount;
                DATA.exp_data.numbers(screen_number,[2, 4:10]) = -10;              % write in -10 for the inital trial in a block in the response columns
                
                DATA.exp_data.times(screen_number,1) = screen_number;
                DATA.exp_data.times(screen_number,3) = T.start_experiment; 
                DATA.exp_data.times(screen_number,4) = T.surestart; 
                DATA.exp_data.times(screen_number,[2, 5:16]) = -10;
                
                DATA.exp_data.slices(screen_number,1) = screen_number;
                DATA.exp_data.slices(screen_number,3) = SLICE.start_experiment; 
                DATA.exp_data.slices(screen_number,4) = SLICE.surestart; 
                DATA.exp_data.slices(screen_number,[2, 5:16]) = -10;
            end %end of if clause for current trial
            
            if str2num(HEADER.matlab(1))~=6
                save ([result.filename2 '_run' num2str(run_number) '.mat'], 'SUBJECT', 'HEADER', 'PARAMETERS', 'DATA', 'SKEW_list', 'RUNLIST', 'RUNJITTERLIST', '-v6'); % save data after each trial, to avoid lost data
                % if session is interrupted
            else
                save([result.filename2 '_run' num2str(run_number) '.mat'], 'SUBJECT', 'HEADER', 'PARAMETERS', 'DATA', 'SKEW_list', 'RUNLIST', 'RUNJITTERLIST');
            end
            
        end %end of for loop for test run
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%SCREENS AT END OF EXPERIMENT%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if any(KEY.out==abortkey) || any(KEY.time1.out==abortkey)       
            fprintf('...aborted\n');    % print out error message
            cgflip(0, 0, 0);                        % show blank screen
            cgalign ('c', 'c');                     %align centrally
            cgtext ('ESCAPE 键已按下', 0, 0);
            cgflip(0,0,0)
            wait(3000)
            if PARAMETERS.port==0
                stop_emulscan;
            end
            stop_cogent
            break
        else
            %%when all stimuli have been presented, present fixation cross, then thank you and stop cogent
            cgflip(0, 0, 0);                        % show blank screen
            cgdrawsprite (6, 0, 0);                 % fixation cross
            cgflip (0, 0, 0);                       %present cross on screen and clear offscreen
            
            % wait(3000);                             %wait 3s
            
            [SLICE.end_experiment, T.end_experiment] = waitslice(PARAMETERS.port, lastslice(PARAMETERS.port) + (PARAMETERS.NUM.slice*PARAMETERS.NUM.post));  %wait for post volumes
            cgalign ('c', 'c');                     %align centrally
            cgpencol(1,1,1);
            cgtext ('轮盘赌任务结束 - 谢谢!', 0, 0);
            cgflip (0, 0, 0);
            wait(2000);                             %wait 2s
            % Can use a 'press key to end' message above, then:
            % waitkeydown (inf, keymap.Space);
        end
        
        
        %save stuff at very end
        DATA.endslice = SLICE.end_experiment;
        DATA.endtime=T.end_experiment;
        DATA.totalvolumes = SLICE.end_experiment/PARAMETERS.NUM.slice;
        DATA.total_run_time_millisecs = T.end_experiment-T.start_experiment;
        DATA.total_run_time_mins = (T.end_experiment-T.start_experiment)/(1000*60);
        DATA.total_time_mins=T.end_experiment/(1000*60);
        
        if str2num(HEADER.matlab(1))~=6
            save ([result.filename2 '_run' num2str(run_number) '.mat'], 'SUBJECT', 'HEADER', 'PARAMETERS','DATA','SKEW_list', 'RUNLIST', 'RUNJITTERLIST', '-v6'); % save data at end with end times and slice
        else
            save([result.filename2 '_run' num2str(run_number) '.mat'], 'SUBJECT', 'HEADER', 'PARAMETERS','DATA', 'SKEW_list', 'RUNLIST', 'RUNJITTERLIST');
        end
        
        
        
        
    otherwise %if no valid code entry
        
        fprintf('Error - invalid run parameter code\n\n\n');
        clear all;
        
end %end of switch

%% Stop emulscan if necessary, then stop Cogent
if PARAMETERS.port==0
  lastslice(PARAMETERS.port) 
  stop_emulscan;
    
end

stop_cogent
%%

end %end of experimental run


%% ** calculate overall amount won as well as summary array of earnings for NSPN use **
for run_number = 1:PARAMETERS.run_numbers
  load([result.filename2 '_run' num2str(run_number) '.mat'])
  pay(run_number) = sum(DATA.exp_data.numbers(DATA.exp_data.numbers(:,end)>0, end));
end
pay;
fprintf(['\n\nTotal amount won = ' num2str(sum(pay)) '\n\n'])

MVS3_earnings_summary = MVS3_earnings(DATA, SKEW_list, PARAMETERS);

%% ********************************* End of whole script *******************************
end
%%
