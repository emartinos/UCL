function TST_initialize(dataDir, code, TS_dir,debug)
% TS_INITIALIZE(dataDir, code, TS_dir) is the NSPN version of ts_initialize.
% 'dataDir' is the directory to store data in this part of the battery.
% 'code' is a string with the participant's code ID.

global params;

cd(dataDir);
temp_wd = pwd;
% check if current working directory is the right one
% if strcmp(temp_wd(end-8:end),'\TwoStep2') ~= 1
%     error('please change working directory to \\ABBA\...\TwoStep2')
% end


%% trial parameters
params.background = [0 0 0];

params.trial.response_deadline = 2000;
params.trial.reward_duration = 2000;       % was 2000 in v20121209
params.trial.transition_duration = 750;    % was 1500 in v20121209

params.stimulus.box_size = 300;
params.stimulus.char_size = 230;
params.stimulus.reward_size = 150;

params.stimulus.colors = [1 1 1;  0.8 0.8 0.8;  0.3 0.3 0.3;  0.1 0.1 0.1];
% was: params.stimulus.colors = [1 0 0;0 1 0;1 0 1;0 1 1];
ix = randperm(4);
params.stimulus.colors = params.stimulus.colors(ix,:); %. Color of second phase stimuli.after practice phase, first two rows are chopped off. This way, same scripts can be used (single_trial.*. etc)
params.stimulus.colors_prac = [];
params.stimulus.first_phase_color = [0.6 0.6 0.6];
% was: params.stimulus.first_phase_color = [0.3 0.3 0.3];
params.stimuli_prac = [];
params.stimulus.location = 300;
params.stimulus.center_y = 200;
params.stimulus.side_y = -130;
params.stimulus.move_speed = 25; 


params.user.initials = 'Withheld'; % only code visible for NSPN. Originally: input('Subject initials: ','s'); %just a control to make sure subject number is correct, can be compared to subject list
params.user.number = code;  % originally: str2num(input('Subject number: ','s')); %this will be used for logging
params.user.session = 1; % only one session per battery for NSPN. Originally: str2num(input('Session number: ','s')); 
order = [mod(params.user.number,2)+1 2-mod(params.user.number,2)];
params.user.version = order(params.user.session);
% params.user.initials = 'PBS';
% params.user.number = 1;

params.user.date = int64(dot(clock,[10^10,10^8,10^6,10^4,10^2,1])); % YYYYMMDDHHMMSS date,
     % originally str2num(input('date (yyyymmdd): ','s'));
params.user.log = []; %holding place for logfiles. See end of this file for overview of log columns
params.user.prac_cash = 0; %how much cash the user has saved up, in points
params.user.exp_cash = 0; %in points
params.user.colours = []; %here colour scheme for this user will be held

params.task.probabilities = [];
params.task.probabilities_prac = [];
params.task.lower_boundary = 0; % nathaniel used 0.25
params.task.upper_boundary = 1; % nathaniel used 0.75
params.task.common_transition_prob = 0.7; %nathaniel used 0.7

params.task.prac.number_of_trials = 30; %nathaniel & Peter S had 50 (outside scanner); 2 for debug.
params.task.test.number_of_trials = 69; % %nathaniel & Peter S had 201 (in scanner); 5 for debug.
if debug ~= 0
   params.task.prac.number_of_trials = 2; % for code debug.
   params.task.test.number_of_trials =  10;
end    

params.task.iti = [1 3];
params.task.conversion_rate = 1.0; % 1/4; was Peter's, but in NSPN we'll
                 % perform conversion to real money outside this program.

% After the following number of trials, give a break:
params.task.break.frequency = params.task.test.number_of_trials./2+1 ; % 68; % Nathaniel had 67 
% params.task.break.frequency = 3;
params.task.break.duration = 1; % was 30

params.text.font_size = 20;
params.text.font = 'Helvetica';
params.text.color = [1 1 1];

params.resolution = [1024 768];
% params.display_type = 1; %1 fullscreen, 0 windowed
params.display_type = 1; % set to 0 for debug if needed below. 
if debug ~=0; params.display_type = 0; end;

params.keys.left = 75;
params.keys.right = 77;


%% Stimulus randomization
for i = 1:12; params.stimuli{i} = ['f' num2str(i) '.bmp']; end
ix = randperm(12); 
params.stimuli = params.stimuli(ix);
params.stimuli = char(params.stimuli);

%% create the random walks of the probabilities

%first create starting points. These are determined over a uniform
%distribution ranging between params.task.lower_boundary and
%params.task.upper_boundary

% %prac
% for i = 1:8
% params.task.probabilities(i,1) = (randi(params.task.upper_boundary*100 - params.task.lower_boundary*100 + 1,1) + params.task.lower_boundary*100 - 1) / 100;
% end
% 
% %fill practice phase
% for i = 2:params.task.prac.number_of_trials %for every trial
%     for j = 1:4 %for every stimulus in prac phase
%         params.task.probabilities(j,i) = params.task.probabilities(j,i-1) + 0.025*randn;
%         if params.task.probabilities(j,i) > params.task.upper_boundary params.task.probabilities(j,i) = params.task.upper_boundary; elseif params.task.probabilities(j,i) < params.task.lower_boundary params.task.probabilities(j,i) = params.task.lower_boundary; end
%     end
% end
% 
% %fill test phase
% for i = 2:params.task.test.number_of_trials %for every trial
%     for j = 5:8 %for every stimulus in prac phase
%         params.task.probabilities(j,i) = params.task.probabilities(j,i-1) + 0.025*randn;
%         if params.task.probabilities(j,i) > params.task.upper_boundary params.task.probabilities(j,i) = params.task.upper_boundary; elseif params.task.probabilities(j,i) < params.task.lower_boundary params.task.probabilities(j,i) = params.task.lower_boundary; end
%     end
% end

if params.user.version == 1
    load('stimuli\list1.mat')
elseif params.user.version == 2
    load('stimuli\list2.mat')
end
params.task.probabilities = x;



%% create subject folder:
saveFDir = dataDir; % was: [dataDir,'\TS_log\',num2str(params.user.number)];
% if exist(saveFDir,'dir') ~= 7; mkdir(saveFDir); end

%% start cogent
clear global cogent; % to ensure clean start.

cgloadlib;
cgopen(params.resolution(1),params.resolution(2),32,0,params.display_type); 

%% load reward sprite

% cd('stimuli');
stimFName = [TS_dir,'\stimuli\r1.bmp'];
cgloadbmp(401,stimFName,params.stimulus.reward_size, params.stimulus.reward_size);
%cgloadbmp(401,'r1.bmp',params.stimulus.reward_size, params.stimulus.reward_size);
cd(TS_dir);




end



