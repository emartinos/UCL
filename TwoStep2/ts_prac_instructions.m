function ts_prac_instructions
% Just present instructions for the two-step task ...

global params

verticalStep = round(params.resolution(2)/40);
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg{1} = '��ӭ���� "˫��" ʵ��!';

msg{2} = '�ڱ�ʵ����ÿ����Ҫ���������� (������) .';
msg{3} = '��һ��ʱ��Ҫ������ͼƬ��ѡһ��. ÿ��ͼƬ��';
msg{4} = '���㵽��һ��ͼƬ. �ڶ�����ͼƬ';
msg{5} = '�ᵼ�½��� (һ����Ϸ��), ����ʲôҲû�� (һ�� "X"). ��Щ';
msg{6} = '�ڶ�����ͼƬ ͨ�� ���н���, ����Щֻ����ʱ��. ';
msg{7} = '��������Ҽ�����ѡ��. �������';
msg{8} = '�Ƿ�����õ�ͼƬ, �Եõ��������. ';
msg{9} = '������ע�� , "���" ͼƬ�᲻ʱ�ı�, ����';
msg{10} = '��Ҫ��ͣ�ļ��! ';
msg{11} = ' ';
msg{12} = '��ʼʱ����һЩ��ϰ��������Ӧ������';
msg{13} = '��ϰ���������ķ���.';
msg{14} = ' ';
msg{15} = '�κ�ʱ���в����׵ĵط���ѯ��ʵ��Ա.';
msg{16} = '�����������';

cgmakesprite(102,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(102);
cgtext(msg{1},0,verticalStep*8);
for i=2:16
  cgtext(msg{i},0,verticalStep*(8-i));
end

ts_wait_input(102,0,0);
% ts_wait_input(102); % debug
end

