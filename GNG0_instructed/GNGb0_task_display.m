function  [data] = GNGb0_task_display(TrialCue, Time2Target, Sham, ...
                                     xlocation1, xlocation2, TargetDispT, ...
                                     ITI, RandCSs, scr, LeftKey, RightKey)

% - - Constants - - 
global c; % This contains the various constants set during initialization.
n=0;
Money=c.money;
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
[KeyRespC1, KeyTimeC1, n]=getkeydown;

if n~=0
    ResponseCue1=1;
else 
    ResponseCue1=0;
end
   
clearkeys;
clearpict(3);
preparestring('+',3);
drawpict(3);
wait(Time2Target);

readkeys;
logkeys;
[KeyRespC2, KeyTimeC2, n]=getkeydown;

if n~=0
    ResponseCue2=1;
else 
    ResponseCue2=0;
end

if Sham==1        % This  Sham==1 this is NOT a sham trial, so go won with decision task.
    clearpict(1);
    drawpict(1);

    % cgpencol(0.5,0.5,0.5);  % for gray background
    cgpencol(0,0,0);  % for black background	
    cgrect(0,0,1000,1000);

    cgpencol(1,1,1);
    cgpenwid(5);
    cgellipse(TargetPosition,0,70,70);

    clearkeys;
    TimeTarget=cgflip;
    logstring(['time Target is ' mat2str(TimeTarget*1000)]);
    wait(TargetDispT);

    readkeys;
    logkeys;
    [KeyResp, KeyTime]=lastkeydown;

    %this measures valid responses. Was:
    % if (KeyResp==81 | KeyResp==82 )
    if (KeyResp==LeftKey || KeyResp==RightKey )  
        RT=KeyTime-TimeTarget*1000;
        Key=KeyResp;
        if RT<c.RTmax
            % following line works whether discrimination task or not:
            if  TargetPosition==xlocation2 && KeyResp==RightKey
                Response=1; %correct response
            % but only consider other key presses only for discrimination task:
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
    
    if TrialCue==1 % Go To Win
      % If either the response was correct 'Go' AND the dominant probabilistic outcome obtained, OR
      % bad decisions only lead to bad outcomes probabilistically :
      if (Response==1 && P==1) || (c.bad_dec_prob && (Response~=1 && P==0))
        cgscale(60);
        cgpencol(1,1,1); % white; was green: cgpencol(0,1,0);
        cgrect(0,-4,2,8);
        cgpolygon(x,y);
        Won=Money;
      else
        cgscale(60);
        cgpencol(0.8,0.8,0.8);  % light grey; was yellow: cgpencol(1,1,0)
        cgrect(0,0,8,2);
        Won=0;
      end
    elseif TrialCue==2  % Go to avoid loss
      % Exactly the same logic as TrialCue==1 above :
      if (Response==1 && P==1) || (c.bad_dec_prob && (Response~=1 && P==0))
        cgscale(60);
        cgpencol(0.8,0.8,0.8);  % was yellow: cgpencol(1,1,0);
        cgrect(0,0,8,2);
        Won=0;
      else
        cgscale(60);
        cgpencol(0.4,0.4,0.4);  % darker grey; was red: cgpencol(1,0,0);
        cgrect(0,4,2,8);
        cgpolygon(-x,-y);
        Won=-Money;
      end
    elseif TrialCue==3  % No-Go To Win
      % Similar logic, but note 'Response~=0 && P==0' for No-Go  case
      if (Response==0 && P==1)  || (c.bad_dec_prob && (Response~=0 && P==0))
        cgscale(60);
        cgpencol(1,1,1); % white; was green: cgpencol(0,1,0);
        cgrect(0,-4,2,8);
        cgpolygon(x,y);
        Won=Money;
      else
        cgscale(60);
        cgpencol(0.8,0.8,0.8);  % was yellow: cgpencol(1,1,0);
        cgrect(0,0,8,2);
        Won=0;
      end
    elseif TrialCue==4
      % Exactly the same logic as TrialCue==3 above :
      if (Response==0 && P==1)  || (c.bad_dec_prob && (Response~=0 && P==0))
        cgscale(60);
        cgpencol(0.8,0.8,0.8);  % was yellow: cgpencol(1,1,0);
        cgrect(0,0,8,2);
        Won=0;
      else
        cgscale(60);
        cgpencol(0.4,0.4,0.4);  % was red: cgpencol(1,0,0);
        cgrect(0,4,2,8);
        cgpolygon(-x,-y);
        Won=-Money;
      end
    end
    TimeOutcome=drawpict(4);
    wait(1000);
    cgscale;
    
    clearpict(3);
    preparestring('+',3);
    drawpict(3);
    wait(ITI);
else                  % i.e. if Sham ~=1, so this IS a shame trial - don't do decision task!
    clearpict(3);
    preparestring('+',3);
    drawpict(3);
    wait(500);
    TimeTarget=0;
    KeyResp=0;
    KeyTime=0;
    RT=0;
    Response=0;
    TargetDispT=0;
    Won=0;
    TimeOutcome=0;
end

data=[TrialCue,TimeCue,ResponseCue1,Time2Target,TimeTarget,ResponseCue2,Sham,TargetPosition,KeyResp,KeyTime,RT,Response,TargetDispT,TimeOutcome,ITI,Won];
