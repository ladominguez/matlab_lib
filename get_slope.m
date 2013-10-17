function m=get_slope()
a=ginput(2);
dy=diff(a(:,2));
dx=diff(a(:,1));
m=dy/dx;
