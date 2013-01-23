function [keyA, keymap] = getOneButton(param, buttonName, responseName, debug)
% function [keyA, keymap] = getOneButton(param, buttonName, debug)
% interogates the user for one action key that corresponds to a
% 'responseName' response, e.g. responseName = 'jump left'. 
% It assumes cogent has been started and 
% that input structure argument param has a member param.context which, if 1,
% indicates that we are using a keyboard like the ones on the NSPN
% Dell_Latitude. Valid buttonName values for context Dell_Latitude are: 
% ''RETURN'',''SPACE'',''UP_ARROW'',''LEFT_ARROW'',''RIGHT_ARROW'',''DOWN_ARROW'''

keymap = getkeymap;

if ~debug
    
  settextstyle('Arial narrow', 26);
  % cgfont('Helvetica',20);
  
  if (param.context == 1) % i.e. Dell Latitude context
    reps = 0; % [0 0 0];
  
    while reps == 0 % sum(reps) ~= 3
        cgtext(['We now need to double-check which button you will use to ' responseName],0,30);
 
        for i = 1:2
            if i==1
              cgtext(['Please press the ',buttonName,' key:'],0,0);  
            else
             cgtext(['Please press the ',buttonName,' key once more:'],0,0);  
            end
            cgflip(0,0,0);
            [ky tim rp] = waitkeydown(inf);
            ky1(i) = ky(1);
        
      end
      reps = (ky1(1)==ky1(2) && ky1(1)==keyCode(buttonName,param.context)); 
    end
  else % Context not yet coded for
      error('get1ResponseKey not ready for this param.context')
  end
    
  keyA = ky1(1);
  disp([' Key obtained to '  responseName ': ' num2str(keyA)]);
  
else % if debug is not 0, just assign some values:
  keyA = 19;
  disp([' Key  FIXED for responding: ' num2str(keyA)]);
end 

%% ************************* End of function *******************************
end
%%
