function [tout yout]=get_max_win2(y,winLength,dt)

npts       = numel(y);         
winSize    = round(winLength/dt); %  Number of sample per second
mid_point  = round(winSize/2);
max_p      = zeros([1 floor(npts/winSize)]);
npts_new   = length(max_p);
t          = 0:dt:npts-1;

y          = abs(y(1:npts_new*winSize));
t          = t(1:npts_new*winSize);
y          = reshape(y,winSize,[]);
t          = reshape(t,winSize,[]);
y          = max(y);
tout          = mean(t);
yout       = y;





