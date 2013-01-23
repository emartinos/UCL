function [s, t] = lastslice( port )
% [s, t] = lastslice( port )
%
% Returns the most recent slice number and its timestamp.
%
% See also:
%   config_serial, getslice, waitslice, logslice.
%
% Cogent2000 function

[s, t] = getslice( port );
% discard all but the last slice received.
s = s( end );
t = t( end );


