function []=GetTT(Stations,Component,Phase)
% GETT: This program plot the seismograms of n stations and save
% 	a graphical input for the P wave arrival.
%
% 	Syntaxis
% 		[]=GetTT(Stations, Component, Phase)
%	IN
% 		Stations: 
%			'all' Shows all stations.
%			'ABCD' Shows a particular station.
%       Component:
%           'N' or 'n' North.
%           'E' or 'e' East.
%           'Z' or 'z' Vertical.
%       Phase:
%           Seismic Phase. P - default
%	OUT
%		PArrival.dat: 
%			Save the arrival times in this file.
%
% 	Author: Luis Dominguez. Nov 06.

if(nargin==0)
	error('You must select one option')
elseif (nargin==1)
   Component='Z';
elseif nargin==2
    Phase='P';
end

% TODO modify to select a single station or a groups of them

e=earthquake();
[files subdir]=ValidateComponent(Component);

NumFiles=length(files);


if(~strcmp(Stations,'all'))
	load PArrival.dat
	close all
end
    filename=[Phase 'Arrival'];
	fid2=fopen(filename,'w');
	figure(777);  % Opens a new window
	
	Index=IndexGenDst(Component); % Sorts the stations by Distance

	for ii=1:NumFiles
	    full_name=fullfile(pwd,subdir,files(ii).name); 
	    [t ys p]=readsac(full_name);
        [lat lon elev name]=readheader(full_name);
	    slat(ii)=p(17); % Latitude
	    slon=p(18);     % Longitude
	    ys=ys-mean(ys);
	    ys=ys./max(abs(ys)); % Normalizes the ampitude
            DST=distance(e.latlon,p(17:18));
	    	
%	    Theory=TravelTime(DST,e.depth,Phase);

	    if(strcmp(Stations,files(ii).name(19:22)))
		Precord=[(1:length(PArrival))' PArrival];
		figure(777);  % Opens a new window
                plot(t,ys);
		hold on
% 		MinLim=min(ys((round(Theory*100)-1500):(round(Theory*100)+1500)));
%         MaxLim=max(ys((round(Theory*100)-1500):(round(Theory*100)+1500)));
%         plot([Theory Theory],[MinLim MaxLim],'r');
		plot([Precord(find(Index==ii),2) Precord(find(Index==ii),2)],[MinLim MaxLim],'b')
                axis([Theory-15 Theory+15 MinLim MaxLim]);
		legend(files(ii).name(19:22));
		[PTime Dummy]=ginput(1);
		Precord(find(Index==ii),:)=[find(Index==ii) PTime];
		break;
	    elseif(strcmp(Stations,'all'))
	    	plot(t,ys);
	        hold on
% 		MinLim=min(ys((round(Theory*100)-1500):(round(Theory*100)+1500)));
% 		MaxLim=max(ys((round(Theory*100)-1500):(round(Theory*100)+1500)));
%       plot([Theory Theory],[MinLim MaxLim],'r');
% 		axis([Theory-15 Theory+15 MinLim MaxLim]);
	        legend(files(ii).name(19:22)); 
            counter=[num2str(ii) ' out of ' num2str(NumFiles)];
            title(counter);
	        [PTime Dummy]=ginput(1);
	    	Precord(ii,:)=[find(Index==ii) PTime];
	    end
	    hold off
	end

	Precord=sortrows(Precord);
	fprintf(fid2,'%4.2f\n', Precord(:,2)');
	fclose(fid2);

close(777);
snoplot
PlotObsTimes
