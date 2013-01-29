function  outParams = updateSibsBattery(params, pointsWon, debug)
% Function called to augment the record of completed tasks by one,
% if not all done, pause battery execution and offer opportunity to 
% stop the battery (presumably to resume later).

c.fullscreen = 1; % set it to 0 for windowed display or to 1 for full screen.
c.screen_res = 3; % Cogent screen resolution: 1=640x480, 2=800x600, 3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200

outParams = params;
outParams.exp_flow = '0'; % nonchoice value - we need user to make active choice.
batLogFileName = [outParams.data_dir,'\',outParams.ptCode,'_batteryLog.mat'];
% outParams.exp_flow = 0; % Flag for 'next task' or 'break' etc. This can be changed by loop below, if all done!

%% First advance the number of tasks completed by one and record this:
if exist(batLogFileName)==0 
    error(['Attempt to update non-existent file ',batLogFileName]);
else
    load(batLogFileName);
    % The function may be called when all tasks have been done, so:
    if battery.TasksCompleted < outParams.taskNum
        battery.TasksCompleted = battery.TasksCompleted + 1;
        % Store the number of points earned in this task using the updated index:
        battery.score(battery.taskOrder(battery.TasksCompleted)) = pointsWon;
    end
    battery.earnings = outParams.fee; % this is a structure with all types of earnings.
    save(batLogFileName,'battery');
end

if battery.TasksCompleted == outParams.taskNum % if so, set flag to head for a swift exit !
   outParams.exp_flow = 'n'; 
end

if debug == 0  % use cogent
  clear global cogent; 
  % windowed display: config_display(0, ... or full screen: config_display(1, ...
  config_display(c.fullscreen, c.screen_res, [0 0 0], [1 1 1], 'Helvetica', 30, 7, 0);
  config_keyboard;
  start_cogent;
  cgfont('Arial',20);   % Default font for this part
end
  
%% Now wait for experimenter either to go on, or interrupt battery:
while outParams.exp_flow~= 'b' && outParams.exp_flow ~= 'n' 
    if debug ~= 0 % use command line
      outParams.exp_flow = input('\nEnter ''n'' for next stage or ''b'' to break (interrupt): ','s');
    else % use cogent
      cgfont('Arial',20);   % Default font for this part
      clearpict(1);
      preparestring(['** 请通知研究人员来检查是否一切正常. **'],1,0,40);
      preparestring(['研究员: 请按 "N" 到下一步'],1,0,0);
      preparestring(['或者 "B" 多休息一会儿 / 中断.'],1,0,-20);     
      drawpict(1);
      inputKey =  waitkeydown(inf);
      if inputKey == 2  outParams.exp_flow = 'b'; end
      if inputKey == 14 outParams.exp_flow = 'n'; end
    end
    if isempty(outParams.exp_flow) 
        outParams.exp_flow = '0';
    end
end

if debug == 0
  stop_cogent;
  clear global cogent;
end

% 'b' input aborts the whole script, which can of course be resumed at the
%  beginning of the next task to be done ...
if outParams.exp_flow == 'b'
    clear all;
    java.lang.Runtime.getRuntime.gc;
    error('Experimenter interruption; Battery state has been saved at last completed task');
end

end

