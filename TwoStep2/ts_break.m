function [ output_args ] = ts_break( input_args )
%TS_BREAK Summary of this function goes here
%   Detailed explanation goes here

global params;
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

cgtext(['Have a short break now. Remember, the more ''coins'' you win the greater your real earnings!'],0,0);
cgflip(params.background);
wait(params.task.break.duration*1000);

cgmakesprite(501,params.resolution(1),params.resolution(2));
cgsetsprite(501);
cgtext('Ready? press a key to start',0,0);
cgsetsprite(0);
ts_wait_input(501,0,0);
% ts_wait_input(501); % debug
cgflip(params.background);
wait(1000);

end

