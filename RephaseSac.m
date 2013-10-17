% []=RephaseSac(Component,lag)
%
% Rephase the seismograms of ... TODO 

function All=RephaseSac(lag,Component)
if nargin==1
    [files subdir]=ValidateComponent();
    Component='z';
elseif nargin==2
    [files subdir]=ValidateComponent(Component);
else
    error('Too many input paramenters');    
end
%close all
figure

Grid=[0 10 20 30 40 50 60 70 80 90 100 150];
xlimit=[0 150];
f=100; % sampling frequency 
e=earthquake();

%if nargin==1&&exist('PArrival.dat','file')
%	load PArrival.dat;
%	lag= PArrival;
%else
%    error('No travel times PArrival found.')
%end

%lag=uint32(lag*f);
%Index=IndexGen(Component);

hold on

NumFiles=length(files);
dist=zeros(NumFiles,1);
Index=IndexGenDst(Component); % Sorts the stations by distance 

% This cycle plots the station's seismograms in a single figure
full_name=fullfile(pwd,subdir,files(1).name);
[t_dummy y_dummy  p_dummy]=readsac(full_name);
num_elem=length(t_dummy);

for ii=1:NumFiles 
    full_name=fullfile(subdir,files(ii).name);
    [t ys p]=readsac(full_name);
    slat=p(17); % Latitude
    slon=p(18);
    delay=uint32(p(7)*f); % lag(find(Index==ii));
    ys=ys(delay:end);
    t=t(1:(end-delay+1));	


    ys=ys-mean(ys);
    Max=max(abs(ys));
    if Max==0, continue; end
	
    if nargout==0
    	ys=0.1.*ys./Max; % Normalizes the ampitude
	dist=distance(e.latlon,...
			[slat slon]);
	plot(t,ys+dist,'k');%Color(1));
    else
	ys=ys./Max;	
	if length(ys)<num_elem  % See note
                last=length(ys);
        else
                last=num_elem;
        end
        All(find(Index==ii),1:last)=ys(1:last);	
    end
    
end

axis tight;
ylimits=get(gca,'YLim');
set(gca,'XLim',xlimit);

dist=sort(dist);

%Pwave=TravelTime(dist,EarthquakeParams(3),'P');
%sP=TravelTime(dist,EarthquakeParams(3),'sP-P');
%S=TravelTime(dist,EarthquakeParams(3),'S');	%uncomment
%plot(S,dist);%uncomment

%[AX,H1,H2]=plotyy(Pwave,dist,sP,dist);		%uncomment

%load ST.dat
%[AX,H1,H2]=plotyy(ST(:,1),dist,ST(:,2),dist);
%legend('Mase','USGS')

hold off;
xlabel('Time');
ylabel('\Delta [Degrees]')
SetTitle(Component);
List=GetStaNamesDst(Component);

%set(AX,'XLim',xlimit);		% change gca->AX
%set(AX,'XMinorTick','on');	% change gca->AX
%set(AX,'XTick',Grid);		% change gca->AX

%set(AX,'YLim',ylimits);		% change gca->AX
%set(AX(2),'YTick',dist);	% change gca->AX(2)
%set(AX(2),'YTickLabel',List); 	% change gca->AX(2)

end
