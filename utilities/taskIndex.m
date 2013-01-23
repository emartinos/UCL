function tInd = taskIndex(taskNameFragment)
% function index = taskIndex(taskNameFragment)
% return a simple numerical index for each task, based on an acronym etc.
% that the task uses to identify itself with. Mainly for NSPN use,
% but could add indices for Attachment versions etc.

switch taskNameFragment
 case 'fishes'
  tInd = 1;
 case 'GNG1'
  tInd = 2;
 case 'trust'
  tInd = 3;
 case 'DID'
  tInd = 4;
 case 'TST'
  tInd = 5;
 case 'MVS'
  tInd = 6;
 case 'predator'
  tInd = 7;
 case 'trainedGNG'
  tInd = 8;
 otherwise
  error(['Not ready for task ', taskNameFragment,' in taskIndex; Back to debugging ...']);
end
  

end %% of whole function