function sac=get_max_win(sac,winLength)

if nargin < 2
    winLength=2;             % Windows length in seconds
end
winSize    = round(winLength/sac.dt); %  Number of sample per second
mid_point  = round(winSize/2);
max_p      = zeros([1 floor(sac.npts/winSize)]);
npts_new   = length(max_p);
t          = sac.t;
y          = sac.d;

y          = abs(y(1:npts_new*winSize));
t          = t(1:npts_new*winSize);
y          = reshape(y,winSize,[]);
t          = reshape(t,winSize,[]);
y          = max(y);
t          = mean(t);
sac.d      = y;
sac.beg    = sac.t(mid_point);
sac.dt     = winLength;
sac.t      = t;%sac.beg:sac.dt:sac.beg+(npts_new-1)*sac.dt; This line caused a roundout error.
sac.npts   = npts_new;


