function [distance latmin lonmin]=distance2trench(points)
% distance=distance2trench(points or sac)
% 
% Computes the distance to trench of Mexico to a given point.
% The input is either:
%   - points a nx2 array with latotude and longitude.
%   - sac a sac structure.
%  
%  By Luis Dominguez UCLA - 2010
%     ladominguez@ucla.edu

if isstruct(points)
    sac=points;
	clear points
	points=[sac.stla sac.stlo];
end

N=size(points,1);
distance=zeros(1,N);

if points(1,1)>0  % MASE station
    load /home/antonio/lib/maps/MEXICO_trench.dat
    trench=[MEXICO_trench(:,2) MEXICO_trench(:,1)];
else              % Peru Station
    load /home/antonio/lib/maps/Peru_trench.dat
    trench=[Peru_trench(:,2) Peru_trench(:,1)];
end

for k=1:N
	distance_temp=distkm(points(k,:),trench);
	[distance(k) index]=min(distance_temp);
end

if nargout==3
        latmin=trench(index,1);
        lonmin=trench(index,2);
end
