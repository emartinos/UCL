function  [data] = GNGb0_task_display_training (TrialCue, Time2Target, Sham, ...
                                          xlocation1, xlocation2, TargetDisplayTime, ...
                                          ITI, RandCSs, scr, LeftKey, RightKey)

% - - Constants - - 
global c;   % c.* are various constants, whose values are set during initialization only.
% - - - - - - - - - 

if rand<=0.5
    TargetPosition=xlocation1;
else
    TargetPosition=xlocation2;
end

P=1; if rand > c.Psuccess P=0; end
% Originally was, for 70% chance of success if correct response:
% Pmat = [ones(1,7),2,2,2]; Pmat = Pmat(randperm(10)); P = Pmat(1);

clearkeys;
clearpict(2);
preparepict(loadpict(RandCSs{TrialCue}),2);
if scr==1
    outportb(888,255);
    wait(10);
    outportb(888,0);
end
TimeCue=drawpict(2);
wait(1000);

readkeys;
logkeys;
[KeyResp, KeyTime, n]=getkeydown;

if n~=0
    clearpict(3);
    cgscale(60);
    cgfont('Arial',2);
    preparestring('You pressed the key too early',3);
    drawpict(3);
    wait(1000);
    cgscale;
    TimeTarget=0; KeyResp=0; KeyTime=0; RT=0; Response=0; TargetDisplayTime=0; Won=0;
else
    
    clearkeys;
    clearpict(3);
    preparestring('+',3);
    drawpict(3);
    wait(Time2Target);

    readkeys;
    logkeys;
    [KeyResp, KeyTime, n]=getkeydown;

    if n~=0
        clearpict(3);
        cgscale(60);
        cgfont('Arial',2);
        preparestring('You pressed the key too early',3);
        drawpict(3);
        wait(1000);
        cgscale;
        TimeTarget=0; KeyResp=0; KeyTime=0; RT=0; Response=0; TargetDisplayTime=0; Won=0;
    else
        clearpict(1);
        drawpict(1);

        % cgpencol(0.5,0.5,0.5); % for grey background
        cgpencol(0,0,0); % for black background
        cgrect(0,0,1000,1000);

        cgpencol(1,1,1);
        cgpenwid(5);
        cgellipse(TargetPosition,0,70,70);

        clearkeys;
        TimeTarget=cgflip;
        logstring(['time Target is ' mat2str(TimeTarget*1000)]);
        wait(TargetDisplayTime);

        readkeys;
        logkeys;
        [KeyResp, KeyTime]=lastkeydown;

        %this measures valid responses
        % Marc's original was: if (KeyResp==81 | KeyResp==82 )
          if (KeyResp==LeftKey || KeyResp==RightKey )  
            RT=KeyTime-TimeTarget*1000;
            Key=KeyResp;
            if RT<=c.RTmax
              % following line is used whether discrimination task or not:
              if  TargetPosition==xlocation2 && KeyResp==RightKey
                Response=1; %correct response
              elseif c.discrim ~= 0
                if TargetPosition==xlocation1 && KeyResp==LeftKey 
                  Response=1;
                end
              else
                Response=2; %incorrect response
              end
            else
              Response=3;
            end
        else
            RT=0;
            Key=0;
            KeyTime=0;
            Response=0;  %missed response
        end

        clearpict(3);
        preparestring('+',3);
        drawpict(3);
        wait(1000);

        clearpict(4);

        x=[0,3,-3];
        y=[5,0,0];

        if TrialCue==1
            if Response==1 && P==1
                Won=c.money;
                cgscale(60);
                cgpencol(1,1,1); % white; was green: cgpencol(0,1,0)
                cgrect(0,-4,2,8);
                cgpolygon(x,y);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                cgtext(['CORRECT CHOICE, you won ' num2str(c.money) ' ''coin'''],0,-10);
            else
                Won=0;
                cgscale(60);
                cgpencol(0.8,0.8,0.8);  % light grey; was yellow: cgpencol(1,1,0); 
                cgrect(0,0,8,2);
                cgpencol(1,1,1);
                cgfont('Arial',2);
                if Response==1
                    cgtext(['CORRECT CHOICE, but you did not win ' num2str(c.money) ' ''coin'' anyway'],0,-10);
                else
                    cgtext('INCORRECT CHOICE, your response was too late or wrong',0,-10);
                end
            end
        elseif TrialCue==2
            if Response==1 && P==1
                Won=0;
                cgscale(60);
                cgpencol(0.8,0.8,0.8);  % light grey; was yellow: cgpencol(1,1,0);
                cgrect(0,0,8,2);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                cgtext(['CORRECT CHOICE, you avoided losing ' num2str(c.money) ' ''coin'''],0,-10);
            else
                Won=-c.money;
                cgscale(60);
                cgpencol(0.4,0.4,0.4);  % darker grey; was red: cgpencol(1,0,0);
                cgrect(0,4,2,8);
                cgpolygon(-x,-y);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                if Response==1
                    cgtext(['CORRECT CHOICE, but you lost ' num2str(c.money)  ' ''coin'' anyway'],0,-10);
                else
                    cgtext('INCORRECT CHOICE, your response was too late or wrong',0,-10);
                end
            end
        elseif TrialCue==3
            if Response==0 && P==1
                Won=c.money;
                cgscale(60);
                cgpencol(1,1,1); % white; was green: cgpencol(0,1,0);
                cgrect(0,-4,2,8);
                cgpolygon(x,y);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                cgtext(['CORRECT CHOICE, you won ' num2str(c.money) ' ''coin'''],0,-10);
            else
                Won=0;
                cgscale(60);
                cgpencol(0.8,0.8,0.8);  % light grey; was yellow: cgpencol(1,1,0);
                cgrect(0,0,8,2);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                if Response==0
                    cgtext(['CORRECT CHOICE, but you did not win ' num2str(c.money) ' ''coin'' anyway'],0,-10);
                else
                    cgtext('INCORRECT CHOICE, you should have not responded',0,-10);
                end
            end
        elseif TrialCue==4
            if Response==0 && P==1
                Won=0;
                cgscale(60);
                cgpencol(0.8,0.8,0.8);  % light grey; was yellow: cgpencol(1,1,0);
                cgrect(0,0,8,2);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                cgtext(['CORRECT CHOICE, you avoided losing ' num2str(c.money) ' ''coin'''],0,-10);
            else
                Won=-c.money;
                cgscale(60);
                cgpencol(0.4,0.4,0.4);  % darker grey; was red: cgpencol(1,0,0)
                cgrect(0,4,2,8);
                cgpolygon(-x,-y);
                cgpencol(1,1,1);
                cgfont('Arial',2)
                if Response==0
                    cgtext(['CORRECT CHOICE, but you lost ' num2str(c.money)  ' ''coin'' anyway'],0,-10);
                else
                    cgtext('INCORRECT CHOICE, you should have not responded',0,-10);
                end
            end
        end
        TimeOutcome=drawpict(4);
        wait(2000);
        cgscale;
    end
end
clearpict(3);
preparestring('+',3);
drawpict(3);
wait(ITI);

% cgfont('Helvetica',3)
data=[TrialCue,TimeTarget,Sham,TargetPosition,KeyResp,KeyTime,RT,Response,TargetDisplayTime,ITI,Won];