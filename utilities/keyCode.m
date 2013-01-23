function keyNumCode = keyCode( keyName, context )
% function keyNumCode = keyCode( keyName, context )
% Lookup of the numerical code for a KEY_NAME string in a particular
% context, e.g. the NSPN Dell Latitudes or a scanner ...

%% Default arguments:
if nargin < 2
    context = 1; 
end;

%% contexts to be catered for :
Dell_Latitude = 1;
% Add lines about a particular device (keypad) here ...

%% Lookup:
if  context == Dell_Latitude
    switch keyName
        case 'RETURN'
            keyNumCode = 59;
        case 'SPACE'
            keyNumCode = 71;
        case 'UP_ARROW'   
            keyNumCode = 95;
        case 'LEFT_ARROW'   
            keyNumCode = 97;
        case 'RIGHT_ARROW'
            keyNumCode = 98;
        case 'DOWN_ARROW'
            keyNumCode = 100;
        case 'ESCAPE'
            keyNumCode = 52;
        case 'G'    % Used in MVS3
            keyNumCode = 7;
        case 'S'
            keyNumCode = 19;
        otherwise
            error('Valid names for context Dell_Latitude are: ''RETURN'',''SPACE'',''UP_ARROW'',''LEFT_ARROW'',''RIGHT_ARROW'',''DOWN_ARROW''');
    end % of choices available for context Dell_Latitude
else
    error('function keyCode(keyName, context) unprepared for the context provided');
end
    
end % of whole function