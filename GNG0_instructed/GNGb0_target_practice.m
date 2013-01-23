function  GNGb0_target_practice ( InstScr, targetPracticeTrialN,  Discrim, ...
                            xloc1,xloc2,TargetDispT,trialsITI,LKey,RKey, ... 
                            subjNum, params ) 

 sessionType = 0; % This just denotes that we are in a training session.
                        
 preparestring('��ϰ��Ӧ:', InstScr,0,275);
 if Discrim == 0 % for simple responding, without discrimination element
    preparestring('����ԲȦ֮������',1,0,110);
    preparestring('����Ӧ��.',1,0,70);
    preparestring('���������Чʱ���ڻῴ�� ''��ȷ''; ��� ',1,0,30);
    preparestring('��û������, ������Ϣ������ԭ��',1,0,-10);
    preparestring('...�����������', InstScr,250,-275);

 else % if there is discrimination component to the task
    preparestring('����ԲȦ֮����������ʾ��',1,0,110);
    preparestring('���ı߳���.',1,0,70);
    preparestring('����㼰ʱ��ȷ��õ�һ����ȷ��Ϣ;',1,0,30);
    preparestring('�����ʧ�ܻ���һ����Ϣ������ԭ��',1,0,-10);
    preparestring('...�����������', InstScr,250,-275);
    drawpict(InstScr);
    waitkeydown(inf);
    clearpict(InstScr);
 end 
 drawpict(InstScr);
 waitkeydown(inf);
 clearpict(InstScr);    
 wait(1000); % Make sure target circle isn't displayed immediately!
 for count=1:targetPracticeTrialN
    ITI_tr=trialsITI(count);
    [data] = GNGb0_screen_display (0,0,1,xloc1,xloc2,TargetDispT,ITI_tr,LKey,RKey);
    PracticeData(count,:)=data;
 end
 
 fName = [params.data_dir,'\',params.subj_name,'_GNGb0_TargetPract_',datestr(now,'yyyy-mm-dd_HH_MM')];
 save(fName ,'PracticeData');
 fName = [params.subj_name,'_GNGb0_workspace_',num2str(sessionType),'_',datestr(now,'yyyy-mm-dd_HH_MM')]; 
 whereWeWere = pwd;
 cd(params.data_dir);
 eval( ['save ' fName ] );
 cd(whereWeWere);
 
 
