function [computersetup, data_directory] = MVS3_set_data_directory(datadir, ask)
% function [computersetup, data_directory] = MVS3_set_data_directory(datadir,ask)
%skew_data directory for use by skewness master program MVS3 etc.
% Pass ask ~= 0 for this function to ask the user for various codes etc.
%M Symmonds 23-6-9, adapted for NSPN use by Michael Moutoussis


if ask ~= 0

    computersetup = input('What computer is this being run on (laptop/desktop/testing room/Allegra)? \n[Answer ''l'', ''d'', ''t1'', ''t2'',''al'']\n\n>>  ','s');   
    % If calling function / user so wishes, change directory to where to where data
    % will be written
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
    end % end of switch if code is given.

else % if user indicates that they have given directory explicitly.
    data_directory = [datadir];
    computersetup =  [datadir];  % full path hints at which computer etc !
end
