function [ output_args ] = ts_test_instructions( input_args )
%TS_TEST_INSTRUCTIONS Summary of this function goes here
%   Detailed explanation goes here

global params

verticalStep = round(params.resolution(2)/40);
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg{1} = '刚才是练习阶段.';
msg{2} = ' ';
msg{3} = '如果你有任何问题, 请询问实验员.';
msg{4} = '从现在起你要开始得分无论何时看到';
msg{5} = '一个硬币, 好好努力赚取更多!';
msg{6} = '按任意键继续:';

cgmakesprite(102,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(102);
for i=1:6
  cgtext(msg{i},0,verticalStep*(6-i));
end

ts_wait_input(102,0,0);
% ts_wait_input(102); % debug 

end

