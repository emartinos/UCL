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
    
      preparestring(['~~~~ Welcome to the Decision Games! ~~~ '],1,0,240);
    
      preparestring(['You will play a set of ',num2str(param.taskNum),' different games, or tasks as we call them.'],1,0,200);
      preparestring(['In each task you will have to make choices and decisions. We are trying to find out how'],1,0,180);
      preparestring(['people like yourself make decisions, so it is important that you try to make the best'],1,0,160);
      preparestring(['possible decisions. Instructions about how to play in each task will appear before it starts.'],1,0,140); 
      preparestring(['In some games (we''ll tell you which) you may play with a partner, because we want to'],1,0,120);   
      preparestring(['study how interacting with somebody else affects the way people make decisions.'],1,0,100); 
    
      preparestring(['The computer will keep a record of your choices, and how many of them were successful'],1,0,60);   
      preparestring(['in winning points, play-money etc. In some games there is no "right answers": we are'],1,0,40);   
      preparestring(['more interested in your own preferences. In our computer games the computer will not'],1,0,20);
      preparestring(['try to "beat you" (except in the "Dodge the robber" game, when we will make it very clear).'],1,0,0);   
      preparestring(['However there is an element of chance in several games, a bit like rolling a dice,'],1,0,-20);    
      preparestring(['which affects whether you win or not. Also some games are more difficult than others;'],1,0,-40);
      preparestring(['so do not worry if you do not win every time, as long as you try your best!'],1,0,-60);  
    
      preparestring(['Each game is very different, but we count each good decision the same in every game,'],1,0,-100);   
      preparestring(['so please try to make the best decisions every time. In the end we will add up how'],1,0,-120);     
      preparestring(['well you did in each game, and we will calculate a payment for you in real money.'],1,0,-140);   
  
      preparestring('Good luck! Press any key to start.',1,0,-220);   % No choices given here!
      drawpict(1);
      waitkeydown(inf);  
      skip = 0;
      
    else % i.e. if the log file exist for this participant, which means they've already seen the very first
         % instruction screen :
      preparestring(['~~~~ Welcome back to the Decision Games! ~~~ '],1,0,60);
      preparestring(['Let''s continue with the next game ...'],1,0,20);   

      preparestring('Press the RETURN key to restart where you left off,',1,0,-40);   
      preparestring('(or the ESCAPE key if you really need to skip a partially-done task)',1,0,-60);   

      preparestring('Good Luck!',1,0,-100);   
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

