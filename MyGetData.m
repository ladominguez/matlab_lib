load EarthquakeParams.dat;

files=dir('/home/antonio/LEASTSQUARES/GUERRERO/DATA/*N.sac'); 
NumFiles=length(files);

	for ii=1:58 
	    [t ys p]=readsac(['/home/antonio/LEASTSQUARES/GUERRERO/DATA/',files(ii).name]);
	    slat(ii)=p(17); % Latitude
	    slon=p(18);     % Longitude
	    ys=ys-mean(ys);
	    ys=ys./max(abs(ys)); % Normalizes the ampitude
            data(ii,:)=ys;		
            DST(ii)=distance(EarthquakeParams(1:2)',p(17:18));
	    end	
Sdeltas=DST';
seis=data';            
seis=seis(1:12000,1:58);
z=[1:1:12000]/100;
clf; wigb(seis,0.3,Sdeltas,z)
