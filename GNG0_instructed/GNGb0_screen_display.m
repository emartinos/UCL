function  [data] = GNGb0_screen_display (TrialTask, Time2Target, Sham, ...
                                   xlocation1, xlocation2, TargetDisplayTime, ...
                                   ITI, LeftKey, RightKey) 
% - - Constants - - 
global c; % This contains the various constants set during initialization.
% - - - - - - - - - 
                               
if rand<=0.5
    TargetPosition=xlocation1;
else
    TargetPosition=xlocation2;
end


clearpict(1);
drawpict(1);

% cgpencol(0.5,0.5,0.5); % for gray background
cgpencol(0,0,0); % for black background
cgrect(0,0,1000,1000);

cgpencol(1,1,1);
cgpenwid(5);
cgellipse(TargetPosition,0,70,70);

clearkeys;
TimeTarget=cgflip;
logstring(['time Target is ' mat2str(TimeTarget)]);
wait(TargetDisplayTime);

readkeys;
logkeys;
[KeyResp, KeyTime]=lastkeydown;

%this measures valid responses. In Marc's original it started as: 
% if (KeyResp==81 | KeyResp==82)
if (KeyResp==LeftKey || KeyResp==RightKey )  
    RT=KeyTime-TimeTarget*1000;
    Key=KeyResp;
    if RT<=c.RTmax
        % following line is used whether discrimination task or not:
        if TargetPosition==xlocation2 && KeyResp==RightKey
            Response=1; %correct response
        % but only consider other key presses only for discrimination task:
        elseif c.discrim ~= 0
          if TargetPosition==xlocation1 && KeyResp==LeftKey
            Response=1;
          end
        else
            Response=2; %incorrect response but in time
        end
    elseif RT>c.RTmax && ((TargetPosition==xlocation2 && KeyResp~=RightKey) || (TargetPosition==xlocation1 && KeyResp~=LeftKey))
        Response=3;     % incorrect AND too late !
    else
        Response=4;
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

if Response==1
    preparestring(['正确'],4);
elseif Response==2
    preparestring('错误',4);
elseif Response==3
    preparestring('错误且太晚',4);
elseif Response==4
    preparestring('正确但太晚',4);
else
    preparestring('你没有在有效时间内反应',4)
end
TimeOutcome=drawpict(4);
wait(1000);

clearpict(3);
preparestring('+',3);
drawpict(3);
wait(ITI);

data=[TimeTarget,TargetPosition,KeyResp,KeyTime,RT,Response,TargetDisplayTime,ITI];