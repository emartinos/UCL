function [ output_args ] = ts_feedback_second_stage( trial_nr )
%TS_FEEDBACK_FIRST_STAGE show feedback for first stage
% fade unchosen stimulus and move chosen stimulus to top



global params;

if params.user.log(trial_nr,3) == 0
    cgfont(params.text.font,params.text.font_size+20);
    cgpencol(params.text.color);
    cgtext('TOO LATE!',0,0);
    cgtext('NO MONEY EARNED',0,-100);
    cgflip(params.background);
    wait(params.trial.reward_duration);
    return
end

% quick loop to determine where the stimulus needs to stay, and if no
% button press was detected, show negative feedback
random_number = (randi(101,1)-1)/100;

if random_number <= params.task.probabilities(params.user.log(trial_nr,5)-2,trial_nr) %if the random number is smaller than the probability of reward (i.e. subject should get reward)
    params.user.log(trial_nr,10) = 1;
elseif random_number > params.task.probabilities(params.user.log(trial_nr,5)-2,trial_nr) %subject should not get reward
    params.user.log(trial_nr,10) = 0;
else
    error('something went wrong')
end


%% remove stimulus that was not chosen, only show chosen stimulus for 500ms or so

% if params.user.log(trial_nr,3) == 1 %if left choice
%     cgdrawsprite(110,-params.stimulus.location,params.stimulus.side_y); %left
%     cgdrawsprite(203,-params.stimulus.location,params.stimulus.side_y);
% elseif params.user.log(trial_nr,3) == 2 %if right choice
%     cgdrawsprite(110,params.stimulus.location,params.stimulus.side_y); %right
%     cgdrawsprite(204,params.stimulus.location,params.stimulus.side_y);
% end
% cgflip(params.background)
% wait(500)

%now draw in reward as well
if params.user.log(trial_nr,3) == 1 %if left choice
    cgdrawsprite(110,-params.stimulus.location,params.stimulus.side_y); %left
    cgdrawsprite(203,-params.stimulus.location,params.stimulus.side_y);
elseif params.user.log(trial_nr,3) == 2 %if right choice
    cgdrawsprite(110,params.stimulus.location,params.stimulus.side_y); %right
    cgdrawsprite(204,params.stimulus.location,params.stimulus.side_y);
end

if params.user.log(trial_nr,10) == 1
    cgdrawsprite(401,0,params.stimulus.side_y); %draw pound sign, in case of reward
elseif params.user.log(trial_nr,10) == 0
    cgpencol(1,0,0);
    cgfont(params.text.font,100);
    cgtext('X',0,params.stimulus.side_y);
end

cgflip(params.background);

wait(params.trial.reward_duration);

end

