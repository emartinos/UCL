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
                    strvcat ('»¶Ó­À´µ½ÊµÑé', ...
                    '°´ÈÎÒâ¼ü¼ÌĞø');
                
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
            strvcat ('ÕâÊÇÒ»¸öĞĞÎªÑ§ÊµÑé', ...
            '°´¿Õ¸ñ¼ü¼ÌĞø');
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
            strvcat ('ÔÚ±¾ÊµÑéÖĞ, Äã½«ÒªÍæÒ»¸öÓÎÏ·',...
            'Äã±ØĞë×ö¾ö¶¨', ....
            'Ä¿µÄÊÇ×¬È¡½ğÇ®',...
            'ÄãÍ¨¹ı°´¼ü¼ÇÂ¼Ñ¡Ôñ', ...
            '°´ÈÎÒâ¼ü¼ÌĞø');
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('±¾ÊµÑéÓÉÒ»ÏµÁĞÃ¿×é10¸öÑ¡ÔñÀ´·Ö×é.',...
            'ÔÚÃ¿×é10¸öÑ¡Ôñ¿ªÊ¼Ê±, Ò»¸ö¹Ì¶¨½ğ¶î»áÏÔÊ¾ÔÚÆÁÄ»ÉÏ',...
            ' ', 'ÏÂÀ´10¸öÑ¡ÔñµÄÃ¿¸ö',...
            'Äã»á¿´µ½Ò»¸ö±ıÍ¼ÔÚÆÁÄ»ÉÏ',...
            '¿´ÆğÀ´¾ÍÏñÏÂÃæÕâ¸öÍ¼Æ¬',...
            '°´ÈÎÒâ¼ü¼ÌĞø');
        
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
            strvcat ('Ã¿¿éĞ¡±ıÉÏµÄÊı×Ö´ú±í½ğ¶î.',...
            'Ğ¡±ıµÄ´óĞ¡´ú±íÄãÓ®Ç®µÄ»ú»á,',...
            'Õâ¾ÍÏñÒ»¸öÂÖÅÌ¶ÄµÄÂÖÅÌ, »òÕßËµ ''ĞÒÔËÂÖ''',...
            'Èç¹ûÄãÑ¡ÔñÍ¶×¢, ¶ø²»ÊÇÄÃ¹Ì¶¨½ğ¶î,',...
            'Ò»¸öºìÉ«Çò»áËæ»úÔÚÂÖÅÌÉÏ×ª¶¯ - Äã»áµÃµ½Ğ¡ÇòÍ£ÔÚÉÏÃæµÄÄÇ¸ö½ğ¶î',...
            'ËùÒÔ, ÉÏÃæÄÇ¸ö±ı, ¿ÉÄÜµÄ',...
            '½á¹ûÎª £0 (Ã»ÓĞÇ®), £1, £3, »òÕß £4.',...
            'ÁíÍâÄãÒ²¿ÉÒÔÑ¡¹Ì¶¨½ğ¶î,',...
            '°´ÈÎÒâ¼ü¼ÌĞø');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        
        instruction = ...
            strvcat ('ÄãÓĞ3ÃëÖÓÀ´×ö¾ö¶¨',...
            'Ö®ºó±ıÖĞĞÄµÄµã»á±äºÚÉ«',...
            'ÄãĞèÒª°´¼üÀ´¾ö¶¨ÊÇÍ¶×¢»¹ÊÇÄÃ¹Ì¶¨½ğ¶î',...
            'ÄãĞèÒªÔÚµã±äÉ«Ö®ºó1ÃëÖÓÖ®ÄÚ°´¼ü,',...
            ' ', 'ÔÚÃ¿¸ö10´ÎµÄ×é½áÊøÊ±, ÄãÖ®Ç°µÄ10¸öÑ¡ÔñÖ®Ò»»á±»Ëæ»úÑ¡ÔñÀ´½øĞĞÒ»ÂÖÓÎÏ·',...
        '°´ÈÎÒâ¼ü¼ÌĞø');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf);  
        
        instruction = ...
            strvcat ('Äã¿ÉÒÔ´ø×ßËùÓĞÓ®µ½µÄ½ğ¶î',...
            'ÇëÅ¬Á¦¼¯ÖĞ¾«ÉñÀ´×öÃ¿´ÎÑ¡Ôñ -',...
            'Ã¿´ÎµÄ¾ö¶¨¶¼»áÓ°Ïì×Ü¶î,',...
            'ÒòÎªÃ¿×éÑ¡ÔñÖĞµÄÒ»¸ö ',...
            '»á±»Ëæ»úÑ¡ÖĞÀ´½øĞĞÒ»ÂÖ´Ó¶ø¾ö¶¨ÄãµÄÊäÓ®.',...
            '°´ÈÎÒâ¼ü¼ÌĞø');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        instruction = ...
            strvcat ('ÏÖÔÚÒªÑ¯ÎÊÄãÏëÓÃÄÄ¸ö¼ü',...
            'À´´ú±íÏÂ×¢',...
            '¼°ÄÄ¸ö¼ü',...
            '´ú±í¹Ì¶¨½ğ¶î');
        
        lines = size (instruction, 1);
        cgalign ('l', 'c');
        for line = 1:lines
            cgtext (instruction (line,:), -10, 5 + ((lines/2 - line) * linespace));
        end; 
        
        cgflip (0, 0, 0);       %present the instruction text on screen
        waitkeydown (inf); 
        
        
    case 'initial'
        instruction = ...
            strvcat ('ÄãÒªÏêÏ¸µÄ½éÉÜÂğ y/n?');
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

