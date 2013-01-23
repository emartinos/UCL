function reply = luhn( number, action )
%LUHN algorithm helper. Generate or validate the luhn number
%   number - (String/Integer) The number to operate on.
%   action - (String) 'checkdigit' to generate check digit for <number>
%                     'generate' to generate the luhn number for <number>
%                     'validate' to  validate the luhn number <number>
%   return integer if action is 'checkdigit', integer string if action is
%   'generate', boolean if action is 'validate'

  numberString=num2str(number);
  numberString=arrayfun(@(x) str2num(x), numberString);
  len=length(numberString);

  startdoubleddigit=len;
  startsingleddigit=len-1;
  if  isequal('validate', action)
      startdoubleddigit=len-1;
      startsingleddigit=len;
  end
  
  reply = 10 - mod(  sum ( numberString(startsingleddigit:-2:1) ) ...
                   + sum ( arrayfun(@(x) luhn_double_reduce(x), numberString(startdoubleddigit:-2:1)) ), ...
                   10 ...
               );
  if isequal(reply, 10)
        reply=0;
  end
    
  if isequal('validate', action)
       reply = isequal(0, reply);
  elseif isequal('checkdigit', action)
       reply = reply;
  elseif isequal('generate', action)
       reply = [ num2str(number) num2str(reply)];
  else
       reply = ['Unexpected action type "' action '"' ];
  end
end

function result = luhn_double_reduce(number)
% LUHN_DOUBLE_REDUCE double the single digit number and reduce it to one
% digit as dictated by Luhn algorithm
% 
% return an integer.
  number=number*2;
  if number > 9 
    result=number-9;
  else
    result=number;
  end
end