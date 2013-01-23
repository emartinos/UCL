function [SUBJECT, result]  = MVS3_record_subject_details(Code, Age, Sex)
% Adapted from the original SKEW_record_subject_details for use in the NSPN
% project, where only one run of about 15 min is required, and it is of
% only one type (scanning / emulscanning)

% fprintf('Please enter type of run:\n\n');
% runtype_error=1; %error if invalid run type entered
%  SUBJECT.run_type = 'no type recorded';
% while runtype_error
    
    SUBJECT.run_params = 's'; % was: input('Scanning / Behavioural testing / Piloting / Testing? (TYPE s/b/p/t)\n', 's');
    
    switch SUBJECT.run_params
        case 's'
            SUBJECT.run_type = 'experiment; scanning run'; runtype_error=0;
        case 'b'
            SUBJECT.run_type = 'experiment; behavioural run';runtype_error=0;
        case 'p'
            SUBJECT.run_type = 'piloting run';runtype_error=0;
        case 't'
            SUBJECT.run_type = 'test run';runtype_error=0;
        otherwise
            fprintf('Error - invalid entry\n\n\nPlease enter run type:\n\n');
    end
    
% end %of while runtype_error loop

%% store results file
%store the subject number in subject.code and include in file name
%if no number entered then return as default 'testoutput' as name of output
%.txt and .mat files

runtype_error=1;
result.filename2 = 'testoutput.mat';

while runtype_error             %while loop that prevents overwriting of previous data
    
    %originally: SUBJECT.number = input ('Subject number: ', 's');
    SUBJECT.code = Code;
    
    if exist([SUBJECT.code,'_MVS3.txt'])~=0 ||  exist([SUBJECT.code,'_MVS3.mat'])~=0     %if a filename with the same number already exists, do not proceed
        disp('file for this subject exists already!')
    elseif isempty(SUBJECT.code) %if no entry, then default data file is called ATR1_TEST
        result.filename2 = 'MVS3_TEST.mat';
        runtype_error=0;
    elseif ~isempty (SUBJECT.code)                    %if subject number is new, then create new results file
        result.filename2 = strcat (SUBJECT.code,'_MVS3');
        runtype_error=0;
    end
end         %end of while loop for subject entry

disp (['Result files:   ',   result.filename2]); %display filename

%% store gender
errorcode=1; %error if incorrect entry, N/A if no entry
while errorcode
    % originally: SUBJECT.gender = input ('Subject Gender? (m/f):  ', 's');
    SUBJECT.gender = Sex;
    
    if isempty (SUBJECT.gender)
        SUBJECT.gender = 'NA';
        errorcode=0;
    elseif ~(strcmpi(SUBJECT.gender, 'm') | strcmpi(SUBJECT.gender, 'f'))
        disp('Invalid Gender entry in MVS3_record_subject_details')
    else
        errorcode=0;
    end
end

%% store age
errorcode=1;
while errorcode
    
    % originally: SUBJECT.age = input ('Subject Age: ');
    SUBJECT.age = Age;
    
    if isempty (SUBJECT.age)
        SUBJECT.age = 'NA';
        errorcode=0;
        
    elseif ~isnumeric(SUBJECT.age)
        disp('Invalid Age entry in MVS3_record_subject_details')
    else
        errorcode=0;
    end
end

SUBJECT;
result;

