%skew_measurespintime
for g = 1

anginit = 15;
angspeed = anginit;
ang=0;
angfin = 720+360;
spininc = 10;
k=1;

T = time;
while ang < angfin-.8
        ang = ang + angspeed;
        angspeed = anginit.*(1-(ang./angfin)); %this sets the end angspeed at 0 (so speed linearly decreases to 0)
    waituntil(T+k*spininc) 
%     fprintf(['hello' num2str(time) '\n'])
    norm(rand(20));
    k = k+1;
    end
    h(g) = time - T;
end
h