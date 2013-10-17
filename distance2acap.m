function [distance]=distance2trench(points)
% distance=distance2trench(points or sac)
% 
% Computes the distance to station ACAP to a given point.
% The input is either:
%   - points a nx2 array with latotude and longitude.
%   - sac a sac structure.
%
ACAP=[16.8839  -99.8494];

if isstruct(points)
        sac=points;
	clear points
	points=[sac.stla sac.stlo];
end

N=size(points,1);
distance=zeros(N,1);

for k=1:N
	distance(k,1)=distkm(points(k,:),ACAP);
end


