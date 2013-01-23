function [ output_args ] = ts_single_trial_second_stage( trial_nr )
%TS_SINGLE_TRIAL_SECOND_STAGE Summary of this function goes here
%   Detailed explanation goes here


global params

cd stimuli

%draw center stimulus (the one chosen from phase 1)
cgdrawsprite(103,0,params.stimulus.center_y);
cgdrawsprite(200 + params.user.log(trial_nr,2),0,params.stimulus.center_y);

%params.stimulus.colors has 4 rows. First two are for the practice phase. 
cgmakesprite(110,params.stimulus.box_size,params.stimulus.box_size,params.stimulus.colors(params.user.log(trial_nr,6),:)); %color
cgdrawsprite(110,-params.stimulus.location,params.stimulus.side_y); %left
cgdrawsprite(110,params.stimulus.location,params.stimulus.side_y); %right

stimulus_order = randperm(2)+2*params.user.log(trial_nr,6); %crucial bit where the right stimuli are selected (column 6 denotes what pair is currently shown)
temp_stimuli = params.stimuli(stimulus_order,:); %shuffles the two stimuli about to be presented around

cgloadbmp(203,temp_stimuli(1,:),params.stimulus.char_size, params.stimulus.char_size); %stimulus that happens to be left this trial
cgloadbmp(204,temp_stimuli(2,:), params.stimulus.char_size, params.stimulus.char_size); %stimulus that happens to be right this trial

cgdrawsprite(203,-params.stimulus.location,params.stimulus.side_y);
cgdrawsprite(204,params.stimulus.location,params.stimulus.side_y);

cgsetsprite(0);


cgflip(params.background)
t = time;           %start timer
ks=zeros(255,1);
too_late = 0;
cgkeymap; %clear keymap

while ~(ks(params.keys.left)) && ~(ks(params.keys.right)) %wait for keypress
   [ks] = cgkeymap;
   
   if time - t > params.trial.response_deadline
       too_late = 1;
       break;
    
   end
end

if too_late == 0 %if subject was on time
    rt = time - t;
    ks([1:74 76 78:255]) = 0;
    key = find(ks,1);
elseif too_late == 1 %if subject was too late
    rt = 0;
    key = 0;
end




params.user.log(trial_nr,8)     = rt;
if key == params.keys.left
    params.user.log(trial_nr,3) = 1;
    params.user.log(trial_nr,5) = stimulus_order(1);    
elseif key == params.keys.right
    params.user.log(trial_nr,3) = 2;
    params.user.log(trial_nr,5) = stimulus_order(2);   
elseif key == 0
    params.user.log(trial_nr,3) = 0;
    params.user.log(trial_nr,5) = 0;
end

params.user.log(trial_nr,13:14) = stimulus_order; %for second phase, this needs to be adjusted (second phase stimuli are 3,4,5,6 rather than 1,2)

cd ..
end

