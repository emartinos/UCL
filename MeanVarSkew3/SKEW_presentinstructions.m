function SKEW_presentinstructions(run_params, keymap, run_number)

%Mkael Symmonds 18/2/8
%last edited 18-6-9
%first presents screen saying type of session, then asks if instructions
%are needed, then presents instuctions

clearkeys;

%-----------------------------------------------------------------------%
%initial screen confirms type of session and asks for space bar press to
%proceed

switch run_params
    
    case 's'
        
        cgfont ('Arial', 12);
        cgpencol (1, 1, 1);
        cgsetsprite (0);
        linespace = 10;
        switch run_number
            
            case 'initial'
                instruction = ...
                    strvcat ('欢迎来到实验', ...
                    '按任意键继续');
                
                cgflip (0,0,0);
                waitkeydown(inf);
            case 1
                instruction = ...
                    strvcat ('This is a scanning experimental session, run 1', ...
                    '<Experimenter - Press the space bar to proceed>');
            case 2
                instruction = ...
                    strvcat ('This is a scanning experimental session, run 2', ...
                    '<Experimenter - Press the space bar to proceed>');
            case 3
                instruction = ...
                    strvcat ('This is a scanning experimental session, run 3', ...
                    '<Experimenter - Press the space bar to proceed>');
        end
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -50, 20 + ((lines/2 - line) * linespace));
        end;
        
        
    case 'b'
        cgfont ('Arial', 1);
        cgpencol (1, 1, 1);
        cgsetsprite (0);
        linespace = 2;
        
        instruction = ...
            strvcat ('这是一个行为学实验', ...
            '按空格键继续');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end;
        
    case 'p'
        cgfont ('Arial', 1);
        cgpencol (1, 1, 1);
        cgsetsprite (0);
        linespace = 2;
        
        instruction = ...
            strvcat ('This is a piloting session', ...
            'Press the space bar to proceed');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end;
        
    case 't'
        cgfont ('Arial', 1);
        cgpencol (1, 1, 1);
        cgsetsprite (0);
        linespace = 2;
        
        instruction = ...
            strvcat ('This is a test session', ...
            'Press the space bar to proceed');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf, keymap.Space); 
        
end %end switch

switch run_number
    case {1, 2, 3}
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf, keymap.Space);  %wait for space bar press
        
end

%-------------------------------------------------------------------------%
%the next instruction screen asks if full instructions are wanted or not

cgfont ('Arial', 1);
cgpencol (1, 1, 1);
cgsetsprite (0);
linespace = 2;

switch run_number
    
    case 'x'
        instruction = ...
            strvcat ('在本实验中, 你将要玩一个游戏',...
            '你必须做决定', ....
            '目的是赚取金钱',...
            '你通过按键记录选择', ...
            '按任意键继续');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('本实验由一系列每组10个选择来分组.',...
            '在每组10个选择开始时, 一个固定金额会显示在屏幕上',...
            ' ', '下来10个选择的每个',...
            '你会看到一个饼图在屏幕上',...
            '看起来就像下面这个图片',...
            '按任意键继续');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        
        SKEW_drawcards(3,0,1,4);
        cgalign ('c', 'c');
        cgdrawsprite(10,0,5);                    
        
        instruction = ...
            strvcat ('每块小饼上的数字代表金额.',...
            '小饼的大小代表你赢钱的机会,',...
            '这就像一个轮盘赌的轮盘, 或者说 ''幸运轮''',...
            '如果你选择投注, 而不是拿固定金额,',...
            '一个红色球会随机在轮盘上转动 - 你会得到小球停在上面的那个金额',...
            '所以, 上面那个饼, 可能的',...
            '结果为 0元 (没有钱), 1元, 3元, 或者 4元.',...
            '另外你也可以选固定金额,',...
            '按任意键继续');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        
        instruction = ...
            strvcat ('你有3秒钟来做决定',...
            '之后饼中心的点会变黑色',...
            '你需要按键来决定是投注还是拿固定金额',...
            '你需要在点变色之后1秒钟之内按键,',...
            ' ', '在每个10次的组结束时, 你之前的10个选择之一会被随机抽取来进行一轮游戏',...
        '按任意键继续');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('你可以带走所有赢到的金额',...
            '请努力集中精神来做每次选择 -',...
            '每次的决定都会影响总额,',...
            '因为每组选择中的一个 ',...
            '会被随机选中来进行真的游戏从而决定你的输赢.',...
            '按任意键继续');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        instruction = ...
            strvcat ('现在要询问你想用哪个键',...
            '来代表下注',...
            '及哪个键',...
            '代表固定金额');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        
    case 'initial'
        instruction = ...
            strvcat ('你要详细的介绍吗 y/n?');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end;
        
        cgflip (0, 0, 0);
        answer.proceed = 0;
        while ~answer.proceed
            [answer.input answer.time n] = waitkeydown (inf);    % wait for key to be pressed
            if (answer.input == keymap.Y | answer.input == keymap.N) %input is 'y' or 'n'
                answer.proceed = 1;
            end;
        end;
        
        %if instructions are wanted, run instruction screens
        if answer.input == keymap.Y
            
            cgfont ('Arial', 1);
            cgpencol (1, 1, 1);
            cgsetsprite (0);
            linespace = 2;
            
            instruction = ...
                strvcat ('请阅读书面的指导语.', ...
                '准备好后, 按空格键继续');
            lines = size (instruction, 1);
            cgalign ('l', 'c');
            for line = 1:lines
                cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
            end;
            
            cgflip (0, 0, 0);       %present the instruction text on screen
            waitkeydown (inf, keymap.Space);  %wait for space bar press
            
        end
        
    otherwise
end

