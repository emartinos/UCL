function slicetotals = SKEW_calculate_run_length(PARAMETERS, listout)

nruns = size(listout, 3);

for r = 1:nruns
    
slicetot=PARAMETERS.NUM.dummy*PARAMETERS.NUM.slice+1;
trial_counter = 1;
for u=1:size(listout,1)
    slicetot = slicetot + PARAMETERS.TIMINGS.ISI + PARAMETERS.JITTERtimes(u + (r-1)*size(listout,1)) 
    if listout(u,1)>0
        slicetot = slicetot + PARAMETERS.TIMINGS.stimuluson;
        slicetot = slicetot + (PARAMETERS.TIMINGS.cuetime)./PARAMETERS.TIMINGS.slice;
        
        if isequal(trial_counter/PARAMETERS.trials_per_block, floor(trial_counter/PARAMETERS.trials_per_block))
            slicetot = slicetot + PARAMETERS.TIMINGS.endblock1 +PARAMETERS.TIMINGS.endblock2 + ...
                ((PARAMETERS.TIMINGS.endblock3 + PARAMETERS.TIMINGS.endblock4 +PARAMETERS.TIMINGS.endblock5+PARAMETERS.TIMINGS.T_end)./PARAMETERS.TIMINGS.slice);
        end
        trial_counter = trial_counter +1;
    else
        slicetot = slicetot + PARAMETERS.TIMINGS.surescreen;
    end
end
slicetot = slicetot+(PARAMETERS.NUM.slice*PARAMETERS.NUM.post);

slicetotals(r) = slicetot;
end
