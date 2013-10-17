function [t y]=get_max__win_data(t,y,winLength)

if nargin < 2
    winLength=2;             % Windows length in seconds
end

dt         = t(2)-t(1);
winSize    = round(winLength/dt); %  Number of sample per second
mid_point  = round(winSize/2);
npts       = numel(y);
max_p      = zeros([1 floor(npts/winSize)]);
npts_new   = length(max_p);

y          = abs(y(1:npts_new*winSize));
t          = t(1:npts_new*winSize);

y          = reshape(y,winSize,[]);
t          = reshape(t,winSize,[]);
y          = max(y);
t          = mean(t);

dt_new     = winLength;
%sac.t      = t%sac.beg:sac.dt:sac.beg+(npts_new-1)*sac.dt; This line caused a roundout error.
%sac.npts   = npts_new;


