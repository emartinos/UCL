function [ output_args ] = ts_test( input_args )
%TS_TEST Summary of this function goes here
%   Detailed explanation goes here

%% change a number of variables
% this is to allow the same scripts to run, but using different
% stimuli/probabilities.

% color, probabilities, stimuli

global params;

params.stimulus.colors_prac = params.stimulus.colors(1:2,:);
params.stimulus.colors = params.stimulus.colors(3:4,:);

params.task.probabilities_prac = params.task.probabilities(1:4,:);
params.task.probabilities = params.task.probabilities(5:8,:);

params.stimuli_prac = params.stimuli(1:6,:);
params.stimuli = params.stimuli(7:12,:);


for i = 1:params.task.test.number_of_trials
% for i = 1
    
    %show break?
    if mod(i,params.task.break.frequency) == 0 %if it's time for a break
        ts_break
    end


    params.user.log(i,1)     = i;
    %% show ITI
    iti = ts_iti(params.task.iti);
    params.user.log(i,9) = iti;
    %% show stage 1
    
    %the function logs stimulus presentation and response
    ts_single_trial_first_stage(i);
    
    %% show feedback for 1st choice
    ts_feedback_first_stage(i);
    
    if params.user.log(i,2) ~= 0
    %% determine the transition
    ts_determine_transition(i);
    
    %% show stage 2
    ts_single_trial_second_stage(i);
    
    %% determine and show feedback
    ts_feedback_second_stage(i);
    
    else
        params.user.log(i,[3 4 5 6 7 8 10 13 14 15]) = NaN;
    end
    
    
end


end

