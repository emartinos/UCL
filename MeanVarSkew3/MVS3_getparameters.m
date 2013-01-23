function [PARAMETERS] = MVS3_getparameters(paramset)
% MVS3_getparameters2(paramset) sets the parameters for the mean-variance-skewness MVS3+,
% versions of the programs such as MVS3 etc.
% 
% Parameters for NSPN: Testing code / debugging : == 5
%                      behavioural:               == 6
%                      scanning:                  == 7

% Note that generic parameters are right at the bottom of this file.
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
    
elseif paramset== 2 %behavioural piloting, practice session 1

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
    
elseif paramset == 3 %behavioural piloting, real session 1
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
    
elseif paramset == 4 %behavioural piloting, real session 2
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
    
    
%     elseif paramset == 7 %behavioural piloting, practice session 2
%     %20 stimuli in practice block, feedback every 4 trials
%     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs
%     PARAMETERS.trials_per_block = 5;               %number of trials per block
%     PARAMETERS.number_of_blocks = 4;                %total number of blocks
%     PARAMETERS.sure_amounts = [30 50].*2;           %sureamounts - need to be a factor of num blocks
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
%     PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
%     PARAMETERS.run_numbers = 1;                     %just have 1 run for test
%     PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
%     settings = 2;
%     PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials./60000 + ...
%         (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks./60000 + ...
%         (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)./60000;

   
% elseif paramset == 6 %behavioural piloting, real session 3
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
    
elseif paramset == 5 % code testing / debugging  for NSPN version 1
    PARAMETERS.context = 1; % 1 for NSPN Dell Latitudes
    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs   
    PARAMETERS.TIMINGS.slice = 65;      % tr per slice time in ms
    PARAMETERS.NUM.slice = 48;          % number of slices per volume
    PARAMETERS.TIMINGS.tr = PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 30;     % mean jitter time is 0, 30, 60 slices

    PARAMETERS.trials_per_block = 2;  % number of trials per block.} 10 of these (x 4 blocks) give about 11 min
    PARAMETERS.number_of_blocks = 4;  % total number of blocks     }  excluding the reading of instructions.
    PARAMETERS.sure_amounts = [1.5 2.0 2.5 3.0];  % sureamounts - need to be a factor of num blocks. 
                                            % In this version expressed in pounds-like numbers
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 1000./PARAMETERS.TIMINGS.slice;  %  ISI duration  after fixation
        % after fixation cross appears to onset of stimulus; reduced from 2000 in original.
    PARAMETERS.TIMINGS.stimuluson = 5500/PARAMETERS.TIMINGS.slice;  %duration that stimulus is 
        % on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock2 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock3 = 0; % wait time for roulette animation text. Originally 2000.
    PARAMETERS.TIMINGS.endblock4 = 1500; % When roulette starts spinning, originally 2000
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 2000; % roulette animation spin duration. Originally 6000
    PARAMETERS.TIMINGS.surescreen = 3000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
    PARAMETERS.screen_resolution = 2;               % screen resolution for cogent. NSPN laptop max = 3.
    PARAMETERS.run_numbers = 1;                     %just have 1 run to start with.
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials+ ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen);
 
    %% Scanning specific, adapted from option 11: 
    jitterarr = [0 1 2]; % [1 2 3];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
   
    PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;
    
    PARAMETERS.NUM.dummy = 1;   % 1 dummy vol for this emulation version (48 pseudoslices)
    PARAMETERS.NUM.post = 0;    % 8 dummy volumes post for real scanning, set to 0 for behav. study.
    PARAMETERS.port=0; % Would be 'net' for emulscan originally -> changed to 1 for emulscan runs.    
    %%

elseif paramset == 6 % emulation-scanning for NSPN version 1
    PARAMETERS.context = 1; % 1 for NSPN Dell Latitudes
    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs   
    PARAMETERS.TIMINGS.slice = 65;      % tr per slice time in ms
    PARAMETERS.NUM.slice = 48;          % number of slices per volume
    PARAMETERS.TIMINGS.tr = PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 30;     % mean jitter time is 0, 30, 60 slices

    PARAMETERS.trials_per_block = 20; % number of trials per block.} 10 of these (x 4 blocks) give about 11 min
    PARAMETERS.number_of_blocks = 4;  % total number of blocks     }  excluding the reading of instructions.
    PARAMETERS.sure_amounts = [1.5 2.0 2.5 3.0];  % sureamounts - need to be a factor of num blocks. 
                                            % In this version expressed in pounds-like numbers
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 1000./PARAMETERS.TIMINGS.slice;  %  ISI duration  after fixation
        % after fixation cross appears to onset of stimulus; reduced from 2000 in original.
    PARAMETERS.TIMINGS.stimuluson = 5500/PARAMETERS.TIMINGS.slice;  %duration that stimulus is 
        % on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock2 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock3 = 0; % wait time for roulette animation text. Originally 2000.
    PARAMETERS.TIMINGS.endblock4 = 1500; % When roulette starts spinning, originally 2000
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 2000; % roulette animation spin duration. Originally 6000
    PARAMETERS.TIMINGS.surescreen = 3000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.screen_display = 1;                  %0 for small window, 1 for full screen
    PARAMETERS.screen_resolution = 2;               % screen resolution for cogent. NSPN laptop max = 3.
    PARAMETERS.run_numbers = 1;                     %just have 1 run to start with.
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials+ ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen);
 
    %% Scanning specific, adapted from option 11: 
    jitterarr = [0 1 2]; % [1 2 3];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
   
    PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;
    
    PARAMETERS.NUM.dummy = 1;   % 1 dummy vol for this emulation version (48 pseudoslices)
    PARAMETERS.NUM.post = 0;    % 8 dummy volumes post for real scanning, set to 0 for behav. study.
    PARAMETERS.port=0; % Would be 'net' for emulscan originally -> changed to 1 for emulscan runs.    
    %%
    
    
elseif paramset == 7 %scanning-like for NSPN version 1
    PARAMETERS.context = 2; % 2 for scanner ???
    % 180 stimuli in practice block, feedback every 10 trials

    %     PARAMETERS.run_numbers  =  input('\nWhich run(s) would you like to use in this session?\n\n>>'); %runs   
    PARAMETERS.TIMINGS.slice = 65;      % tr per slice time in ms
    PARAMETERS.NUM.slice = 48;          % number of slices per volume
    PARAMETERS.TIMINGS.tr = PARAMETERS.NUM.slice * PARAMETERS.TIMINGS.slice;   %TR =3120ms per volume
    PARAMETERS.TIMINGS.jitter = 30;     % mean jitter time is 0, 30, 60 slices

    PARAMETERS.trials_per_block = 25;    % number of trials per block
    PARAMETERS.number_of_blocks = 4;    % total number of blocks
    PARAMETERS.sure_amounts = [1.5 2.0 2.5 3.0];  % sureamounts - need to be a factor of num blocks. 
                                            % In this version expressed in pounds-like numbers
    PARAMETERS.cue_on = 1;                          %use cue or not
    PARAMETERS.TIMINGS.ISI = 1000./PARAMETERS.TIMINGS.slice;  %  ISI duration  after fixation
        % after fixation cross appears to onset of stimulus; reduced from 2000 in original.
    PARAMETERS.TIMINGS.stimuluson = 5500/PARAMETERS.TIMINGS.slice;  %duration that stimulus is 
        % on screen for before cue on
    PARAMETERS.TIMINGS.cuetime = 2000;               %response cue on time
    PARAMETERS.TIMINGS.endblock1 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock2 = 2000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.TIMINGS.endblock3 = 0; % wait time for roulette animation text. Originally 2000.
    PARAMETERS.TIMINGS.endblock4 = 1500; % When roulette starts spinning, originally 2000
    PARAMETERS.TIMINGS.endblock5 = 4000;
    PARAMETERS.TIMINGS.T_end = 2000; % roulette animation spin duration. Originally 6000
    PARAMETERS.TIMINGS.surescreen = 3000/PARAMETERS.TIMINGS.slice;
    PARAMETERS.screen_display = 0;                  %0 for small window, 1 for full screen
    PARAMETERS.run_numbers = 1;                     %just have 1 run to start with.
    PARAMETERS.number_of_trials = PARAMETERS.number_of_blocks*PARAMETERS.trials_per_block;
    settings = 2;
    PARAMETERS.estimatedtotaltime = (PARAMETERS.TIMINGS.ISI+PARAMETERS.TIMINGS.stimuluson +PARAMETERS.TIMINGS.cuetime)*PARAMETERS.number_of_trials+ ...
        (PARAMETERS.TIMINGS.endblock1 +  PARAMETERS.TIMINGS.endblock2 + PARAMETERS.TIMINGS.endblock3 +  PARAMETERS.TIMINGS.endblock4 + PARAMETERS.TIMINGS.endblock5)*PARAMETERS.number_of_blocks + ...
        (PARAMETERS.number_of_blocks*PARAMETERS.TIMINGS.surescreen)
 
    %% Scanning specific, adapted from option 11: 
    jitterarr = [0 1 2]; % [1 2 3];
    PARAMETERS.numberofscreens = (PARAMETERS.number_of_blocks*(PARAMETERS.trials_per_block+1));
    for k = 1:PARAMETERS.numberofscreens./length(jitterarr)
        jitterarr = [jitterarr, jitterarr(randperm(3))];
    end
   
    PARAMETERS.TIMINGS.JITTERtimes = PARAMETERS.TIMINGS.jitter.*jitterarr;
    
    PARAMETERS.NUM.dummy = 6;   % 6 dummy volumes initially ( = 6*48 slices)
    PARAMETERS.NUM.post = 8;    % 8 dummy volumes post
    PARAMETERS.port=1; % Assume scanner is connected to serial port 1
 
   elseif paramset == 10 %scanning run 2 - testing in Allegra 1
    
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
    
elseif paramset == 11 %scanning run 3 - testing in Allegra 2
    
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

%% %%%%%%%%%%%%%%%%%%% generic parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%
PARAMETERS.total_number_of_presentation_screens = PARAMETERS.number_of_blocks.*(PARAMETERS.trials_per_block+1);
PARAMETERS.fontname = 'Arial';     
PARAMETERS.fontsize = 12; 
PARAMETERS.NullValue = -999; % A value to indicate 'no meaningful data at this point',
                             % e.g. no choice made, no roulette played so no roulette angle exists etc. 
PARAMETERS.MistakeCode = -991; % A value to indicate wrong key pressed etc.

%settings for gamble pies
PARAMETERS.gamble = skew_settings(settings);
