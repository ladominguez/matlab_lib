function earthquakemap
% EARTHQUAKEPLOT: Plots the map of the station and the moment solution.
%
%	Syntaxis:
%		EarthquakeMap()
%	IN:
%		NOT INPUT ARGUMENTS
%	OUT:
%		NOT OUTPUT ARGUMENTS
%
%	Author: Luis A. Dominguez. 04/2007.

load Moment.dat
close all
map=shaperead('../MX_STATE.SHP')
FactorScale=1/18;
load EarthquakeParams.dat
hold on
load latlons.dat
latlim=[15 25];
lonlim=[-106 -96];
mapshow(map,'FaceColor',[1 1 1],'DisplayType', 'contour')
axis([lonlim latlim])
axis equal
hold on
Strike	= Moment(1);
Dip	= Moment(2);
Rake	= Moment(3);
Mw	= Moment(4)*FactorScale;
h=beachball(Strike,Dip,Rake,EarthquakeParams(2),EarthquakeParams(1),Mw,'r')
plot(latlons(:,2),latlons(:,1),'r^','MarkerFaceColor','r')
grid
fidTitle=fopen('Title.dat');
Title=fgetl(fidTitle);
title(Title);
