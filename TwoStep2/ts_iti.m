function [ ITI ] = ts_iti( range )
%PG_ITI takes start and end ITI and calculates a random ITI
% 

global params

ITI = double(randi(range*1000));

cgpencol(params.text.color);
cgfont(params.text.font,80);
cgtext('*',0,0);
cgflip(params.background);
wait(ITI);



end

