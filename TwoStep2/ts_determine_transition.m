function [ output_args ] = ts_determine_transition( trial_nr )
%TS_DETERMINE_TRANSITION Summary of this function goes here
%   Detailed explanation goes here

global params;

%determine if it will be a common or uncommon transition
random_number = (randi(101,1)-1)/100;
if random_number <= params.task.common_transition_prob %if common transition
    transition = 0; %common
elseif random_number > params.task.common_transition_prob
    transition = 1; %uncommon
else
    error('something wrong with determination of transition');
end

params.user.log(trial_nr,15) = transition;

switch transition
    case 0 %common
        if params.user.log(trial_nr,4) == 1 %if stimulus 1 was chosen in first stage
            params.user.log(trial_nr,6) = 1; %second stage pair 1 is the one associated with stimulus 1 with high prob
        elseif params.user.log(trial_nr,4) == 2 %if stimulus 2 was chosen in first stage
            params.user.log(trial_nr,6) = 2; %second stage pair 2 is the one associated with stimulus 2 with high prob
        else
            error('this code should not be ran if no stimulus was chosen in phase 1');
        end
    case 1 %uncommon
        if params.user.log(trial_nr,4) == 1 %if stimulus 1 was chosen in first stage
            params.user.log(trial_nr,6) = 2; %second stage pair 2 is the one associated with stimulus 1 with low prob
        elseif params.user.log(trial_nr,4) == 2 %if stimulus 2 was chosen in first stage
            params.user.log(trial_nr,6) = 1; %second stage pair 1 is the one associated with stimulus 2 with low prob
        else
            error('this code should not be ran if no stimulus was chosen in phase 1');
        end
end

end

