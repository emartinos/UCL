function  GNGb0_target_practice ( InstScr, targetPracticeTrialN,  Discrim, ...
                            xloc1,xloc2,TargetDispT,trialsITI,LKey,RKey, ... 
                            subjNum, params ) 

 sessionType = 0; % This just denotes that we are in a training session.
                        
 preparestring('Practice in responding:', InstScr,0,275);
 if Discrim == 0 % for simple responding, without discrimination element
    preparestring('As soon as you see the circle',1,0,110);
    preparestring('press the key that is used for responding.',1,0,70);
    preparestring('If you do it on time you will get the message ''correct''; if ',1,0,30);
    preparestring('you don''t do it correctly, a message will tell you the reason',1,0,-10);
    preparestring('...Press a key to continue', InstScr,250,-275);

 else % if there is discrimination component to the task
    preparestring('As soon as you see the circle please indicate',1,0,110);
    preparestring('on which side it appears by pressing the correct key.',1,0,70);
    preparestring('If you do it correctly and on time you will get an OK message;',1,0,30);
    preparestring('if you fail a message will tell you the reason',1,0,-10);
    preparestring('...Press a key to continue', InstScr,250,-275);
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
 
 
