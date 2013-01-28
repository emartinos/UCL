function [PIE_info]  = MVS3_drawgamble(input1, gamble_cixf, cuescreen, initial_ang, sure_amount, key_selection)

%converts a gamble input into a pie chart sprite for presnetation in cogent
%input is a vector list of 8: 4 probabilities and 4 amounts

%POSITION AND SIZE SETTINGS
scale_global = 1.0; % was in MEG version: 1024/640;
xpos = 0; %sets centre of pie
ypos = 0;   %sets centre of pie
xwid = 380*scale_global; %sets dimensions of pie
ywid = 350*scale_global; %sets dimensions of pie
scale_cue = 1*scale_global; %scaling of the cue size

%store data about pie angles for trial
PIE_info = [];

%step through the input
if initial_ang<0 %first gamble presentation
a1 = round(rand*360); %initialise angle (randomised angle)
else
    a1 = initial_ang;
end

%pick 4 random colours
% gamble_col = gamble_cixf(randperm(size(gamble_cixf,1)),:);

for k = 1:4
%     carr = gamble_col(k, :); %sets colour
    carr = gamble_cixf(k, :); %sets colour
    a2 = a1 + 360.*input1(k); %sets finishng angle in degees (can be greater than 360)
    cgarc(xpos, ypos ,xwid,ywid,a1,a2,carr,'s')
        %store the angle indices and amount for writing text
        PIE_info = [PIE_info; a1 a2 input1(k+4)];
        
        a1 = a2; %increment angle
    end

%WRITING SETTINGS
cgpencol(0,0,0); %black ink
cgfont('Arial', 24*scale_global);
cgalign('c','c'); %align centre
scale1 = .7; %draw text proportion from centre of circle
%now write text amount in each segment
for i = 1:size(PIE_info,1) %go through PIE data list
    theta = mean(PIE_info(i, 1:2));
    theta = theta.*pi/180; %convert to radians for length calculations
    cgtext(['元' num2str(PIE_info(i,3))],scale1.*xwid.*cos(theta)./2, scale1.*ywid.*sin(theta)./2)  
end

%WRITE SURE AMOUNT AT TOP LEFT AS REMINDER
cgpencol(1, 1, 1)
cgtext(['确定金额: 元' num2str(sure_amount)], -180*scale_global, 200*scale_global)

if cuescreen
    cgpencol(.2, .2, .2)
    cgrect(0,0,30*scale_cue*scale_global,30*scale_cue*scale_global) %draw a grey square in centre of pie as cue for response
    if key_selection == 0
    cgpencol(1, 1, 1) %white - no key
elseif key_selection ==1
    cgpencol(.1, .2, .5) %gamble -  green key
elseif key_selection ==2
    cgpencol(.1,.5,.2) %sure - blue key
elseif key_selection ==3
    cgpencol(1,0,0) %error - red key
end
    cgellipse(0,0,25*scale_cue*scale_global, 25*scale_cue*scale_global, 'f') %draw a white ellipse in centre of pie as cue for response
end
