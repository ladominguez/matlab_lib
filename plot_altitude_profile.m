% ALTPLOT: Plot the altitude profile and the residuals for the 
%	   Guerrero Eathquake and save it in FIGURES/DiffAlt.fig 
%	
%	IN: NOT INPUT ARGUMENTS
%
% Author: 
%	Luis A. Dominguez. April 2007.
%

hold on;
clear all
close all


load altitude.dat;
LoadData;

TP=TPtime([EarthquakeParams' 0.0]);
[AX,H1,H2]=plotyy(latlons(:,1),TP,altitude(:,1),altitude(:,2));
set(H1,'LineStyle','--','Marker','+');
ylabel(AX(1),'\Delta T [s]')
ylabel(AX(2),'Altitud [m]')
Coeff=polyfit(latlons(:,1),TP',6);
Val=polyval(Coeff,latlons(:,1));
hold on
plot(AX(1),latlons(:,1),Val);
axis(AX(1),[16.5 21.5 -1.5 1.5])
axis(AX(2),[16.5 21.5 0 4000])
set(AX(1),'YTick',(-1.5:0.25:1.5));
SetTitle;
saveas(gcf,'FIGURES/DiffAlt.fig');
hold off;



