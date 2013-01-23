function MVS3_pt_instructions( param, debug)
% Show introductory instructions for the MVS3 program in cogent if debug==0,
% else display a short message.

% debug: param.taskNum = 7; debug = 0;

if debug == 0 % Then display in cogent the instructions screen(s)
              % We assume cogent has been started by main function ...
    % windowed display: config_display(0, ... or full screen: config_display(1, ...
    %config_display(param.screen_display, param.screen_resolution, [0 0 0], [0.5 0.99 0.99], 'Helvetica', 30, 7, 0);
    %config_keyboard;
    %start_cogent;
  
    cgfont('Arial',20);   % Default font for this part
    clearpict(1);
    preparestring(['~ Welcome to the Roulette tasks ~ '],1,0,180);
    
    preparestring(['Here you will have to decide whether to gamble on a roulette or '],1,0,140);
    preparestring(['to choose a known amount of play-money. At each round of the task the'],1,0,120);
    preparestring(['"sure amount" will appear on the left side of the screen, and the roulette'],1,0,100);
    preparestring(['near the middle. The roulette will be divided into a few "pie pieces" with '],1,0,80); 
    preparestring(['different amounts of play money written on them. If you choose to gamble and the '],1,0,60);   
    preparestring(['roulette is played, the bigger a piece the more likely that the ball will'],1,0,40); 
    preparestring(['end up in it. However the computer will not play all the rounds. At regular'],1,0,20);      
    preparestring(['intervals, every few rounds, the computer will choose one at random and play it.'],1,0,0);   

    preparestring(['Initially the roulette will appear, and you will have a few seconds to make up'],1,0,-40);
    preparestring(['your mind. Then a little square will appear in the middle of the roulette:'],1,0,-60);   
    preparestring(['This means you must quickly press one of the decision keys to register your choice.'],1,0,-80);    
    
 
    preparestring('Good luck! Press any key to start.',1,0,-120);   
   
    drawpict(1);
    waitkeydown(inf);
    
    % stop_cogent; 
else
    disp('This is the debug line for the Mean-Variance-Skewness instructions - you do not need more!');
end

end

