function earning_array = MVS3_earnings(results, stim_array, mvs_params)
% function money = MVS3_nspn_payment(results, stim_array ) summarizes 
% the amounts earned at each block of trials (1st column of earning_array) together
% with what COULD have been the min. and max. amounts earnt in that block
% (col. 2 and 3 of the same). It assumes that the
% max. and min. possible are found in col. 5 to 8 of stim_array (which is
% populated by SKEW_list in MVS3). Correct scaling also assumes that the 'sure amounts'
% are within the range of slice amounts seen in the whole of the respective block.


j=0; 
blockN = 0;
payment = 0.0; 
sliceN = size(stim_array,2) / 2; 

%% First make an array with all the stimuli:
for k=1:size(stim_array,1)
  if stim_array(k,1) >= 0 % This is normally a probability, denoting 
       % a valid stimulus. If it's negative, it's a label of the 
       % 'sure amount' used in a block of trials.
    j=j+1;
    stim(j,:)= stim_array(k,:); 
  else
    blockN = blockN + 1;
  end
end
trNPerBlock = j / blockN ;

%% Now accumulate payments for each block:
for k =1:blockN
  earning_array(k,3) = max( max( stim( 1+(k-1)*trNPerBlock : k*trNPerBlock , sliceN+1 : 2*sliceN) ) );
  earning_array(k,2) = min( min( stim( 1+(k-1)*trNPerBlock : k*trNPerBlock , sliceN+1 : 2*sliceN) ) );
  
  earning_array(k,1) = results.exp_data.numbers(k*(1+trNPerBlock), end);
  
  % Now deal with the possibility (as per Mkael's convention) that the exp_data.numbers end col
  % just read was not an earnings amount per se but a code :

  % If the amount that appears 'earnt' is outside the possibl range, just assume it is an
  % an code and set it to zero:
  if ( earning_array(k,1) < earning_array(k,2) ) ||  ( earning_array(k,1) > earning_array(k,3) )
    earning_array(k,1) = 0; 
    warning([' Amount recoded as earnt in block ',num2str(k),' appears to be a code, so this earning was set to zero']);
  else  % Now check that despite being in the valide range, it coincides with an error code,
        % in which case just issue a warning.
    if (earning_array(k,1) == mvs_params.NullValue) || (earning_array(k,1) == mvs_params.MistakeCode)
      warning([' Amount recoded as earnt in block ',num2str(k),' appears to be a code, but it is within valid range !!']);
    end
  end

end


end %% of whole function