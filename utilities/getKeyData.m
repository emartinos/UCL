function [ keyData, dataFiles ] = getKeyData( taskNameFrag, workDir, debug)
% function [ keyData, dataFiles ] = getKeyData( taskNameFrag, workDir, debug)
%  Use a string denoting the task in question, taskNameFrag, to retreive a
%  list of zip files from the workDir (or the pwd), unzip them in a temporary directory,
%  extract a vector of keyData for each (one zip file is assumed to
%  corresp. to one participant), store in an R-formated csv file taskNameFrag_keyData_time.csv 
%  and return as a matlab-formatted array keyData and a list of the files summarized.

%% ~~~~~~~~~~~~~ Default Arguments ~~~~~~~~~~~~~~~~~~~~~~
if nargin < 3    debug = 1;  end;

if nargin < 2
    % cwd = pwd;
    %cwd = 'C:\Users\Michael\sci\DevCompPsych_local\redit_pilot_work\pilot_data';
    %cwd = [getenv('HOMEDRIVE') getenv('HOMEPATH') '\Dropbox\temp\'] ;
    cwd = '/home/michael/Dropbox/temp/';
else
    cwd = workDir;
end
if nargin < 1
    taskNameFrag = 'predator';
end
tScale = 0.001; % matlab/cogent time in ms, this to convert to sec
%% ~~~~~~ Set up file list from which data to be extracted, ~~~~~~~~~~~~~~
%  ~~~~~~  and make sure the coast is clear for unzipping files  ~~~~~~~~~
start_dir = pwd;  
cd(cwd);
zipWild = ['*' taskNameFrag '*.zip'];      % file list for data extraction
zipFileList = ls(zipWild);
if strcmp(zipFileList,'')
    error(['aborted because no *',taskNameFrag,'*.zip files found']);
end
  
tempUnzip = [cwd,'tempDir'];   % Temporary working directory
if exist(tempUnzip,'dir')
    error('aborted because temporary working directory tempUnzip already exists');
end

%% ** find files to be processed and loop through them, extracting key data **
zipFNum = size(zipFileList,1);
for i = 1:zipFNum           % Unzip the data files we found one by one in a loop
    mkdir(tempUnzip);
    unzip([cwd,zipFileList(i,:)],tempUnzip);
    
    switch taskNameFrag
        case 'GNG0'
        %% Instructed Go-NoGo
            % currZipFNLen =  size(zipFileList(i,:),2); % for use with case label below
            % caseLabel = zipFileList(i,1:currZipFNLen-6); %  '-6' won't work consistently as it includes
            % padding spaces that ls() uses to make char array ...
            outpFName = [cwd '\KeyGNG0_'  datestr(now,'yyyymmddHHMM') '.csv'];
            csvFID = fopen(outpFName,'a');  % text / csv file.
            if i == 1  % First file to be summarized
                labels = ['"datafile","G2W fract. corr.","G2AP fract. corr.","NG2W fract. corr.","NG2AP fract. corr."'];
                fprintf(csvFID,'%s',labels); % column titles
            end
            % Now load data from final data file of interest - this should 
            % be the only *InstructedData.mat file unzipped in tempUnzip :
            currFName = ls ([tempUnzip,'\*InstructedData.mat']); % without the path
            currFName = [tempUnzip, '\', currFName];
            load(currFName); % This just read the matrix InstructedData from currFName          
            trialN = size(InstructedData,1);
            tally = zeros(2,4); % We'll sum up the correct responses of each trial here
            for j=1:trialN % for every trial in the data recorded in InstuctedData
                trType = InstructedData(j,2);
                tally(2,trType) = tally(2,trType) + 1.0;
                if (((trType < 2.5) && (InstructedData(j,13) == 1)) ... % if emitted go response in go trial ...
                    || ((trType > 2.5) && (InstructedData(j,13) == 0))) % or emitted NoGo response in NoGo trial
                        tally(1,trType) = tally(1,trType) + 1;
                end  % end search whether response was correct etc.
            end % end loop over trials
            % Now sum up:
            G2W  = tally(1,1)/tally(2,1);   G2AP  = tally(1,2)/tally(2,2);
            NG2W = tally(1,3)/tally(2,3);   NG2AP = tally(1,4)/tally(2,4);
            % Finally, write a line to key data:
            fprintf(csvFID,'\n"%s",%.3f,%.3f,%.3f,%.3f',... % %d,%d,%d,%d',...
                zipFileList(i,:),G2W,G2AP,NG2W,NG2AP);      % ,tally(2,1),tally(2,2),tally(2,3),tally(2,4));
            fclose(csvFID);
            
            keyData(i,:) = [G2W,G2AP,NG2W,NG2AP];
            dataFiles(i,:) = zipFileList(i,:);

        case 'GNG2'
        %% Attachment Go-Nogo
            outpFName = [cwd '\KeyGNG2_'  datestr(now,'yyyymmddHHMM') '.csv'];
            csvFID = fopen(outpFName,'a');  % text / csv file.
            if i == 1  % First file to be summarized
                labels = ['"datafile","attNG2W ea.fr.cor.","attG2AP ea.fr.cor.","nonAttNG2W ea.fr.cor.","nonAttG2AP ea.fr.cor.","attNG2W lt.fr.cor.","attG2AP lt.fr.cor.","nonAttNG2W lt.fr.cor.","nonAttG2AP lt.fr.cor.","attNG2W tot.fr.cor.","attG2AP tot.fr.cor.","nonAttNG2W tot.fr.cor.","nonAttG2AP tot.fr.cor."'];
                fprintf(csvFID,'%s',labels); % column titles
            end
            % Now load data from final data file of interest - this should 
            % be the only *InstructedData.mat file unzipped in tempUnzip :
            currFName = ls ([tempUnzip,'\*AttachLearnData.mat']); % without the path
            currFName = [tempUnzip, '\', currFName];
            load(currFName); % This just read the matrix InstructedData from currFName          
            trialN = size(AttachLearnData,1);
            tally = zeros(4,4); % We'll sum up the responses of each trial
            % row 1: weighed-early correct responses fraction; 
            % row 2: weighed-late  correct responses fraction;
            % row 3: total correct response fraction;
            % row 4: total response number.
            for j=1:trialN % for every trial in the data recorded in InstuctedData
                trType = AttachLearnData(j,2);
                tally(4,trType) = tally(4,trType) + 1.0;
            end
            scaleN = tally(4,:); 
            for j=1:4; scaleN(j) = round(( scaleN(j) - 1)/2.0); end;
            for j=1:4; earlyWt{j}= zeros(1,tally(4,j)); end; % Vectors for early-weighed fractions
            for j=1:4; lateWt{j} = zeros(1,tally(4,j)); end; % Vectors for late-weighed fractions
            for j=1:4
                for k=1:tally(4,j) % loop for un-'normalized' early wt. vector.
                    earlyWt{j}(k) = max(0, scaleN(j)-k+1);
                end % End loop setting un-'normalized' early weight vector.
                earlyWt{j} =  earlyWt{j}/ sum(earlyWt{j}); % 'normalize'
                % In the first instance the late-wt vector is just the mirror-symmetric early one:
                for k=1:tally(4,j) lateWt{j}(k)= earlyWt{j}(tally(4,j)-k+1); end      
            end % end loop over the four types of trials (attNG2W,attG2AP, ...)
            
            %% Now to accumulated the weighed fractions of right responses:
            count = zeros(1,4); % to keep track of where we are w.r.t. each type of trial
            for j=1:trialN % for every trial in the data recorded in AttachLearnData, accumulate
                           % the three summary measures:
                trType = AttachLearnData(j,2);
                count(trType) = count(trType)+1; 
                if ((~mod(trType,2) && (AttachLearnData(j,13) == 1)) ... % Go trials are type 2 and 4 ...
                    || (mod(trType,2) && (AttachLearnData(j,13) == 0))) % or emitted NoGo response in NoGo trial
                    tally(1,trType) = tally(1,trType) + 1.0*earlyWt{trType}( count(trType) );
                    tally(2,trType) = tally(2,trType) + 1.0* lateWt{trType}( count(trType) );
                    tally(3,trType) = tally(3,trType) + 1.0/ tally(4,trType) ;
                end  % end search whether response was correct etc.
            end % end loop over trials

            % Finally, write a line to key data:
            fprintf(csvFID,'\n"%s",%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f',...
                zipFileList(i,:),tally(1,1),tally(1,2),tally(1,3),tally(1,4),...
                                 tally(2,1),tally(2,2),tally(2,3),tally(2,4),...
                                 tally(3,1),tally(3,2),tally(3,3),tally(3,4));   
            fclose(csvFID);
            
            keyData(i,:) = [ tally(1,1),tally(1,2),tally(1,3),tally(1,4),...
                             tally(2,1),tally(2,2),tally(2,3),tally(2,4),...
                             tally(3,1),tally(3,2),tally(3,3),tally(3,4)    ] ; 
            dataFiles(i,:) = zipFileList(i,:);
            
     case 'predator'
     %% Bach Approach-Avoidance 'Predator' task
            outpFName = [cwd,'KeyPred_'  datestr(now,'yyyymmddHHMM') '.csv']; %cwd left in on purpose.
            cd(tempUnzip);
            csvFID = fopen(outpFName,'a');  % text / csv file.
            if i == 1  % First file to be summarized
                labels = ['"datafile","pr1dare ea.p.s","pr1tok ea.p.g","pr1dare lt.p.s","pr1tok lt.p.g","pr1dare tot.p.s","pr1tok tot.p.g","pr2dare ea.p.s","pr2tok ea.p.g","pr2dare lt.p.s","pr2tok lt.p.g","pr2dare tot.p.s","pr2tok tot.p.g","totTok_p_g"'];
                fprintf(csvFID,'%s',labels); % column titles
            end            
            % Now load data from final data file of interest - this should 
            % be the only *InstructedData.mat file unzipped in tempUnzip :
            currFName = ls ('*_predator_*.mat'); % without the path
            % currFName = [tempUnzip, '/', currFName];
            load(currFName); % This just read the data structure from currFName   
            
            blocksToDo = size(game,2) - 1; % Exclude very last block, which is self-chosen.
            for j=1:blocksToDo  % Calculate vector with all the total trial numbers in each block
              totTrN(j)=size(game{1,j},2);
              predN(j)=header.blk(1,j).predator_number; % How many predators used in each block
            end
            maxPredN = max(predN); % Usually trivial, just the num. of predators used throughout.
            predTrN = zeros(1,maxPredN); % To accumulate N of trials where each predator has been involved.
            % Now construct array of indices predInd(blk_game,pred,predTrInd) so that
            % predInd(1,2,3) is 2-> the game (1 would be the block) for 1-> predator1, 
            % ...        3-> We want to find [which block] 3rd trial of pred. 1 is in.
            for blockInd = 1:blocksToDo
              for gameInd = 1:totTrN(blockInd)
                thisPred = game{1,blockInd}{1,gameInd}.predator;
                predTrN(thisPred) = predTrN(thisPred) + 1;               
                predInd(:,thisPred,predTrN(thisPred)) = [blockInd, gameInd];
              end
            end         
            % Now find the trial duration (in sec) that each predator has been played:
            for pred = 1:maxPredN
              for tr = 1:predTrN(pred)
                blk  = predInd(1,pred,tr);   gm = predInd(2,pred,tr);
                predTrDur(pred,tr)= tScale * ...
                                    (max([states{1,blk}{1,gm}.lastcomputer, states{1,blk}{1,gm}.lasthuman]) ...
                                  - game{1,blk}{1,gm}.loopstart) ;
              end % loop over trials
            end % loop over predators.
            if debug ~= 0
              for k=1:2  
                for j=1:predTrN(1); pred1Ind(k,j) = predInd(k,1,j);   end
                for j=1:predTrN(2); pred2Ind(k,j) = predInd(k,2,j);   end
              end
              csvwrite('../pred1Ind.csv',pred1Ind); csvwrite('../pred2Ind.csv',pred2Ind);
            end
            
            tally = zeros(maxPredN,6); % We'll sum up the responses of each trial
            % row 1: for pred1, weighed-early risky_moves per sec; weighed-early tokens per game; wt-late rm.p.s; wt-late tk.p.g.; overall rm.p.s.; overall tk.p.s.
            % row 2: for pred2, the same.
            if debug ~= 0
              for j=1:maxPredN; scaleN(j) = 3;  end; % 3 for debug
            else
              for j=1:maxPredN; scaleN(j) = 10; end; % 10 for real ?
            end
              
            for j=1:maxPredN  % Construct weight vectors for each predator type
              earlyWt{j}= zeros(1,predTrN(j)); % Vectors for early-weighed fractions
              lateWt{j}= zeros(1,predTrN(j));  % Vectors for late-weighed fractions
                for k=1:predTrN(j) % loop for un-'normalized' early wt. vector.
                    earlyWt{j}(k) = max(0, scaleN(j)-k+1);
                end % End loop setting un-'normalized' early weight vector.
                earlyWt{j} =  earlyWt{j}/ sum(earlyWt{j}); % 'normalize'
                % In the first instance the late-wt vector is for just a straightforward average 
                % of the last 2*scaleN(j) trials:
                for k=1:2*scaleN(j); lateWt{j}(predTrN(j)-k+1) = 0.5/scaleN(j); end 
            end % end loop over the four types of trials (pr1dare,pr1tok, ...)
            
            if debug ~=0 
              for j=1:maxPredN
                csvwrite(['../earlyWt' num2str(j) '.csv'],earlyWt{j});
                csvwrite(['../lateWt' num2str(j) '.csv'],lateWt{j});
              end
            end         
            
            
            %% Now to accumulated the weighed fractions of right responses
            for pred=1:maxPredN
              tDenomEarly=0; tDenomLate=0; tDenomTotal=0; % to be reused ..
              %
              for tr=1:predTrN(pred)
                % block and game coordinates for this trial:
                blk  = predInd(1,pred,tr);   gm = predInd(2,pred,tr);  
                %
                % Accumulate early, late and overall number of tokens per trial:
                tally(pred,2) = tally(pred,2)+ tokencredit{1,blk}(gm)*earlyWt{pred}(tr);
                tally(pred,4) = tally(pred,4)+ tokencredit{1,blk}(gm)* lateWt{pred}(tr);
                tally(pred,6) = tally(pred,6)+ tokencredit{1,blk}(gm)/predTrN(pred);
                %
                % Now number of stage-weighed 'risky' moves 
                % First note safe posn. and number of time steps in this trial:
                safePos = [game{1,blk}{1,gm}.safeposition(1),  game{1,blk}{1,gm}.safeposition(2)];
                trStepN = size(position_matrix{1,blk}{1,gm},1);
                riskStepN = 0; % initialize num. of risky steps, i.e. away from safe place
                for t=1:(trStepN-1)
                  initPos = [position_matrix{1,blk}{1,gm}(t,  3), position_matrix{1,blk}{1,gm}(t,  4)];
                  finalPos= [position_matrix{1,blk}{1,gm}(t+1,3), position_matrix{1,blk}{1,gm}(t+1,4)];
                  % for a vector v, norm(v,p) returns the p-norm of v. The p-norm is sum(abs(v).^p)^(1/p).
                  if norm(finalPos-safePos,2) > norm(initPos-safePos,2)
                     riskStepN = riskStepN +1;
                  end % end if agent has moved further away from safety position, augment riskStepN.
                end % end loop over all time steps when spatial step could be taken.
                if debug ~= 0;  RM(pred,tr) = riskStepN; end
                % Now accumulate risky moves:
                tally(pred,1) = tally(pred,1)+ riskStepN * earlyWt{pred}(tr);
                tally(pred,3) = tally(pred,3)+ riskStepN * lateWt{pred}(tr);
                tally(pred,5) = tally(pred,5)+ riskStepN / predTrN(pred);
                % 
                % Finally accumulate the weighted time intervals, for calc. of rates
                tDenomEarly = tDenomEarly + predTrDur(pred,tr)*earlyWt{pred}(tr);
                tDenomLate  = tDenomLate  + predTrDur(pred,tr)* lateWt{pred}(tr);
                tDenomTotal = tDenomTotal + predTrDur(pred,tr)/predTrN(pred);
                   
              end % of loop over trials for this type of predator
              if debug ~= 0
                csvwrite('../predTrDur.csv',predTrDur);
                csvwrite('../risky_moves.csv',RM);
              end
              
              %
              % Now do the time-weighing:
              tally(pred,1) =  tally(pred,1) / tDenomEarly;
              tally(pred,3) =  tally(pred,3) / tDenomLate;
              tally(pred,5) =  tally(pred,5) / tDenomTotal;
              
            end % of loop over predators.
            
            % Quickly calculate overall tokens-per-game for all trials:
            totTok_p_g = 0; 
            for j=1:blocksToDo
              totTok_p_g = totTok_p_g + sum(tokencredit{j}) / sum(totTrN);
            end
            
            % Finally, write a line to key data:
            fprintf(csvFID,'\n"%s",%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f',...
                zipFileList(i,:),tally(1,1),tally(1,2),tally(1,3),tally(1,4),tally(1,5),tally(1,6), ...
                                 tally(2,1),tally(2,2),tally(2,3),tally(2,4),tally(2,5),tally(2,6), ...
                                 totTok_p_g );   
            fclose(csvFID);
            
            keyData(i,:) = [ tally(1,1),tally(1,2),tally(1,3),tally(1,4),tally(1,5),tally(1,6), ...
                             tally(2,1),tally(2,2),tally(2,3),tally(2,4),tally(2,5),tally(2,6), ...
                             totTok_p_g ] ; 
            dataFiles(i,:) = zipFileList(i,:);
            cd(cwd); % We were in the temporary dir. so far, which will be deleted outside this loop.
        otherwise
           error('Not ready for this type of task / key data extraction');
    end
    
    rmdir(tempUnzip,'s'); % Destroy it (we've already checked it wasn't there before this fn. was used!)
end
%%

%% Tidy up
cd(start_dir); % go back to where we came from !
end % End of function getKeyData

