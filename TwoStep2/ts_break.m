function [ output_args ] = ts_break( input_args )
%TS_BREAK Summary of this function goes here
%   Detailed explanation goes here

global params;
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

cgtext(['现在可以休息一下. 记得, 越多 ''硬币'' 你赢得你的真实收入就更多!'],0,0);
cgflip(params.background);
wait(params.task.break.duration*1000);

cgmakesprite(501,params.resolution(1),params.resolution(2));
cgsetsprite(501);
cgtext('准备? 按任意键开始',0,0);
cgsetsprite(0);
ts_wait_input(501,0,0);
% ts_wait_input(501); % debug
cgflip(params.background);
wait(1000);

end

