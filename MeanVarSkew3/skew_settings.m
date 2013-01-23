function [gamble] = skew_settings(settings)

%last modified 14-7-9 to account for the 0 - 1.30 amounts
%last modified 17-7-9 to get old settings

%SETTINGS for gambles

gamble.pix = [0:.1:.9];%probability settings
% gamble.aix= [0:.1:1.3];%amounts index

% settings =2; %use the colour spectrum selected 

if settings == 1 %random colours
%generate a list of rgb colours for the segments - different colour for
%each amount
gamble.aix= [0:.1:1.3];%amounts index
gamble_c1 = fullfact([2 2 2])-1;
gamble_c2 = [ones(length(gamble_c1),1).*.5 gamble_c1(:,2:3)];
gamble_c3 = gamble_c1; 
gamble_c3(:,2) = ones(length(gamble_c1),1).*.5;
gamble_c4 = gamble_c1; 
gamble_c4(:,3) = ones(length(gamble_c1),1).*.5;
gamble_cix = [gamble_c1(2:end,:); gamble_c2; gamble_c3; gamble_c4];
gamble_cixf = gamble_cix(randperm(length(gamble_cix)),:);
gamble.cixf = gamble_cixf(1:length(gamble.aix), :);

elseif settings==2
    gamble.aix= [0:.1:1.3];%amounts index
colour_array = [0 1 0; %lime green
                .8 0 0; %maroon
                1 1 1; %white
                1 .5 1; %pink
                1 1 0; %yellow
                0 1 1; %turquoise
                0 0 1; %blue
                1 .4 0; %orange
                .5 0 .7; %purple
                1 0 0; %red
                .6 1 .6; %pale green
                .5 .5 0; %khaki
                .8 .8 .8; %light grey
                .5 .5 .5]; %dark grey
gamble.cixf = colour_array(randperm(size(colour_array,1)),:);
elseif settings==3
    gamble.aix= [0:.1:1.3];%amounts index
    %get settings from a previous run
    loadstr = input('Enter name of previous run file', 's')
    D = load([loadstr '.mat'])
    gamble.cixf = D.PARAMETERS.gamble.cixf;
    clear D
elseif settings==4
        gamble.aix= [0:.1:1.3].*2;%amounts index - doubled amounts
colour_array = [0 1 0; %lime green
                .8 0 0; %maroon
                1 1 1; %white
                1 .5 1; %pink
                1 1 0; %yellow
                0 1 1; %turquoise
                0 0 1; %blue
                1 .4 0; %orange
                .5 0 .7; %purple
                1 0 0; %red
                .6 1 .6; %pale green
                .5 .5 0; %khaki
                .8 .8 .8; %light grey
                .5 .5 .5]; %dark grey
gamble.cixf = colour_array(randperm(size(colour_array,1)),:);
end
                
