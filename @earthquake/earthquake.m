function e=earthquake(lat, long, depth,year,month,day,hour, minute, second, mag, shift)

if nargin==0
	load EarthquakeParams.dat
	e.latitud=EarthquakeParams(1);
	e.longitud=EarthquakeParams(2);
	e.depth=EarthquakeParams(3);
	if length(EarthquakeParams)==4
		e.shift=EarthquakeParams(4);
	else
		e.shift=0;
	end
 	e.year='1900';
    e.month='1';
    e.day='1';
    e.hour='00';
    e.minute='00';
    e.second='0.0';
    e.mag=0;
    e=class(e,'earthquake');
elseif nargin==1
    e.latitude=lat;
    e.longitude=0;
    e.depth=0;
    e.year=1900;
    e.month=1;
    e.day=1;
    e.hour='00';
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
    e=class(e,'earthquake');
elseif nargin==2
    e.latitude=lat;
    e.longitude=long;
    e.depth=0;
    e.year=1900;
    e.month=1;
    e.day=1;
    e.hour='00';
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
    e=class(e,'earthquake');
elseif nargin==3
	e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=1900;
    e.month=1;
    e.day=1;
    e.hour='00';
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');
elseif nargin==4
	e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=1;
    e.day=1;
    e.hour='00';
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');
elseif nargin==5
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=1;
    e.hour='00';
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');
elseif nargin==6
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=day;
    e.hour='00';
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');
elseif nargin==7
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=day;
    e.hour=hour;
    e.minute='00';
    e.second=0.0;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');    
elseif nargin==8
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=day;
    e.hour=hour;
    e.minute=minute;
    e.second=0.0;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');    
elseif nargin==9
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=day;
    e.hour=hour;
    e.minute=minute;
    e.second=second;
    e.mag=0;
    e.shift=0;
	e=class(e,'earthquake');    
elseif nargin==10
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=day;
    e.hour=hour;
    e.minute=minute;
    e.second=second;
    e.mag=mag;
    e.shift=0;
	e=class(e,'earthquake'); 
elseif nargin==11
    e.latitud=lat;
	e.longitud=long;
	e.depth=depth;
	e.year=year;
    e.month=month;
    e.day=day;
    e.hour=hour;
    e.minute=minute;
    e.second=second;
    e.mag=mag;
    e.shift=shift;
	e=class(e,'earthquake');    
else
	error('Invalid number of input arguments');
end
	
