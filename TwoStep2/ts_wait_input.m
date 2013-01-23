function button_pressed = ts_wait_input( sprite_key,x,y )
%PG_WAIT_INPUT draws sprite with key sprite_key and returns button pressed
%   

if nargin==1;
    
    x = 0;
    y = 0;
elseif nargin~=3
    error('give x and y when calling ts_wait_input, or only sprite key to use default x and y (both 0)');
end

global params
cgsetsprite(0);
cgdrawsprite(sprite_key,x,y);
cgflip(params.background);
kp = 0;
wait(500)
cgkeymap
while isempty(find(kp, 1)); %wait for keypress
    [~,kp] = cgkeymap;
end
button_pressed = find(kp,1);    
cgflip(params.background);

end

