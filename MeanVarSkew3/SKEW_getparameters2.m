function [PARAMETERS] = SKEW_getparameters2(paramset)
% SKEW_getparameters2(paramset) sets the parameters for the mean-variance-skewness programs,
% such as skewness_master*, MVS* etc.
% argument paramset >=10 for real scanning, 5 for emulscanning.


% Edited from original written by M Symmonds for use in Neuroscience in Psychiatry
% Project by Michael Moutoussis

if paramset == 1 %testing program
    
    PARAMETERS.trials_per_block = 2;               %number of trials per block
    PARAMETERS.number_of_blocks = 5;                %total number of blocks
    PARAMETERS.sure_amounts = [40 50 60];           %sureamounts
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 4500;        %duration that stimulus is on screen for (during which time subject has to make a response)

    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000;
    PARAMETERS.TIMINGS.endblock2 = 2000;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000;
    PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;      % skew_settings uses this to create a list of random colours.
    
elseif paramset==2 %behavioural piloting, practice session 1

    %20 stimuli in practice block, feedback every 4 trials

    PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs

    %% The following block copied over from elseif paramset ==11 so that
    %  this option can be used with scanning-oriented programs
    PARAMETERS.TIMINGS.slice = 65;            % tr per slice time in ms
    PARAMETERS.NUM.slice = 42;                % number of slices per volume
    PARAMETERS.TIMINGS.tr = (PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice)./1000;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 29;           %mean jitter time is 0, 30, 60 slices
    %%

    PARAMETERS.trials_per_block = 5;          % number of trials per block
    PARAMETERS.number_of_blocks = 4;          % total number of blocks
    PARAMETERS.sure_amounts = [30 50];        % sureamounts - need to be a factor of num blocks

    PARAMETERS.cue_on = 1;                    % use cue or not
    PARAMETERS.TIMINGS.ISI = 2000;            % ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500;     % duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;        % response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000;
    PARAMETERS.TIMINGS.endblock2 = 2000;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000;
    PARAMETERS.screen_display = 0;            % 0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;               % just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;

    %% Scanning specific - to use option with scanning-oriented programs :
    % make a list of jitters for each trial as long as the screen list
    jitterarr = [0 1 2];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)-1
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
    PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;

    PARAMETERS.NUM.dummy = 6;     % 6 dummy volumes initially ( = 6*48 slices)
    PARAMETERS.NUM.post = 8;      % 8 dummy volumes post
    PARAMETERS.port=0;            %  set serial port to 1 for the scanner, 0
                                  %  for testing.    
    %%

    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials./60000 + ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks./60000 + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)./60000;
    
elseif paramset==3 %behavioural piloting, real session 1
    %180 stimuli in practice block, feedback every 10 trials
    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
    PARAMETERS.trials_per_block = 12;               %number of trials per block
    PARAMETERS.number_of_blocks = 15;                %total number of blocks
    PARAMETERS.sure_amounts = [45 60 75];           %sureamounts - need to be a factor of num blocks
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500;        %duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000;
    PARAMETERS.TIMINGS.endblock2 = 2000;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000;
    PARAMETERS.screen_display = 1;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 3;
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials./60000 + ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks./60000 + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)./60000;
    
elseif paramset==4 %behavioural piloting, real session 2
    %180 stimuli in practice block, feedback every 10 trials
    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
    PARAMETERS.trials_per_block = 12;               %number of trials per block
    PARAMETERS.number_of_blocks = 15;                %total number of blocks
    PARAMETERS.sure_amounts = [45 60 75];           %sureamounts - need to be a factor of num blocks
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500;        %duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000;
    PARAMETERS.TIMINGS.endblock2 = 2000;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000;
    PARAMETERS.screen_display = 1;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;

    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials./60000 + ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks./60000 + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)./60000;
    
    
    elseif paramset==7 %behavioural piloting, practice session 2
    %20 stimuli in practice block, feedback every 4 trials
    PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
    PARAMETERS.trials_per_block = 5;               %number of trials per block
    PARAMETERS.number_of_blocks = 4;                %total number of blocks
    PARAMETERS.sure_amounts = [30 50].*2;           %sureamounts - need to be a factor of num blocks
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500;        %duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000;
    PARAMETERS.TIMINGS.endblock2 = 2000;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000;
    PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials./60000 + ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks./60000 + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)./60000;

   
% elseif paramset==6 %behavioural piloting, real session 3
%     %180 stimuli in practice block, feedback every 12 trials
%     %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
%     PARAMETERS.trials_per_block = 12;               %number of trials per block
%     PARAMETERS.number_of_blocks = 15;                %total number of blocks
%     PARAMETERS.sure_amounts = [45 60 75].*2;           %sureamounts - need to be a factor of num blocks
%     PARAMETERS.cue_on = 1;                          %use cue or not
%     PARAMETERS.TIMINGS.ISI = 2000;                 %ISI duration after fixation cross appears to onset of stimulus
%     PARAMETERS.TIMINGS.stimuluson = 5500;        %duration that stimulus is on screen for before cue on
%     PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
%     PARAMETERS.TIMINGS.endblock1 = 2000;
%     PARAMETERS.TIMINGS.endblock2 = 2000;
%     PARAMETERS.TIMINGS.endblock3 = 2000;
%     PARAMETERS.TIMINGS.endblock4 = 2000;
%     PARAMETERS.TIMINGS.endblock5 = 4000;
%     PARAMETERS.TIMINGS.T_end = 6000;
%     PARAMETERS.TIMINGS.surescreen = 3000;
%     PARAMETERS.screen_display = 1;                  %0 for small window, 1 for full screen
%     PARAMETERS.run_numbers = 1;                     %just have 1 run for test
%     PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
%     settings = 4;
%     PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials./60000 + ...
%         (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks./60000 + ...
%         (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)./60000;
%     
%     
    
    
elseif paramset ==5 || paramset ==6 %scanning run 1
    
    % 180 stimuli in practice block, feedback every 10 trials

    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs   
    PARAMETERS.TIMINGS.slice = 65;      % tr per slice time in ms
    PARAMETERS.NUM.slice = 48;          % number of slices per volume
    PARAMETERS.TIMINGS.tr = PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 30;     % mean jitter time is 0, 30, 60 slices

    PARAMETERS.trials_per_block = 5;    % number of trials per block
    PARAMETERS.number_of_blocks = 4;    % total number of blocks
    PARAMETERS.sure_amounts = [30 50];  % sureamounts - need to be a factor of num blocks
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000./PARAMETERS.TIMINGS.slice;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500/PARAMETERS.TIMINGS.slice;        %duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock2 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials+ ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)
 
    %% Scanning specific: 

    % Copied from option 11: 
%     jitterarr = [0 1 2];
%     PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
%     for k = 1:PARAMETERS.numberofscreens./length(jitterarr)-1
%         jitterarr = [jitterarr, jitterarr(randperm(3))];
%     end
%     PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;
% 
%     PARAMETERS.NUM.dummy = 6;                      %6 dummy volumes initially ( = 6*48 slices)
%     PARAMETERS.NUM.post = 8;                       %8 dummy volumes post
%     PARAMETERS.port=1;                  %set serial port to 1 for the scanner    
     
    %make a list of jitters for each trial as long as the screen list
    jitterarr = [1 2 3];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
   
    PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;
    
    PARAMETERS.NUM.dummy = 6;   % 6 dummy volumes initially ( = 6*48 slices)
    PARAMETERS.NUM.post = 8;    % 8 dummy volumes post
    PARAMETERS.port=input('\nEnter serial port (0 for scan emulation, 1 for real scanning):\n\n>> '); 
                                % set serial port. Was 'net' for emulscan
                                %  originally -> changed to 0 for emulscan.    
    %%
    
    PARAMETERS.run_numbers = 1; % was: input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs

   elseif paramset ==10 %scanning run 2 - testing in Allegra 1
    
        %180 stimuli in practice block, feedback every 10 trials
    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
    
    PARAMETERS.TIMINGS.slice = 65;                    % tr per slice time in ms
    PARAMETERS.NUM.slice = 48;                     % number of slices per volume
    PARAMETERS.TIMINGS.tr = PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 29;                   %mean jitter time is 0, 30, 60 slices
    PARAMETERS.trials_per_block = 5;               %number of trials per block
    PARAMETERS.number_of_blocks = 4;                %total number of blocks
    PARAMETERS.sure_amounts = [30 50];           %sureamounts - need to be a factor of num blocks

    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000./PARAMETERS.TIMINGS.slice;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500/PARAMETERS.TIMINGS.slice;        %duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock2 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.screen_display = 1;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 4; %doubled amounts of money
    

    %make a list of jitters for each trial as long as the screen list
    %****************%need to change this line!!!
    
    jitterarr = [1 2 3];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
   
    PARAMETERS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;
    
    
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials+ ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)
    
    PARAMETERS.NUM.dummy = 6;                      %6 dummy volumes initially ( = 6*48 slices)
    PARAMETERS.NUM.post = 8;                       %8 dummy volumes post
    PARAMETERS.port= input('Port 0 (emulscan) or 1 (real scanning)?:\n >> ') % Set serial port to 1 for the scanner    
              %set serial port to 1 for the scanner
    
    
   PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
    
elseif paramset ==11 %scanning run 3 - testing in Allegra 2
    
        %180 stimuli in practice block, feedback every 10 trials
    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
    
    PARAMETERS.TIMINGS.slice = 65;                    % tr per slice time in ms
    PARAMETERS.NUM.slice = 42;                     % number of slices per volume
    PARAMETERS.TIMINGS.tr = (PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice)./1000;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 29;                   %mean jitter time is 0, 30, 60 slices
   
    PARAMETERS.trials_per_block = 12;               %number of trials per block
    PARAMETERS.number_of_blocks = 15;                %total number of blocks
    PARAMETERS.sure_amounts = [45 60 75].*2;           %sureamounts - need to be a factor of num blocks
    
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 2000./PARAMETERS.TIMINGS.slice;                 %ISI duration after fixation cross appears to onset of stimulus
    PARAMETERS.TIMINGS.stimuluson = 5500/PARAMETERS.TIMINGS.slice;        %duration that stimulus is on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock2 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock3 = 2000;
    PARAMETERS.TIMINGS.endblock4 = 2000;
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 6000;
    PARAMETERS.TIMINGS.surescreen = 3000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run for test
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 4; %doubled amounts of money

    %% Scanning specific:
    % make a list of jitters for each trial as long as the screen list
    jitterarr = [0 1 2];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)-1
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
    PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;

    PARAMETERS.NUM.dummy = 6;                      %6 dummy volumes initially ( = 6*48 slices)
    PARAMETERS.NUM.post = 8;                       %8 dummy volumes post
    PARAMETERS.port= input('Port 0 (emulscan) or 1 (real scanning)?:\n >> ') %1;                  %set serial port to 1 for the scanner    
    %% 

    PARAMETERS.run_numbers  =  input('\nHow many runs would you like to use in this session?\n\n>>'); %runs

    PARAMETERS.estimatedtotaltime = ((PARAMETERS.NUM.dummy+PARAMETERS.NUM.post)*PARAMETERS.NUM.slice*PARAMETERS.TIMINGS.slice+sum(PARAMETERS.TIMINGS.JITTERtimes)*PARAMETERS.TIMINGS.slice+(PARAMETERS.TIMINGS.ISI*PARAMETERS.TIMINGS.slice+PARAMETERS.TIMINGS.stimuluson*PARAMETERS.TIMINGS.slice +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials+ ...
        (PARAMETERS.TIMINGS.endblock1*PARAMETERS.TIMINGS.slice +  PARAMETERS.TIMINGS.endblock2*PARAMETERS.TIMINGS.slice + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen*PARAMETERS.TIMINGS.slice))./(1000*60)
   
else
    fprintf('Invalid parameter set number entered\n\n')
    clear all; return
end

rand('state',sum(100*clock)); %initialise random number generator

%generic parameters
PARAMETERS.total_number_of_presentation_screens = PARAMETERS.number_of_blocks.*(PARAMETERS.trials_per_block+1);
PARAMETERS.fontname = 'Arial';     
PARAMETERS.fontsize = 12; 

%settings for gamble pies
PARAMETERS.gamble = skew_settings(settings);
