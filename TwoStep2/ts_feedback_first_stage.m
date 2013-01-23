function [ output_args ] = ts_feedback_first_stage( trial_nr )
%TS_FEEDBACK_FIRST_STAGE show feedback for first stage
% fade unchosen stimulus and move chosen stimulus to top



global params;

% quick loop to determine where the stimulus needs to stay, and if no
% button press was detected, show negative feedback
if params.user.log(trial_nr,2) == 1
    location = params.stimulus.location;
elseif params.user.log(trial_nr,2) == 2
    location = -params.stimulus.location;
else
    cgfont(params.text.font,params.text.font_size+20);
    cgpencol(params.text.color);
    cgtext('TOO LATE!',0,0);
    cgtext('NO MONEY EARNED',0,-100);
    cgflip(params.background);
    wait(params.trial.transition_duration);
    return
end

cgdrawsprite(103,0,params.stimulus.center_y);
cgdrawsprite(200 + params.user.log(trial_nr,2),0,params.stimulus.center_y);
cgflip(params.background);

wait(params.trial.transition_duration);

end

