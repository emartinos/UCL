function [ output_args ] = ts_exp_instructions( input_args )
%TS_EXP_INSTRUCTIONS Summary of this function goes here
%   Detailed explanation goes here

global params

cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg1 = 'ʵ�鼴����ʼ';
msg2 = '����3����Ϣ�Ļ���';
msg3 = '<explain what changes and what doesn''t>';
msg4 = '���κβ����׵ĵط������ھ�ѯ��ʵ��Ա!';
msg5 = '�����������';

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