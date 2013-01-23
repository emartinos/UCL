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
                    strvcat ('Welcome to the experiment', ...
                    'Press any key to proceed');
                
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
            strvcat ('This is a behavioural experimental session', ...
            'Press the space bar to proceed');
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
            strvcat ('In this experiment, you will be playing a game where',...
            'you have to make choices', ....
            'in order to earn money',...
            'You will register your choices by pressing keys on the keypad or keyboard', ...
            'Press any key to proceed');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('The experiment is grouped into a series of 10 choices at a time.',...
            'At the beginning of each block of 10 choices, a SURE AMOUNT will be shown on the screen',...
            ' ', 'For each of the next 10 choices',...
            'You will see a pie chart on the screen',...
            'This will look simliar to the following image',...
            'Press any key to proceed');
        
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
            strvcat ('The numbers on each segment are amounts in pence.',...
            'The size of each segment shows the chance that you will win that amount,',...
            'This is like a roulette wheel, or ''wheel of fortune''',...
            'If you choose to gamble, rather than take the sure amount,',...
            'a red ball will be randomly spun around the wheel - you will get the amount of money from the segment it finishes in',...
            'So, for the above pie, the possible',...
            'outcomes could be £0 (no money), £1, £3, or £4.',...
            'On the other hand, you can pick the sure amount,',...
            'Press any key to proceed');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        
        instruction = ...
            strvcat ('You will get 3s to think about your choice',...
            'after which the dot in the middle of the pie will turn black',...
            'and you need to respond with your choice to either gamble or take the sure amount',...
            'You need to respond within 1s of the dot changing colour,',...
            ' ', 'At the end of each block of 10 trials, one of your last 10 choices will be selected at random and played out',...
        'Press any key to proceed');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('You will take home the total amount won from all the played out choices',...
            'Please try to concentrate carefully on each decision -',...
            'Every choice you make could potentially count,',...
            'as one choice in each block will be ',...
            'randomly selected and played out for real to determine your winnings.',...
            'Press any key to proceed');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        instruction = ...
            strvcat ('You will now be asked to choose which key you want',...
            'to press to choose to gamble',...
            'and which key you want to press to select',...
            'the sure amuont');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        
    case 'initial'
        instruction = ...
            strvcat ('Do you want full instructions y/n?');
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

