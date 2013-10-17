% This function plot the observed travel times cointained in the file PArrival.dat
% By Luis Dominguez Jun 2007
function PlotObsTimes(Num)

hold on;

if nargin==0
	load PArrival.dat
	TimesObs=Dst2Lat(PArrival);
else
	load CrossTimes.dat
	TimesObs=CrossTimes;
end

ix=size(TimesObs,1);
NumS=size(TimesObs,2);
for i=1:NumS
	plot(TimesObs(:,i),1:ix,'r*-');
end
hold off;
end
