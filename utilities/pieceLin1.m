function y = pieceLin1(x, Xdef, Ydef )
% output y is a piecewise linear fn. of x (1-D), the pieces are defined by
% Xdef (abcissa) & Ydef (ordinates); Xdef must be ordered from low to high.
n = size(Xdef,2);
if size(Ydef,2) ~= n
    error(['Xdef=' num2str(n) ' but Ydef=' num2str(size(Ydef,2)) ' in pieceLin1(x, Xdef, Ydef)']);
end 
% find where the given abcissa x falls:
i=1; % This will be the index of the low value of the linear piece we will use.
while (x > Xdef(i+1) ) && (i < n-1)
    i = i+1;
end

if Xdef(i) == Xdef(i+1) % i.e. a nasty vertical piece
    y = Ydef(i+1); % a convention ...
else % the real interpolation
    y = Ydef(i) + (x-Xdef(i))* (Ydef(i+1) - Ydef(i))/( Xdef(i+1) - Xdef(i) );
end

end % of fn piecLin1

