function TST_points_won = TST(dataDir, code, TS_dir,debug)
% main function from which all scripts for the two-step task are ran
% Kindly provided by Peter Smittenaar, edited for Neuroscience in
% Psychiatry project by Michael Moutoussis
%
% Changed via 'debug' argument:
%   In TST_initialize.m :
%      params.task.prac.number_of_trials = 40;  %nathaniel & Peter S had 50 (outside scanner)
%      params.task.test.number_of_trials = 121; %nathaniel & Peter S had 201 (in scanner)
%      params.display_type = 0; % debug edw

%% Default arguments :
if nargin < 4  % if not specified, ask about debugging:
   debug = input('Press 0 for ''normal'' 2-step task, 1 for program (not pt.!) testing: ');
end
if nargin < 3
  TS_dir = [getenv('HOMEDRIVE') getenv('HOMEPATH') '\Dropbox\task_code\TwoStep2'];
end
if nargin < 2
  code    =  ['TST' datestr(now,'yyyymmddHHMM')];
end
if nargin < 1
  dataDir = [getenv('HOMEDRIVE') getenv('HOMEPATH') '\nspn_data\detailed\'];
end


clc
% clear all % In the NSPN version we are no longer at the top level of
            % processing, so 'clear all' is destructive.
clear global params;  % this is the global in this task.
temp_wd = pwd;

TST_initialize(dataDir, code, TS_dir,debug); % Edited for NSPN
ts_prac_instructions; % This doesn't have anything to change for NSPN
TST_practice(dataDir, code, TS_dir); % modified wrt directory navigation
ts_test_instructions;
ts_test;
% This last fn. will also return a copy of no. of play-pounds won:
TST_points_won = TST_close(dataDir, code);

cd(temp_wd);


end % of TST - overall function for two-step task.
