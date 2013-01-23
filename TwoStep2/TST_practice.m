function TST_practice(dataDir, ptCode, TS_dir)
%TS_PRACTICE go through practice trials
% data is not logged
%% Columns in the log file
% 
% 1. trial number
% 2. first stage keypress (0 means too late)
% 3. second stage keypress
% 4. first stage stimulus chosen
% 5. second stage stimulus chosen
% 6. second stage pair shown
% 7. rt first stage (NaN means too late, 0 means they had the key pressed
% down)
% 8. rt second stage
% 9. ITI going into this trial
% 10. reward received
% 11. 1st phase, stimulus left
% 12. 1st phase, stimulus right
% 13. 2nd phase, stimulus left
% 14. 2nd phase, stimulus right
% 15. common (0) or uncommon (1) transition
%%
global params;

for i = 1:params.task.prac.number_of_trials
% for i = 1
    tic
    
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
    
    toc
end


%% save practice data
fName = [dataDir,ptCode,'_pracTST_',datestr(now,'yyyy-mm-dd_HH_MM'),'.mat'];
save(fName,'params');
cd(TS_dir);

params.user.log = [];

end

