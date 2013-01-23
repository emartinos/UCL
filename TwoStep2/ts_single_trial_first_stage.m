function [ output_args ] = ts_single_trial_first_stage( trial_nr )
%TS_SINGLE_TRIAL_FIRST_STAGE Summary of this function goes here


global params;
cd('stimuli');

stimulus_order = randperm(2);
temp_stimuli = params.stimuli(stimulus_order,:); %shuffles the two stimuli about to be presented around

%% make two sprites containing colours only, then draw stimuli into them

cgmakesprite(103,params.stimulus.box_size,params.stimulus.box_size,params.stimulus.first_phase_color); %color
cgdrawsprite(103,-params.stimulus.location,params.stimulus.side_y); %left
cgdrawsprite(103,params.stimulus.location,params.stimulus.side_y); %right

cgloadbmp(201,temp_stimuli(1,:),params.stimulus.char_size, params.stimulus.char_size); %stimulus that happens to be left this trial
cgloadbmp(202,temp_stimuli(2,:), params.stimulus.char_size, params.stimulus.char_size); %stimulus that happens to be right this trial

cgdrawsprite(201,-params.stimulus.location,params.stimulus.side_y);
cgdrawsprite(202,params.stimulus.location,params.stimulus.side_y);

cgsetsprite(0);

cgflip(params.background);

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
    rt = NaN;
    key = 0;
end




params.user.log(trial_nr,7)     = rt;
if key == params.keys.left
    params.user.log(trial_nr,2) = 1;
    params.user.log(trial_nr,4) = stimulus_order(1);
elseif key == params.keys.right
    params.user.log(trial_nr,2) = 2;
    params.user.log(trial_nr,4) = stimulus_order(2);
elseif key == 0
    params.user.log(trial_nr,2) = 0;
end

params.user.log(trial_nr,11:12) = stimulus_order; %for second phase, this needs to be adjusted (second phase stimuli are 3,4,5,6 rather than 1,2)

cd ..


end

