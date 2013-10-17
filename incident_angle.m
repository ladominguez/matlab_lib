function a=incident_angle(p, d, type)
% a = incident_angle(pray, depth, type)
%   
% Returns the incident angle for a given ray parameter.
% IN:
%   p - Ray parameter [s/deg]
%   d - Depth [km]     - default 0
%   t - P or S wave - default P wave (velocity 5.8km/s)
% OUT:
%   a - Angle of incident (deg)
%
%           By Luis Dominguez June 2008

if nargin==1
    d=0;
    type=upper('p');
elseif nargin==2
    type='P';
elseif nargin==3
    type=upper(type);
end


cf=180/pi; % conversion factor s/degres -> s/ radians
if strcmp(type,'P')
    v=ak135_Vp(d);
else
    v=ak135_Vs(d);
end

v;
r=6371-d;

a=asind(cf.*p.*v./r);