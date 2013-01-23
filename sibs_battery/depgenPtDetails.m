function experimentParams = depgenPtDetails( params )
% function experimentParams = reditPtDetails( params ) updates the ID string,
% age and gender for the current participant if necessary.
% INTENTIONALLY DOES NOT WRITE THE UPDATED DATA TO DISK.

experimentParams = params;
batLogFileName = [params.data_dir,'\',params.ptCode,'_batteryLog.mat'];
detailsValid = 0; % This isn't used seriously as yet, but the rudiments of a loop
                  % to use it are included below.

if exist(batLogFileName,'file')==0 % if we haven't started with this participant yet
    while detailsValid == 0
        ageStr  = input(  '               age (y): ', 's');  % holding variable
        experimentParams.age = str2double(ageStr);           % stored parameter.
        experimentParams.sex =input(  '          gender (m/f): ', 's'); 
        experimentParams.sex = experimentParams.sex(1); % Retain just initial.
        detailsValid = 1;  % This might be replaced with fn. checking validity.
    end
    % DO NOT WRITE THIS DATA TO DISK FROM THIS FUNCTION !!
else % i.e. if battery file exists, just load the existing relevant data
    load(batLogFileName);
    experimentParams.age = battery.age;
    experimentParams.sex = battery.sex;
    
end % of function basicPtDetails

