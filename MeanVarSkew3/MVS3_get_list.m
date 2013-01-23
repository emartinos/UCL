function [SKEW_list, JITTER] = MVS3_get_list(paramset, PARAMETERS)
% MVS3_get_list(paramset, PARAMETERS) used in MVS3.m, section 
% GENERATE LIST / GET LIST FROM FILE.

    LIST = MVS3_generatestimuluslists(PARAMETERS.number_of_blocks, PARAMETERS.trials_per_block, PARAMETERS.sure_amounts, paramset);

    if PARAMETERS.run_numbers>1
      runsize = size(LIST,1)./PARAMETERS.run_numbers;
      if rem(size(LIST,1),runsize) ~=0
          fprintf('Error - number of trials not divisible by number of runs')
          return
      else    
          for rn = 1:PARAMETERS.run_numbers
             SKEW_list(:,:,rn) = LIST(runsize*(rn-1)+1:runsize*rn,:);
             JITTER(:, rn) = (PARAMETERS.TIMINGS.JITTERtimes(runsize*(rn-1)+1:runsize*rn))';
            end
        end
    else
        SKEW_list = LIST;
        JITTER = PARAMETERS.TIMINGS.JITTERtimes;
    end
    
    
