function []=CreateInputFiles()
% CreateInputFiles.m
%
% This command must be used when a new event is going to be proccessed 
% for first time. It creates the files Title.dat.
%
% Previous version also created EarthquakeParams.dat, and latlons.dat. 
% Howver these files are not longer required by other functions.
%
% IN
%	No input parameters.
% OUT
%	No output parameters.
%
%	By Luis Dominguez August 2007. Update May 2009
%

reply=input('Do you want to create Title.dat? (y/n) ','s');

if reply=='y'
	Year=input('Year: ','s');
	Month=input('Month: ','s');
	Day=input('Day: ','s');
	Mag=input('Magnitud: ','s');
	Time=input('Time(HH:MM): ','s'); 
	Location=input('Location: ','s');
	
	fid2=fopen('Title.dat','w');
	fprintf(fid2,'%s - %s/%s/%s - %s - Magnitude %s -',...
	Location,Month,Day,Year,Time,Mag);
	fclose(fid2);
end

% Commented May 2009 DRLA
% disp('This program creates the necessary input files')
% disp('')
% reply=input('Do you want to create EarthquakeParams.dat? (y/n):','s');
% 
% if reply=='y'
% 	Lat=input('Latitud: ');
% 	Lon=input('Longitud: ');
% 	Depth=input('Depth: ');
% 	Shift=input('Time Shift: ');
% 	
% 	fid1=fopen('EarthquakeParams.dat','w');
% 	fprintf(fid1,'%3.2f\n%3.2f\n%3.2f\n%3.2f',[Lat Lon Depth Shift]);
% 	fclose(fid1);
% end




% Commented May 2009
% if ~exist('./latlons.dat','file')
% 	disp('latlons.dat does not exists.')
% 	reply=input('Do you want to create latlons.dat? (y/n):','s');
% 	
% 	if reply == 'y'
% 		latlons=GenLatLons();
% 		latlons=sortrows(latlons);
% 		save latlons.dat latlons -ascii
% 	end
% 
% end
% 
% if ~exist('./deltas.dat','file')
% 	disp('deltas.dat does not exists.')
% 	reply=input('Do you want to create deltas.dat? (y/n):','s');
% 	
% 	if reply == 'y'
% 		latlons=GenLatLons();
% 		e=earthquake();
% 		deltas=distance(e.latlon,latlons);
% 		deltas=sortrows(deltas);
% 		save deltas.dat deltas -ascii
% 	end
% 
% end
