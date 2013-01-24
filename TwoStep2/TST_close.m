function fractionWon = TST_close( dataDir, ptCode )
%  function fractionWon = TST_close( dataDir, ptCode )
%  This calculates summary measures for the TwoStepTask in its NSPN incarnations.
%  It returnt the fraction of 'win' trials over the grand total
%  It also clears the globals (cogent etc. 

global params

% Summary measures incl. what will be shown to pt. :
params.user.trDone = size(params.user.log, 1); % 
params.user.playMoneyEarned = 0.0; % -85*params.task.conversion_rate;  % -85*... was Peter S's offset
for trNum=1:params.user.trDone
  if ~isnan(params.user.log(trNum,10))
    params.user.playMoneyEarned = params.user.playMoneyEarned + ...
        params.user.log(trNum,10) * params.task.conversion_rate ;
  end
end
% coins won as fraction of total trials, to return by fn. for further processing:
fractionWon = params.user.playMoneyEarned / params.task.test.number_of_trials ;
fName = [dataDir,ptCode,'_TST_',datestr(now,'yyyy-mm-dd_HH_MM'),'.mat'];
save(fName,'params');

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

cgtext('任务结束. 谢谢参与!',0,0);
cgflip(params.background);
wait(5000);

%% Shut down game window, display winnings on command line and 
%  clear the globals 'cogent' and 'params' used in TST
cgshut
clear global cogent;

disp(['Play pounds earned: ',num2str(params.user.playMoneyEarned),' out of ', ...
    num2str(params.task.test.number_of_trials), ' trials.']);
% disp((sum(params.user.log(:,10))-85)*params.task.conversion_rate);

clear global params
end

