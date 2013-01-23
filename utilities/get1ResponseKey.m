function [keyA, keymap] = get1ResponseKey(param, respKeyName, debug)
% function [keyA, keymap] = get1ResponseKey(param, respKeyName, debug)
% interogates the user for just one action key. It assumes cogent has been started and 
% that input structure argument param has a member param.context which, if 1,
% indicates that we are using a keyboard like the ones on the NSPN
% Dell_Latitude. Valid respKeyName values for context Dell_Latitude are: 
% ''RETURN'',''SPACE'',''UP_ARROW'',''LEFT_ARROW'',''RIGHT_ARROW'',''DOWN_ARROW'''

keymap = getkeymap;

if ~debug
    
  settextstyle('Arial narrow', 26);
  % cgfont('Helvetica',20);
  
  if (param.context == 1) % i.e. Dell Latitude context
    reps = 0; % [0 0 0];
  
    while reps == 0 % sum(reps) ~= 3
        cgtext('We now need to double-check which button you will use for responding.',0,30);
 
        for i = 1:2
            if i==1
              cgtext(['Please press the ',respKeyName,' key:'],0,0);  
            else
             cgtext(['Please press the ',respKeyName,' key once more:'],0,0);  
            end
            cgflip(0,0,0);
            [ky tim rp] = waitkeydown(inf);
            ky1(i) = ky(1);
        
            % cgtext('please press key for ... :',0,0);
            % cgflip(0,0,0);
            % [ky tim rp] = waitkeydown(inf);
            % ky2(i) = ky(1);

            % cgtext('please press key for asking for another fish (or generally moving on):',0,0);
            % cgflip(0,0,0);
            % [ky tim rp] = waitkeydown(inf);
            % ky3(i) = ky(1);
      end
      reps = (ky1(1)==ky1(2) && ky1(1)==keyCode(respKeyName,param.context)); 
      % for 3 keys: reps = [ky1(1)==ky1(2) ky2(1)==ky2(2)  ky3(1)==ky3(2)];
    end
  else % Context not yet coded for
      error('get1ResponseKey not ready for this param.context')
  end
    
  keyA = ky1(1);
  %keyB = ky2(1);
  %keyC = ky3(1);
  disp([' Key obtained for responding: ' num2str(keyA)]);
  
else % if debug is not 0, just assign some values:
  keyA = 19;
  %keyB = 15;
  %nextKey   = 14;
  disp([' Key  FIXED for responding: ' num2str(keyA)]);
end 

%disp(['              for orange: ' num2str(keyB)]);
%disp(['       and for next/more: ' num2str(keyC)]);

%% ************************* End of function *******************************
end
%%
