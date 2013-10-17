%Plot Mexico Topo

clear

% make grid for mapping
grdsize=40; % size of grid in km
disdeg=km2deg(grdsize);
londeg=rad2deg(grdsize/cos(45/180*pi)/6371);
latlin=linspace(41.5,49,(49-41.5)/disdeg);  % grid runs from 41.5 to 49 lat
lonlin=linspace(-118,-109,(-109+118)/londeg); % grid runs from -118 to -109 lon
[Lat,Lon]=meshgrid(latlin,lonlin);

% prepare TDS map -- this algorithm works for temp.txt as well
load srtm.mat
R=griddata(srtm(:,1),srtm(:,2),srtm(:,3),Lat,Lon,'cubic');
figure(1)
clf
Mapper
surfm(Lat,Lon,R)
shading interp
colorbar

decmap(R)