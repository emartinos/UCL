function [RoulT, RoulS, out_ang, out_amt]  = MVS3b_skewness_drawroulette(PARAMETERS, sureamount, input2, gamble_col, choice)
%Roulette display, REFERENCES WITH SCANNING & EMULSCANNING CALLS REMOVED.
% It plays out the gamble like a roulette
% wheel. Amounts have been converted to pounds.
% M Symmonds 16-6-9 - adapted by M Moutoussis for Depression Genetics 
% MVS3b_ ... version returns a 'filler' RoulS[lice] full of zeros.

cgflip(0, 0, 0);                        % show blank screen

%SETTINGS
gamble_aix= PARAMETERS.gamble.aix;%amounts index
% T_end = 6000; %duration of spin time
T_end = PARAMETERS.TIMINGS.T_end;
%POSITION AND SIZE SETTINGS
xpos = 0; %sets centre of pie
ypos = 0;   %sets centre of pie
xwid = 380; %sets dimensions of pie
ywid = 350; %sets dimensions of pie

%WRITING SETTINGS
cgpencol(0,0,0); %black ink
cgfont('Arial', 24);
cgalign('c','c'); %align centre
scale1 = .7; %draw text proportion from centre of circle
scale2 = 1.1; %draw the red roulette ball outside the circle
texttime1 = PARAMETERS.TIMINGS.endblock3; %wait time for text
texttime2 = PARAMETERS.TIMINGS.endblock4;
texttime3 = PARAMETERS.TIMINGS.endblock5;
%make a pie sprite
cgmakesprite(2, xwid, ywid,0,0,0)
cgsetsprite(2)

% input1 = PIE_input(1,:);
%draw the pie into the sprite 2
% input2 = PIE_ix(1).data;
for k = 1:size(input2,1)
    carr = gamble_col(k,:); %sets colour
    cgarc(xpos, ypos ,xwid,ywid,input2(k,1),input2(k,2),carr,'s')
    theta = mean(input2(k,1:2));
    theta = theta.*pi/180; %convert to radians for length calculations
%     cgtext([num2str(PARAMETERS.gamble.aix(input2(k,3)).*100) 'p'],scale1.*xwid.*cos(theta)./2, scale1.*ywid.*sin(theta)./2)  
    cgtext(['元' num2str(input2(k,3))],scale1.*xwid.*cos(theta)./2, scale1.*ywid.*sin(theta)./2)  
end

cgsetsprite(0)

%now set up a movie to draw the sprite and a red circle going round if gambling choice was selected.
if choice == 1  % i.e. if we are going to play the roulette
  %first determine the finishing angle
  out_ang = floor(rand.*360); %a random angle
  %compare this to the angles in the relevant PIE_ix
  conv_ang = input2(:, 1:2) - floor(input2(:,1:2)./360)*360; %converts angles to within 360
  out_ang_ix1 = (conv_ang - out_ang);
  if any(any(out_ang_ix1)==0)==1 %if any of the entries match an angle (so
                                 %the outcome would be indeterminate)
    out_ang = out_ang+1; %add one degree to the angle (so that it falls into next sector)
    out_ang_ix1 = (conv_ang - out_ang);
  end
  out_ang_ix2 = find(out_ang_ix1(:,1)<0 & out_ang_ix1(:,2)>0); %where has the roulette ball ended?
  if isempty(out_ang_ix2) %if the sector the ball falls in is the last one
    out_ang_ix2 = find(conv_ang(:,1) - conv_ang(:,2)>=0); %find the sector crossing 0 degrees
  end
  out_amt = input2(out_ang_ix2,3); %what is the output amount?
  %was: out_amt = PARAMETERS.gamble.aix(input2(out_ang_ix2,3)); %what is the output amount?

  angfin = 720+out_ang; %set final angle
  frame_dur = 25; %10 ms spin increment time for each frame
  [pos_out, tix] = skewness_roulettepos(angfin, T_end, frame_dur); % function createspositions 
                                                                   % for every frame  
elseif choice==0  % i.e. if sure amount was selected
  out_ang = PARAMETERS.NullValue;
  out_amt = sureamount;
  
else  % if neither of the valid choices was made
  out_ang  = PARAMETERS.NullValue;
  out_amt = PARAMETERS.NullValue;
  
end
  
%first draw the chosen gamble on screen
cgdrawsprite(2,0,0)
cgpencol(1,1,1)
cgtext('从上一组抽取的轮盘:', 0, ywid./2+20)
RoulS.texta= 0; RoulT.texta = time; % for MVS3b_ ...
% was: [RoulS.texta, RoulT.texta] = lastslice(PARAMETERS.port); % leftover ...
cgflip(0,0,0)
wait(texttime1)


cgdrawsprite(2,0,0)
if choice==0
    cgtext(['这是随机抽取的轮盘. 你选择了: 元 ' num2str(sureamount) ' 固定金额'], 0, -(ywid./2+20))
    RoulS.textb=0; RoulT.textb = time; % for MVS3b_ ...
    % was: [RoulS.textb, RoulT.textb] = lastslice(PARAMETERS.port);
    cgflip(0,0,0)
    wait(texttime2)
    RoulS.startout=0; RoulT.startout = time; % for MVS3b_ ...
    % was: [RoulS.startout, RoulT.startout] = lastslice(PARAMETERS.port);
    cgdrawsprite(2,0,0)
    cgtext(['你得到 元 ' num2str(sureamount) ' '], 0, -(ywid./2+20))
    waituntil(RoulT.startout + T_end)
    cgflip(0,0,0)  
    
elseif choice==1
    cgtext(['这是随机抽取的轮盘. 你选择了: ' '投注'], 0, -(ywid./2+20))
    RoulS.textb=0; RoulT.textb= time; % for MVS3b_ ...
    % was: [RoulS.textb, RoulT.textb] = lastslice(PARAMETERS.port);
    k=1;
    cgflip(0,0,0)
    %now the graphic for the roulette spin (decreasing speed until stop)
    wait(texttime2)
    RoulS.startout=0; RoulT.startout = time; % for MVS3b_ ...
    % was: [RoulS.startout, RoulT.startout] = lastslice(PARAMETERS.port);
    ang = pos_out(k);
    while ang < angfin 
        cgdrawsprite(2,0,0)
        cgpencol(1, 0, 0) %red roulette ball
        cgellipse(scale2.*xwid.*cos(ang.*pi./180)./2, scale2.*xwid.*sin(ang.*pi./180)./2, (scale2-1).*xwid,(scale2-1).*ywid,'f')
        cgpencol(0, 0, 0) %black line
        cgpenwid(2)
        cgdraw(scale2.*xwid.*cos(ang.*pi./180)./2, scale2.*xwid.*sin(ang.*pi./180)./2, xwid.*cos(ang.*pi./180)./2, ywid.*sin(ang.*pi./180)./2)
        cgflip(0,0,0)  
        k=k+1; 
        ang = pos_out(k);
        waituntil(RoulT.startout + tix(k))
    end
    cgdrawsprite(2,0,0)
    cgpencol(1, 0, 0) %red roulette ball
    cgellipse(scale2.*xwid.*cos(ang.*pi./180)./2, scale2.*xwid.*sin(ang.*pi./180)./2, (scale2-1).*xwid,(scale2-1).*ywid,'f')
    cgpencol(0, 0, 0) %black line
    cgpenwid(2)
    cgdraw(scale2.*xwid.*cos(ang.*pi./180)./2, scale2.*xwid.*sin(ang.*pi./180)./2, xwid.*cos(ang.*pi./180)./2, ywid.*sin(ang.*pi./180)./2)
    cgpencol(1,1,1)
    cgtext(['你得到 元 ' num2str(out_amt) ' '], 0, -(ywid./2+20))
    cgflip(0,0,0)
else
    
    if choice == PARAMETERS.NullValue
        cgtext(['这是随机抽取的轮盘. 未做任何决定'], 0, -(ywid./2+20))
    elseif choice == PARAMETERS.MistakeCode
        cgtext(['这是随机抽取的轮盘. 无效按键'], 0, -(ywid./2+20))
    end
    cgdrawsprite(2,0,0)
    RoulS.textb = 0; RoulT.textb = time;  % for MVS3b_ ...
    % was: [RoulS.textb, RoulT.textb] = lastslice(PARAMETERS.port);
    cgflip(0,0,0)
    %match the time as accurately as possible
    wait(texttime2)
    RoulS.startout=0; RoulT.startout= time;  % for MVS3b_ ...
    % was: [RoulS.startout, RoulT.startout] = lastslice(PARAMETERS.port);
    cgdrawsprite(2,0,0)
    cgtext(['你什么也没得 (0 元)'], 0, -(ywid./2+20))
    waituntil(RoulT.startout + T_end)
    cgflip(0,0,0)
end
RoulS.endspin = 0; RoulT.endspin = time;  % for MVS3b_ ...
% was: [RoulS.endspin , RoulT.endspin ] = lastslice(PARAMETERS.port);

waituntil(RoulT.startout + T_end + texttime3)
%output time and amount
RoulS.end = 0; % for MVS3b_ ... empty value - no slices in this version  
RoulT.end = time; % for MVS3b_ ... 
% was: [RoulS.end, RoulT.end] = lastslice(PARAMETERS.port);


