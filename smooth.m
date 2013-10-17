function x=smooth(x, degree)

x_beg = x(1);
x_end = x(end);
if nargin == 1
    degree=5;
end

if degree == 5
    F=[0 1 2 1 0]./4;
elseif degree == 7    
    F=[0 0.5 1 1 1 0.5 0]./4;
else
    F=[-21 14 39 54 59 54 39 14 -21]./231;
end
x      = conv(F,x);
x      = x(1+floor(length(F)/2):end-floor(length(F)/2));
x(1)   = x_beg;
x(end) = x_end;
