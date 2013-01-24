function [ output_args ] = ts_exp_instructions( input_args )
%TS_EXP_INSTRUCTIONS Summary of this function goes here
%   Detailed explanation goes here

global params

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = '实验即将开始';
msg2 = '你有3个休息的机会';
msg3 = '<explain what changes and what doesn''t>';
msg4 = '有任何不明白的地方请现在就询问实验员!';
msg5 = '按任意键继续';

cgmakesprite(102,params.resolution(1),params.resolution(2),params.bckgrnd);
cgsetsprite(102);
cgtext(msg1,0,params.resolution(1)/6);
cgtext(msg2,0,0);
cgtext(msg3,0,-params.resolution(1)/12);
cgtext(msg4,0,-params.resolution(1)/10);
cgtext(msg5,0,-params.resolution(1)/8);

ts_wait_input(102,0,0);
% ts_wait_input(102); % debug
end