%skew_data directory for use by skewness master
%M Symmonds
%last edited 23-6-9

function [computersetup, data_directory] = SKEW_get_data_directory

computersetup = input('What computer is this being run on (laptop/desktop/testing room/Allegra)? \n[Answer ''l'', ''d'', ''t1'', ''t2'',''al'']\n\n>>  ','s');

%change directory to one where ATR programs are stored, and to where data
%will be written
switch computersetup
    case 'l'
        data_directory = ['C:\Users\Michael\Documents\My Dropbox\temp\matlab'];
    case 'd'
        data_directory = ['\\abba\stimuli\Task_repository\NeuroSciPsychNet\MeanVarSkew3\dataDir'];
    case 't1'
        data_directory = [];
    case 't2'
        data_directory = [];
        
    case 'al'
        data_directory = [];
        
    otherwise   %default directory is to run from the current directory
        data_directory = pwd
end
