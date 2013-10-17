function [times]=GetMax(Component)


if(nargin==0)
   Component='Z';
end

% TODO modify to select a single station or a groups of them

e=earthquake();
[files subdir]=ValidateComponent(Component);

NumFiles=length(files);

    filename='PArrival.dat';
	fid2=fopen(filename,'w');
		
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
        [m I]=max(ys);
    	Precord(ii,:)=[find(Index==ii) t(I)];
	end

	Precord=sortrows(Precord);
	fprintf(fid2,'%4.2f\n', Precord(:,2)');
	fclose(fid2);

snoplot(Component);
PlotObsTimes
