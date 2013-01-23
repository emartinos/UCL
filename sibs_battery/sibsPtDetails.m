function experimentParams = sibsPtDetails( params, gui )
% function experimentParams = sibsPtDetails( params ) updates the ID string,
% age and gender for the current participant if necessary.
% INTENTIONALLY DOES NOT WRITE THE UPDATED DATA TO DISK.

if nargin < 2; gui=1; end; % default is to use popup window.

experimentParams = params;
batLogFileName = [params.data_dir,'\',params.ptCode,'_batteryLog.mat'];
detailsValid = 0; % This isn't used seriously as yet, but the rudiments of a loop
                  % to use it are included below.

if exist(batLogFileName,'file')==0 % if we haven't started with this participant yet
    while detailsValid == 0
      if gui == 0   % if want input at the command line, not with popup 
        ageStr  = input(  '               age (y): ', 's');  % holding variable
        experimentParams.age = str2double(ageStr);           % stored parameter.
        experimentParams.sex =input(  '          gender (m/f): ', 's'); 
        experimentParams.sex = experimentParams.sex(1); % Retain just initial.
      else
        prompt = {'Participant\n age (years only):','Participant Gender (f/m):'}; % 
        dlg_title = ['Demographics',params.ptCode];
        num_lines = 1;
        def = {'',''};
        options.Resize='on';
        answer = inputdlg(prompt,dlg_title,num_lines,def,options);
        experimentParams.sex = answer{2}(1);  % Retain just initial.
        experimentParams.age = str2double(answer{1});               
      end
      detailsValid = 1;  % This might be replaced with fn. checking validity.
    % DO NOT WRITE THIS DATA TO DISK FROM THIS FUNCTION !!
    end
else % i.e. if battery file exists, just load the existing relevant data
    load(batLogFileName);
    experimentParams.age = battery.age;
    experimentParams.sex = battery.sex;
    
end % of function basicPtDetails

