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
    preparestring(['~ ��ӭ�������̶����� ~ '],1,0,180);
    
    preparestring(['������Ҫ�����Ƿ�Ͷע���� '],1,0,140);
    preparestring(['ѡ��ȷ�����. ��ÿһ��'],1,0,120);
    preparestring(['"ȷ������" ���������Ļ��, ����'],1,0,100);
    preparestring(['�ڽ��м�ĵط�. ���̻Ữ��ΪһЩ "С��" �� '],1,0,80); 
    preparestring(['��ͬ���д������. �����ѡ��Ͷע�� '],1,0,60);   
    preparestring(['����ת����, С��Խ�����Խ����'],1,0,40); 
    preparestring(['ͣ������. �����Բ�����ÿ�ζ�ת��. �ڹ̶���'],1,0,20);      
    preparestring(['��Ъ, ÿ������, ���Ի����ѡ��һ����ת��.'],1,0,0);   

    preparestring(['��ʼʱ���̳���, ���������������'],1,0,-40);
    preparestring(['����. Ȼ��һ��С�����������������:'],1,0,-60);   
    preparestring(['��ʱ���������������һ������¼���ѡ��.'],1,0,-80);    
    
 
    preparestring('ף����! ���������ʼ.',1,0,-120);   
   
    drawpict(1);
    waitkeydown(inf);
    
    % stop_cogent; 
else
    disp('This is the debug line for the Mean-Variance-Skewness instructions - you do not need more!');
end

end

