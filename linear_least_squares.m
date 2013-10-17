function [m b e]=linear_least_squares(x,y)
% [m b e]=linear_least_squares(x,y)
% 
% y = mx + b
%
% e(1) - standar deviation of m
% e(2) - standar deviation of b

N=length(x);

% Look for complex numbers
for k=1:N
    b(k)=isreal(x(k));
end

if ~exist('b','var')
    m=0; b=0; e=0;
    return
end
ind=find(b>0);
x=x(ind);
y=y(ind);

if N~=length(x)
    N=length(x);
    disp('Warning - complex numbers ignored in linear_least_squares.m')
end

a11=sum(x.^2);
a12=sum(x);
a21=a12;
a22=1;

c1=sum(x.*y);
c2=sum(y);

m=(a12*c2-N*c1)/(a12*a21-N*a11);
b=(a12*c1-c2*a11)/(a12*a21-N*a11);

ss_xx = sum((x-mean(x)).^2);
ss_yy = sum((y-mean(y)).^2);
ss_xy = sum((x-mean(x)).*(y-mean(y)));
s     = sqrt((ss_yy-m*ss_xy)/(N-2));

e(1) = s/sqrt(ss_xx);               % slope error
e(2) = s*sqrt(1/N+mean(x)^2/ss_xx); % intersect error


%e=sum((y-(m*x+b)).^2)/N;
