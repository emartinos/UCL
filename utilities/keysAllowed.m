function [keyCode keyName] = keysAllowed( context )
% returns a vector of the keys allowed and their verbal descriptions as a
% function of the context - e.g. behavioural testing on NSPN 2012 Dell Latitudes, scanner keysets etc.

%% Default arguments:
if nargin < 1
    context = 1; % default - NSPN Dell latitude
end
%% contexts to be catered for :
Dell_Latitude = 1;
% Add lines about a particular device (keypad) here ...

%% Lookup 
if context == Dell_Latitude
    keyCode = [  7,   19,   52,       59,       71,        95,        97,         98,           100      ];
    keyName = { 'G', 'S', 'ESCAPE', 'RETURN', 'SPACE', 'UP_ARROW','LEFT_ARROW','RIGHT_ARROW','DOWN_ARROW'};
else
    error('keysAllowed function not ready for the context argument provided');
end % of providing allowed keys in ascending numerical code order.

end % of unction 

