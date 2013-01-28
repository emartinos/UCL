function [PIE_info]  = skewness_drawgamble(input1, gamble_aix, gamble_pix, gamble_cixf, cuescreen, initial_ang, sure_amount, key_selection)

%input to this function should be a list of probabilities ordered by ascending
%amounts e.g. [.9 .1 0 0 0 0 0 0 0 0 0 0] 

%converts a gamble input into a pie chart sprite for presnetation in cogent

%POSITION AND SIZE SETTINGS
xpos = 0; %sets centre of pie
ypos = 0;   %sets centre of pie
xwid = 350; %sets dimensions of pie
ywid = 350; %sets dimensions of pie

%store data about pie angles for trial
PIE_info = [];

%step through the input
aix=1; %initialise amount index
if initial_ang<0 %first gamble presentation
a1 = round(rand*360); %initialise angle (randomised angle)
else
    a1 = initial_ang;
end

while aix<=length(gamble_aix)
    carr = gamble_cixf(aix, :); %sets colour
    if input1(aix)==0 %if p=0 i.e. no outcome of this amount
        aix = aix + 1;
    else
        a2 = a1 + 360.*input1(aix); %sets finishng angle in degees (can be greater than 360)
        cgarc(xpos, ypos ,xwid,ywid,a1,a2,carr,'s')
        
        %store the angle indices and amount for writing text
        PIE_info = [PIE_info; a1 a2 aix];
        
        a1 = a2; %increment angle
        aix = aix + 1; %increment amount index
    end
end

%WRITING SETTINGS
cgpencol(0,0,0); %black ink
cgfont('Arial', 24);
cgalign('c','c'); %align centre
scale1 = .7; %draw text proportion from centre of circle
%now write text amount in each segment
for i = 1:size(PIE_info,1) %go through PIE data list
    theta = mean(PIE_info(i, 1:2));
    theta = theta.*pi/180; %convert to radians for length calculations
    cgtext([num2str(gamble_aix(PIE_info(i,3)).*100) 'p'],scale1.*xwid.*cos(theta)./2, scale1.*ywid.*sin(theta)./2)  
end

%WRITE SURE AMOUNT AT TOP LEFT AS REMINDER
cgpencol(1, 1, 1)
cgtext(['¹Ì¶¨½ð¶î: ' num2str(sure_amount) 'p'], -180, 200)

if cuescreen
    cgpencol(.2, .2, .2)
    cgrect(0,0,30,30) %draw a grey square in centre of pie as cue for response
    if key_selection == 0
    cgpencol(1, 1, 1) %white - no key
elseif key_selection ==1
    cgpencol(0, 0, 1) %gamble -  green key
elseif key_selection ==2
    cgpencol(0,1,0) %sure - blue key
elseif key_selection ==3
    cgpencol(1,0,0) %error - red key
end
    cgellipse(0,0,25, 25, 'f') %draw a white ellipse in centre of pie as cue for response
end
