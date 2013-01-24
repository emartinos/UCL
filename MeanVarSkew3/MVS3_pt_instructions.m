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
    preparestring(['~ 欢迎来到轮盘赌任务 ~ '],1,0,180);
    
    preparestring(['这里你要决定是否投注或者 '],1,0,140);
    preparestring(['选择确定金额. 在每一轮'],1,0,120);
    preparestring(['"确定数额" 会出现在屏幕左方, 轮盘'],1,0,100);
    preparestring(['在近中间的地方. 轮盘会划分为一些 "小饼" 有 '],1,0,80); 
    preparestring(['不同金额写在上面. 如果你选择投注且 '],1,0,60);   
    preparestring(['轮盘转动了, 小饼越大球就越容易'],1,0,40); 
    preparestring(['停在里面. 但电脑并不会每次都转动. 在固定的'],1,0,20);      
    preparestring(['间歇, 每若干轮, 电脑会随机选择一个并转动.'],1,0,0);   

    preparestring(['开始时轮盘出现, 你有若干秒可以做'],1,0,-40);
    preparestring(['决定. 然后一个小方块出现在轮盘正中:'],1,0,-60);   
    preparestring(['这时你必须立即按其中一个键记录你的选择.'],1,0,-80);    
    
 
    preparestring('祝好运! 按任意键开始.',1,0,-120);   
   
    drawpict(1);
    waitkeydown(inf);
    
    % stop_cogent; 
else
    disp('This is the debug line for the Mean-Variance-Skewness instructions - you do not need more!');
end

end

