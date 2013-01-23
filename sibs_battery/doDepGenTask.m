function [outParams, points] = doDepGenTask(task_index, params)
% function doTask(task_index, dataDir, code, age, sex) calls one of the
% battery tasks. task_index <=0 reserved for various flags, e.g.
% task_index=-1 means 'don't attempt do any tasks'. 
% Also calls accessory functions to convert points won to fee money.

% If this file is edited make sure the labels in getBehBattState
% are corrected.

% Before attempting a new task, make sure java heap space is freed up by calling 
% java garbage collector. Matlab won't do this automatically, and will run out 
% of memory:
java.lang.Runtime.getRuntime.gc;
gain = 0.0; points=0.0;
outParams = params;         % copy to work upon and return in the end. 
debug = params.codeTesting; % Change this to 1 for (very) short versions

switch task_index %% * * make choice and store fee for separate tasks * * * * 
  
 case -1  % This is code for 'don't do any tasks' !
  disp('function doTask called with argument signifying no task needs to be done');
  return;    
  
 case taskIndex('fishes')  % JTC task. 2 x 10 trials will take 10 min or so.
  points =  fishes(params.data_dir, params.ptCode, params.fishes_dir,debug); 
  outParams.fee{2}( task_index ) =  pieceLin1(points, params.fish_x, params.fish_y);
 
 case taskIndex('GNG1')  % Go-NoGo - this is a learning version, in subdir GNG1_RewPun_fMRI.
         % c.NperCond = 16 trials per block in GNG1 gives ~ 17 min duration overall.
  points = GNG1( params.ptCode, params.data_dir, params.goNoGo_dir,debug);
  outParams.fee{2}( task_index ) =  pieceLin1(points, params.gng1x, params.gng1y);   
 
 case taskIndex('trust')  % Trust game; 10 rounds take less than 15 min. usually.
  points = trusting(params.data_dir, params.ptCode, params.trust_dir,debug);
  outParams.fee{2}( task_index ) = pieceLin1(points, params.trust_x, params.trust_y);
 
 case taskIndex('DID')  % Delegated Intertemporal, or Self-Other-Self task. 25 Min or so.
  % rem in the case of DID3 the 'points' also contains code of time chosen for the points won: 
  points = DID3(params.data_dir, params.ptCode, params.age, params.sex, params.DID_dir,debug);
  outParams = nspn_points_to_money(points, params, debug );
 
 case taskIndex('TST')  % Two-step, or habit-planning, task.
  points =  TST(params.data_dir, params.ptCode, params.TS_dir,debug);
  outParams.fee{2}( task_index ) = pieceLin1(points, params.TST_x, params.TST_y);  
  
 case taskIndex('MVS') % Mean-variance(-skewness) task. Use 4 blocks of 20 trials to get near to 
        % or just under the mean allowed time of 23 min per task.
        % Last argument loads specific parameter set - NO SCANNER EMULATION
        % IN VERSION MSV3b (pure behavioural) used here !
  MVS_param_set = 6; % Parameters set for behavioural testing for MVS3
  if  params.codeTesting ~= 0; MVS_param_set = 5; end;
  MVS3_earnings_array = MVS3b(params.data_dir, params.ptCode, params.age, params.sex, MVS_param_set);
  points = sum( MVS3_earnings_array(:,1) ); % This is same as overall earnings.
  outParams.fee{2}( task_index ) = MVS3_nspn_payment( MVS3_earnings_array, params.MVSmin, params.MVSmax); 
 
 case taskIndex('predator')  % Predator / human avoidance task:
  points=  AEC3_1_6_6(params.data_dir, params.ptCode, params.age, params.sex, params.AEC_dir,debug);
  outParams.fee{2}( task_index ) = pieceLin1(points, params.pred_x, params.pred_y);
 
 case taskIndex('trainedGNG') % Go-NoGo preceded by instructions and training :
     % c.NperCond = 18 trials per block in the main task gives ~ 22 min duration overall.
  GNGb0_full_training( params.ptCode, params.data_dir, params.goNoGo_dir,debug);
  points = GNGb0_trained( params.ptCode, params.data_dir, params.goNoGo_dir,debug);
  outParams.fee{2}( task_index ) = pieceLin1(points, params.gng1x, params.gng1y);
     
 otherwise
  error(['Not ready for task_index ',num2str(task_index),' in doTask; Back to debugging ...']);
  
  
end  % of switch statement

%% * * * * * * * * * * Now update the main payment (of today): * * * * * * * * * * * *
if task_index ~=  taskIndex('DID') % this has separate fee as above 
  outParams.fee{1}(1) = outParams.fee{1}(1) + outParams.fee{2}( task_index );
end


end %% of whole function
