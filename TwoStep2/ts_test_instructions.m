function [ output_args ] = ts_test_instructions( input_args )
%TS_TEST_INSTRUCTIONS Summary of this function goes here
%   Detailed explanation goes here

global params

verticalStep = round(params.resolution(2)/40);
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg{1} = 'That was the practice phase.';
msg{2} = ' ';
msg{3} = 'If you have any questions, feel free to ask the experimenter.';
msg{4} = 'From now on you''ll start winning points whenever you see the';
msg{5} = 'pound, so play well and earn yourself a big payout!';
msg{6} = 'Press any key to continue:';

cgmakesprite(102,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(102);
for i=1:6
  cgtext(msg{i},0,verticalStep*(6-i));
end

ts_wait_input(102,0,0);
% ts_wait_input(102); % debug 

end

