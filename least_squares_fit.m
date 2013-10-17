function [m b]=least_squares_fit(x,y)
disp('WARNING - This funtion may give wrong results.');
disp('          See linear_least_squares.m DRLA');

if size(x)~=size(y)
	error('X and Y must have the same dimensions')
end

N=length(x);

a11=(1/N)*sum(x.^2);
a12=(1/N)*sum(x);
a21=a12;
c1=(1/N)*sum(x.*y);
c2=(1/N)*sum(y);
m=(a12*c2-N*c1)/(a12*a21-N*a11);
b=(c2-m*a12)/N;


