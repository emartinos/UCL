function  GNGb0_target_practice ( InstScr, targetPracticeTrialN,  Discrim, ...
                            xloc1,xloc2,TargetDispT,trialsITI,LKey,RKey, ... 
                            subjNum, params ) 

 sessionType = 0; % This just denotes that we are in a training session.
                        
 preparestring('练习回应:', InstScr,0,275);
 if Discrim == 0 % for simple responding, without discrimination element
    preparestring('看到圆圈之后立即',1,0,110);
    preparestring('按回应键.',1,0,70);
    preparestring('如果你在有效时间内会看到 ''正确''; 如果 ',1,0,30);
    preparestring('你没有作对, 会有信息告诉你原因',1,0,-10);
    preparestring('...按任意键继续', InstScr,250,-275);

 else % if there is discrimination component to the task
    preparestring('看到圆圈之后立即按键示意',1,0,110);
    preparestring('在哪边出现.',1,0,70);
    preparestring('如果你及时正确会得到一个正确信息;',1,0,30);
    preparestring('如果你失败会有一个信息告诉你原因',1,0,-10);
    preparestring('...按任意键继续', InstScr,250,-275);
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
 
 
