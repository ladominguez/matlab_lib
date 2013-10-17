function Stations_available
% EARTHQUAKEPLOT: Plots the map of the station 
%	Syntaxis:
%		EarthquakeMap()
%	IN:
%		NOT INPUT ARGUMENTS
%	OUT:
%		NOT OUTPUT ARGUMENTS
%
%	Author: Luis A. Dominguez. 08/2008.


close all
map=shaperead('/home/antonio/lib/maps/MX_STATE.SHP')
FactorScale=1/18;

latlim=[15 25];
lonlim=[-106 -96];
mapshow(map,'FaceColor',[1 1 1],'DisplayType', 'contour')
axis([lonlim latlim])
axis equal
hold on
latlon=GenLatlons();
plot(latlon(:,2),latlon(:,1),'^','MarkerFaceColor','r',...
    'MarkerSize',10,'MarkerEdgeColor','b')
grid
set(gcf,'color','w')
box on