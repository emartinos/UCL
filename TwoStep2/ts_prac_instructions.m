function ts_prac_instructions
% Just present instructions for the two-step task ...

global params

verticalStep = round(params.resolution(2)/40);
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg{1} = '欢迎来到 "双步" 实验!';

msg{2} = '在本实验中每次你要做两个决定 (分两步) .';
msg{3} = '第一步时你要从两个图片中选一个. 每个图片会';
msg{4} = '带你到另一对图片. 第二步的图片';
msg{5} = '会导致奖励 (一个游戏币), 或者什么也没有 (一个 "X"). 有些';
msg{6} = '第二步的图片 通常 会有奖励, 而有些只是有时会. ';
msg{7} = '用左键和右键来做选择. 你的任务';
msg{8} = '是发现最好的图片, 以得到更多分数. ';
msg{9} = '但是请注意 , "最佳" 图片会不时改变, 所以';
msg{10} = '你要不停的检查! ';
msg{11} = ' ';
msg{12} = '开始时会有一些练习来让你适应本任务';
msg{13} = '练习不会计入你的分数.';
msg{14} = ' ';
msg{15} = '任何时候有不明白的地方请询问实验员.';
msg{16} = '按任意键继续';

cgmakesprite(102,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(102);
cgtext(msg{1},0,verticalStep*8);
for i=2:16
  cgtext(msg{i},0,verticalStep*(8-i));
end

ts_wait_input(102,0,0);
% ts_wait_input(102); % debug
end

