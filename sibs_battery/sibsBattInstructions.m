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
    
      preparestring(['~~~~ ��ӭ����������Ϸ! ~~~ '],1,0,240);
    
      preparestring(['�����һ�� ',num2str(param.taskNum),' ����ͬ����Ϸ, �������ǽ�������.'],1,0,200);
      preparestring(['��ÿһ����������Ҫ��ѡ������. ������ͼ�ҳ�'],1,0,180);
      preparestring(['��ͬ��һ�������������������, ������ܾ����Ŭ��������õľ���'],1,0,160);
      preparestring(['ʮ����Ҫ. ÿ������ʼ֮ǰ������ָ������ʾ.'],1,0,140); 
      preparestring(['��ĳЩ��Ϸ�� (���ǻ����������Щ) ����һ��ͬ��һ�����, ��Ϊ����ϣ��'],1,0,120);   
      preparestring(['�о������˻��������Ӱ������������.'],1,0,100); 
    
      preparestring(['���Ի��¼���ѡ��, �Լ��ж����ǳɹ���'],1,0,60);   
      preparestring(['����, ��Ϸ�ҵȵ�. ��Щ��Ϸ��û�� "��ȷ��"��: ����'],1,0,40);   
      preparestring(['����������ƫ��. �����ǵĵ�����Ϸ����Բ�����'],1,0,20);
      preparestring(['���� "Ӯ����" (���� "���ǿ��" ��Ϸ, ���ǻ����˵��).'],1,0,0);   
      preparestring(['�����ںܶ���Ϸ��������һ������, �е����������,'],1,0,-20);    
      preparestring(['�Ӷ����������仹��Ӯ. ������Щ��Ϸ��������ĸ���Щ;'],1,0,-40);
      preparestring(['���Բ�Ҫ�����Ƿ�ÿ�ζ���Ӯ, ֻҪ��������!'],1,0,-60);  
    
      preparestring(['ÿ����Ϸ����ͬ, �����ǿ�ÿ���õľ���һ���������ĸ���Ϸ,'],1,0,-100);   
      preparestring(['���Ծ���ÿ�ζ�����õľ���. �ڽ���ʱ���ǻ��ۼ�'],1,0,-120);     
      preparestring(['ÿ����Ϸ�ĳɼ�, ���Ҽ�����ʵ�Ľ������.'],1,0,-140);   
  
      preparestring('ף����! ���������ʼ.',1,0,-220);   % No choices given here!
      drawpict(1);
      waitkeydown(inf);  
      skip = 0;
      
    else % i.e. if the log file exist for this participant, which means they've already seen the very first
         % instruction screen :
      preparestring(['~~~~ ��ӭ�ص�������Ϸ! ~~~ '],1,0,60);
      preparestring(['�����Ǽ�����һ����Ϸ ...'],1,0,20);   

      preparestring('�� �س� �����¿�ʼδ�������,',1,0,-40);   
      preparestring('(���� ESCAPE ������������Ҫ����һ��δ�������)',1,0,-60);   

      preparestring('ף����!',1,0,-100);   
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

