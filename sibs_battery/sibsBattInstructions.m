function skip = sibsBattInstructions( param, debug)
% Show introductory instructions for the whole battery in cogent if debug==0,
% else display a short message.

% debug: param.taskNum = 7; debug = 0;
skip = -666; % initalized to invalid value.
cog_full_scr = 1; % Whether display is full-screen (1), windowed (0), 2nd screen (2) ...

if debug == 0 % Then display in cogent the instructions screen(s)
    if param.codeTesting ~= 0; cog_full_scr = 0; end; % windowed for debugging etc.
    config_display(cog_full_scr, 3, [0 0 0], [1 1 1], 'Helvetica', 30, 7, 0);   % writing in white
    % config_display(1, 3, [0 0 0], [0.5 0.99 0.99], 'Helvetica', 30, 7, 0); % ... or in Cyan
    config_keyboard;
    start_cogent;
  
    cgfont('Arial',20);   % Default font for this part
    clearpict(1);
    
    % Display different initial screen depending on whether we're just
    % starting, or resuming with the same participant by checking whether
    % log file already exists:
    batLogFileName = [param.data_dir,'\',param.ptCode,'_batteryLog.mat'];   
    if exist(batLogFileName)==0 % if we haven't started with this participant yet
    
      preparestring(['~~~~ 欢迎来到决策游戏! ~~~ '],1,0,240);
    
      preparestring(['你会玩一组 ',num2str(param.taskNum),' 个不同的游戏, 或者我们叫做任务.'],1,0,200);
      preparestring(['在每一个任务中你要做选择或决定. 我们试图找出'],1,0,180);
      preparestring(['如同您一样人们是如何做决定的, 因此您能尽最大努力来做最好的决定'],1,0,160);
      preparestring(['十分重要. 每个任务开始之前都会有指导语显示.'],1,0,140); 
      preparestring(['在某些游戏中 (我们会告诉你是哪些) 你会和一个同伴一起进行, 因为我们希望'],1,0,120);   
      preparestring(['研究与他人互动会如何影响人们做决定.'],1,0,100); 
    
      preparestring(['电脑会记录你的选择, 以及有多少是成功的'],1,0,60);   
      preparestring(['点数, 游戏币等等. 有些游戏是没有 "正确答案"的: 我们'],1,0,40);   
      preparestring(['更关心您的偏好. 在我们的电脑游戏里电脑并不会'],1,0,20);
      preparestring(['尝试 "赢过你" (除过 "躲避强盗" 游戏, 我们会清楚说明).'],1,0,0);   
      preparestring(['不过在很多游戏中运气是一个因素, 有点儿像掷骰子,'],1,0,-20);    
      preparestring(['从而决定您是输还是赢. 并且有些游戏会比其他的更难些;'],1,0,-40);
      preparestring(['所以不要担心是否每次都能赢, 只要尽力就行!'],1,0,-60);  
    
      preparestring(['每个游戏都不同, 但我们看每个好的决定一样好无论哪个游戏,'],1,0,-100);   
      preparestring(['所以尽力每次都做最好的决定. 在结束时我们会累加'],1,0,-120);     
      preparestring(['每个游戏的成绩, 并且计算真实的奖励金额.'],1,0,-140);   
  
      preparestring('祝好运! 按任意键开始.',1,0,-220);   % No choices given here!
      drawpict(1);
      waitkeydown(inf);  
      skip = 0;
      
    else % i.e. if the log file exist for this participant, which means they've already seen the very first
         % instruction screen :
      preparestring(['~~~~ 欢迎回到决策游戏! ~~~ '],1,0,60);
      preparestring(['让我们继续下一个游戏 ...'],1,0,20);   

      preparestring('按 回车 键重新开始未完的任务,',1,0,-40);   
      preparestring('(或者 ESCAPE 键如果你真的想要跳过一个未完的任务)',1,0,-60);   

      preparestring('祝好运!',1,0,-100);   
      drawpict(1);
      
      while (skip ~= 0 && skip ~= 1)
        [keyStroke,time,nkeyStrokes] = waitkeydown(inf);
        if keyStroke == keyCode('RETURN'); skip = 0; end;
        if keyStroke == keyCode('ESCAPE'); skip = 1; end;                
      end % while (skip ..  
         
    end  % Conditional on whether this is the very first time pt. starts battery ...
         
    stop_cogent;
else
    disp(['This is the debug line for overall battery instructions - you do not need more!']);
    skip = 0;
end

end

