function [SUBJECT, result]  = SKEW_record_subject_details

%record type of run - scanning/behavioural/piloting/testing
fprintf('Please enter type of run:\n\n');
runtype_error=1; %error if invalid run type entered
SUBJECT.run_type = 'no type recorded';
while runtype_error
    
    SUBJECT.run_params = input('Scanning / Behavioural testing / Piloting / Testing? (TYPE s/b/p/t)\n', 's');
    
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
    
end %of while loop

%% store results file
%store the subject number in subject.number and include in file name
%if no number entered then return as default 'testoutput' as name of output
%.txt and .mat files

runtype_error=1;
result.filename2 = 'testoutput.mat';

while runtype_error             %while loop that prevents overwriting of previous data
    
    SUBJECT.number = input ('Subject number: ', 's');
    
    if exist(['SKEW_', SUBJECT.number, '.txt'])~=0 |  exist(['SKEW_', SUBJECT.number, '.mat'])~=0     %if a filename with the same number already exists, do not proceed
        disp('file for this subject exists already!')
    elseif isempty(SUBJECT.number) %if no entry, then default data file is called ATR1_TEST
        result.filename2 = 'SKEW_TEST.mat';
        runtype_error=0;
    elseif ~isempty (SUBJECT.number)                    %if subject number is new, then create new results file
        result.filename2 = strcat ('SKEW_', SUBJECT.number);
        runtype_error=0;
    end
end         %end of while loop for subject entry

disp (['Result files:   ',   result.filename2]); %display filename

%% store gender
errorcode=1; %error if incorrect entry, N/A if no entry
while errorcode
    SUBJECT.gender = input ('Subject Gender? (m/f):  ', 's');
    if isempty (SUBJECT.gender)
        SUBJECT.gender = 'NA';
        errorcode=0;
    elseif ~(strcmpi(SUBJECT.gender, 'm') | strcmpi(SUBJECT.gender, 'f'))
        disp('Invalid entry')
    else
        errorcode=0;
    end
end

%% store age
errorcode=1;
while errorcode
    SUBJECT.age = input ('Subject Age: ');
    
    if isempty (SUBJECT.age)
        SUBJECT.age = 'NA';
        errorcode=0;
        
    elseif ~isnumeric(SUBJECT.age)
        disp('Invalid entry')
    else
        errorcode=0;
    end
end

SUBJECT;
result;

