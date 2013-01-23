function ts_prac_instructions
% Just present instructions for the two-step task ...

global params

verticalStep = round(params.resolution(2)/40);
cgfont(params.text.font,params.text.font_size);
cgpencol(params.text.color);

msg{1} = 'Welcome to the "Two step" task!';

msg{2} = 'In this task you will have to make two decisions (at two steps) during each trial.';
msg{3} = 'At the first step you will choose between two pictures. Each of these will lead';
msg{4} = 'you to another pair of pictures. Each of the pictures of the second step';
msg{5} = 'can lead you to a reward (a play-pound), or to nothing (an "X"). Some of the';
msg{6} = 'pictures in the second step USUALLY lead to a reward, some only SOMETIMES. ';
msg{7} = 'Use the LEFT ARROW and RIGHT ARROW keys to make your choices. Your task';
msg{8} = 'is to find out which is the best and get to it, in order to win points. ';
msg{9} = 'Note, however, that "the best" pictures will change every now and then, so';
msg{10} = 'you will have to keep checking! ';
msg{11} = ' ';
msg{12} = 'You will start with some practice rounds to get used to the task';
msg{13} = 'The practice trials will not count towards your score.';
msg{14} = ' ';
msg{15} = 'Feel free to ask the experimenter if anything is unclear at any point.';
msg{16} = 'Press any key to continue';

cgmakesprite(102,params.resolution(1),params.resolution(2),params.background);
cgsetsprite(102);
cgtext(msg{1},0,verticalStep*8);
for i=2:16
  cgtext(msg{i},0,verticalStep*(8-i));
end

ts_wait_input(102,0,0);
% ts_wait_input(102); % debug
end

