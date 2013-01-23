function [outParams] = sibsBatTaskOrder(inParams)
% function [outParams] = cogBAtTaskOrder(inParams) 
% Simply furnishes a task order according a randomization scheme
% provided in inParams.

outParams = inParams;
nRandOrd  = 4; % How many different orders to choose from.

% Reminder: codes are as  below, so that fishes is 1, GNG1 is 2 etc. :
% nspn1par.labels =  {'Gender (F=0,M=1)','Age (y)','Fee for today','Fee for later','Later fee delay (days)'...
%         '1. fishes / JTC','2. GNG1 / Go-NoGo','3. trust / Investor-Trustee',...
%         '4. DID / Self-Other',...
%         '5. TST / Two-step-task',...
%         '6. MVS / Mean-Variance-Skewness'...
%         '7. predator / human avoidance'};

if inParams.taskNum == 3
  if inParams.codeTesting ~= 0
    outParams.taskOrder = [8,6,5]; % GNG0, MVS, 2ST
  else
    randF = rand(1);
    if randF < 1.0/4; outParams.taskOrder     = [5,6,8];
    elseif randF < 2.0/4; outParams.taskOrder = [8,6,5];
    elseif randF < 3.0/4; outParams.taskOrder = [6,8,5];
    elseif randF < 4.0/4; outParams.taskOrder = [8,5,6];
    else
      error(['Option error in cogBatTaskOrder with taskNum=3; Back to debugging ...']);
    end
  end 
else if inParams.taskNum == 5
  if inParams.codeTesting ~= 0
    outParams.taskOrder = [8,6,5,4,7]; % GNGb0, ...
  else
    randF = rand(1);
    if randF < 1.0/nRandOrd; outParams.taskOrder     = [7,4,5,6,8];
    elseif randF < 2.0/nRandOrd; outParams.taskOrder = [8,6,5,4,7];
    elseif randF < 3.0/nRandOrd; outParams.taskOrder = [6,8,7,4,5];
    elseif randF < 4.0/nRandOrd; outParams.taskOrder = [5,4,7,8,6]; 
    else
      error(['Option error in cogBatTaskOrder with taskNum=5; Back to debugging ...']);
    end
  end 
elseif inParams.taskNum == 7
  if inParams.codeTesting ~= 0
    outParams.taskOrder = [3,2,6,1,5,4,7]; % trust, GNG1, ...
  else
    randF = rand(1);
    if randF < 1.0/nRandOrd; outParams.taskOrder     = [7,4,5,1,6,2,3];
    elseif randF < 2.0/nRandOrd; outParams.taskOrder = [3,2,6,1,5,4,7];
    elseif randF < 3.0/nRandOrd; outParams.taskOrder = [1,6,3,2,7,4,5];
    elseif randF < 4.0/nRandOrd; outParams.taskOrder = [5,4,7,2,3,6,1]; 
    else
      error(['Option error in cogBatTaskOrder with taskNum=7; Back to debugging ...']);
    end
  end 
else
  error(['Error in cogBatTaskOrder: not ready for taskNum given. Back to debugging ...']);
end
  

 
% $$$ So 'rational' base sequence, is:
% $$$ 1.  Predator
% $$$ 2.  Delegated Intertemporal
% $$$ 3.  Two-step
% $$$ [4.  fishes (JTC) ]
% $$$ 5.  Mean-Variance-Skewness
% $$$ 6.  Go-NoGo
% $$$ [7.  Trust        ]
% $$$ 
% $$$ So we could have 123 4567, 7654 321, 4576 123 and 321 6754 

%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
end % whole function cogBatTaskOrder
  
