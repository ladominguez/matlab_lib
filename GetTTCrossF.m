function PR=GetTTCross(Station)
% GETTCROSS:This program pilot the seismograms of n stations and save 
% 	    a graphical input for the P wave arrival.
%
%	Syntaxis:
%		 GetTTCross(Station)
%	IN
%		Station: Name of one station for correlation.
% 	OUT
%		NOT OUTPUT ARGUMENTS
%
%	Author:  By Luis Dominguez Nov 06

% TODO modify to select a single station or a groups of them

if(nargin==0)
	error('Too few arguments')
end

files=dir('DATA/*HHZ.sac'); 
NumFiles=length(files);

% files cointains the name of the files
% of the available stations

load EarthquakeParams.dat;
ix=1;

close all

Filter=SelectWin(Station);

	fid2=fopen('PArrival.dat','w');
	
	Index=IndexGen(); % Sorts the stations by latiude
        display(['This function may take some minutes - ' Station])

	for ii=1:NumFiles
	    [t ys p]=readsac(['DATA/' files(ii).name]);
	    slat(ix)=p(17); % Latitude
	    slon=p(18);     % Longitude

	    [td Corr]=XCross(files(ii).name(19:22),Filter);
	    seis(find(Index==ix),1:length(Corr))=Corr';
            DST=distance(EarthquakeParams(1:2)',p(17:18));
	    	
	    Theory=TravelTime(DST,EarthquakeParams(3),'P');

	    [Dummy PTime]=max(Corr(round(Theory*100)-500:round(Theory*100)+500));
	    PTime=PTime+round(Theory*100)-500;	
	    PTime=t(PTime);	
	    
	    Corr=Corr-mean(Corr);
	    Corr=0.5.*Corr./(max(abs(Corr)));
 	    plot(td,Corr+find(Index==ii),[PTime PTime],[find(Index==ii)-min(Corr) find(Index==ii)+max(Corr)]);
	    hold on

            		

            Precord(ii,:)=[find(Index==ii) PTime];
	end

	Precord=sortrows(Precord);
	PR=Precord(:,2);
	fprintf(fid2,'%4.2f\n', Precord(:,2)');
	fclose(fid2);

PlotObsTimes
save  seis.dat seis -ascii
end
