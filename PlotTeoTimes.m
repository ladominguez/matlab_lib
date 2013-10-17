% This function plots the teorethical travel times on the current plot
% based on the IASPEI91 model. It requires the file latlons.dat (station's
% positions) and EarthquakeParams.dat.
%
% By Luis Dominguez Jun 2007

function Time=PlotTeoTimes(Wave,shift,Component)
hold on;

if nargin<=2
	Component='z';
end


[phases times]=new_ttimes(Wave);
t=times(1,:);
t=reshape(t,length(t),1);
times=Dst2Lat(t,Component);
times=times-shift;
plot(times,1:size(times,1));
hold off;
