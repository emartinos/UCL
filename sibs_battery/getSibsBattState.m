function [tasksDone, currTask, outParams] = getSibsBattState(params)
% If top-level file for the behavioural battery for this participant
% doesn't exist, create it. If it does, read which is the next task to
% start and return it as currTask.

outParams = params;               % copy for modification & output
batLogFileName = [params.data_dir,'\',params.ptCode,'_batteryLog.mat'];
batLogCSVFName = [params.zip_dir,'\',params.ptCode,'_batteryLog.csv'];
tasksDone = 0;
clear battery; % We'll either construct this or read it from file - so wipe clean.

if exist(batLogFileName)==0 % if we haven't started with this participant yet
    % Present participant with the basic instructions (no choices to be made here):
    sibsBattInstructions(params,0);

    %% copy some bits to save to file:
    battery.labels = params.labels;
    battery.taskOrder  = params.taskOrder;
    battery.TasksCompleted = 0;
    % Convert gender words beginning from 'm' or 'M' to 1, otherwise assume female: 
    numGend = ( strcmp(params.sex(1),'m') ||  strcmp(params.sex(1),'M'));
    battery.gender = numGend;
    battery.age = params.age;
    battery.earnings = params.fee; % first time round this should be the flat fee 
    battery.score = zeros(1,params.taskNum); % Will record overall, scalar score for each task.
    
    % We will need to write both a mat file to disk and a csv file for easy ref:
    save(batLogFileName,'battery');         % mat (hdf5) file
    txtLogFID = fopen(batLogCSVFName,'w');  % text / csv file.
    fprintf(txtLogFID,'\"%s\",\"%s\"','Var. or Task:','Val. or Order:'); % column titles

    fprintf(txtLogFID,'\n\"%s\",%d',battery.labels{1},numGend );
    fprintf(txtLogFID,'\n\"%s\",%f',battery.labels{2},params.age );
    fprintf(txtLogFID,'\n\"%s\",%f',battery.labels{3},params.fee{1}(1) );
    for i=4:(3+params.maxTaskNum)  % main rows
        % Weird offets as there are irrelevant bits in labels etc.
        fprintf(txtLogFID,'\n\"%s\",%d',...
                battery.labels{i+2}, orderPlayed( (i-3), params ) );
    end
    fclose(txtLogFID);
else % i.e. if battery file exists, just load the order already decided and how far we've got.
    load(batLogFileName);
    tasksDone = battery.TasksCompleted;
    outParams.taskOrder = battery.taskOrder;
    
    % Present participant with welcome-back instructions (can choose to skip
    % a task), if we don't already know we're going for the next task:
    if params.exp_flow ~= 'n'
      skip = sibsBattInstructions(params,0);
      if skip ~= 0  % If the experimenter has decided to skip the task at hand
        % First advance the tasksDone index, needed separately for what the fn. returns:
        tasksDone = tasksDone + 1; 
        % Now update the battery log file:
        battery.TasksCompleted = tasksDone; 
        battery.score(battery.taskOrder(battery.TasksCompleted)) = 0;
        save(batLogFileName,'battery');
        % Now save a 'dummy data' file for the skipped task, with a warning:
        skippedTaskName = params.nFrag{outParams.taskOrder(tasksDone)}; 
        skippedFName = [params.data_dir,params.ptCode,'_',skippedTaskName,'_OMITTED.mat'];
        warning = [skippedTaskName,' was deliberately skipped on ', datestr(now)]
        save(skippedFName,'warning');  
      end % if skip ...
    end % if params.exp_flow
    
end

if tasksDone >= params.taskNum
    currTask = -1; % This is a code not to do any tasks in this battery !
else
    currTask = battery.taskOrder(tasksDone + 1);
end

outParams.fee = battery.earnings; % Earnings so far - battery.earnings must be set or read off file by now.

end %% Of whole function