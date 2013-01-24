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
                    strvcat ('��ӭ����ʵ��', ...
                    '�����������');
                
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
            strvcat ('����һ����Ϊѧʵ��', ...
            '���ո������');
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
            strvcat ('�ڱ�ʵ����, �㽫Ҫ��һ����Ϸ',...
            '�����������', ....
            'Ŀ����׬ȡ��Ǯ',...
            '��ͨ��������¼ѡ��', ...
            '�����������');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('��ʵ����һϵ��ÿ��10��ѡ��������.',...
            '��ÿ��10��ѡ��ʼʱ, һ���̶�������ʾ����Ļ��',...
            ' ', '����10��ѡ���ÿ��',...
            '��ῴ��һ����ͼ����Ļ��',...
            '�����������������ͼƬ',...
            '�����������');
        
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
            strvcat ('ÿ��С���ϵ����ִ�����.',...
            'С���Ĵ�С������ӮǮ�Ļ���,',...
            '�����һ�����̶ĵ�����, ����˵ ''������''',...
            '�����ѡ��Ͷע, �������ù̶����,',...
            'һ����ɫ��������������ת�� - ���õ�С��ͣ��������Ǹ����',...
            '����, �����Ǹ���, ���ܵ�',...
            '���Ϊ �0 (û��Ǯ), �1, �3, ���� �4.',...
            '������Ҳ����ѡ�̶����,',...
            '�����������');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        
        instruction = ...
            strvcat ('����3������������',...
            '֮������ĵĵ����ɫ',...
            '����Ҫ������������Ͷע�����ù̶����',...
            '����Ҫ�ڵ��ɫ֮��1����֮�ڰ���,',...
            ' ', '��ÿ��10�ε������ʱ, ��֮ǰ��10��ѡ��֮һ�ᱻ���ѡ��������һ����Ϸ',...
        '�����������');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('����Դ�������Ӯ���Ľ��',...
            '��Ŭ�����о�������ÿ��ѡ�� -',...
            'ÿ�εľ�������Ӱ���ܶ�,',...
            '��Ϊÿ��ѡ���е�һ�� ',...
            '�ᱻ���ѡ��������һ�ִӶ����������Ӯ.',...
            '�����������');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        instruction = ...
            strvcat ('����Ҫѯ���������ĸ���',...
            '��������ע',...
            '���ĸ���',...
            '����̶����');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        
    case 'initial'
        instruction = ...
            strvcat ('��Ҫ��ϸ�Ľ����� y/n?');
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
                strvcat ('Please read the written instruction sheets.', ...
                'When ready to start, press the space bar to proceed');
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

