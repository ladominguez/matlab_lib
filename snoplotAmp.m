function []=snoplotAmp(Component)
% []=snoplotAmp(Component)
%
% This function plots the seismograms of n stations sorted by
% distance to the Earthquake. For example, for Mexico station 1 is Acapulco 
% (if it is available). 
% 
% IN:
% 	Component: 'N', 'E' or 'Z'
%	Default:   'Z'
% OUT:
%	Plot of the sesimograms
%
% By Luis Dominguez 2007.

figure

if nargin==0
    [files subdir]=ValidateComponent();
    Component='z';
elseif nargin==1
    [files subdir]=ValidateComponent(Component);
else
    error('Too many input paramenters');    
end

Grid=[0 10 20 30 40 50 60 70 80 90 100 150];
xlimit=[0 150];
e=earthquake();

hold on
ix=1;
NumFiles=length(files);
dist=zeros(NumFiles,1);
Index=IndexGenDst(Component); % Sorts the stations by distance 

% This cycle plots the station's seismograms in a single figure
%Color=['y' 'm' 'c' 'r' 'g' 'b']';
nn=1;

for ii=1:NumFiles 
    FullName=fullfile(pwd,subdir,files(ii).name);
    [t ys p]=readsac(FullName);
    
    ys=ys-mean(ys);
    Max(ii)=max(abs(ys));
    RMS(find(Index==ii))=norm(ys)/sqrt(length(ys));
    
end

[Max i_max]=max(Max);


for ii=1:NumFiles 
    FullName=fullfile(pwd,subdir,files(ii).name);
    [t ys p]=readsac(FullName);
    slat=p(17); % Latitude
    slon=p(18);
    ys=ys-mean(ys);
    
    ys=0.1.*ys./Max; % Normalizes the ampitude
    dist=distance(e.latlon,...
				[slat slon]);
    if ii==i_max
        plot(t,ys+dist,'r');
    else
        plot(t,ys+dist,'k');
    end    
    
end
axis tight;
ylimits=get(gca,'YLim');
set(gca,'XLim',xlimit);

deltas=GenDeltas(Component);

%Pwave=TravelTime(dist,e.depth,'P');
%sP=TravelTime(dist,e.depth,'sP-P');
%S=TravelTime(dist,e.depth,'S');	%uncomment
%plot(S,dist);%uncomment

[AX,H1,H2]=plotyy(deltas,t(1),deltas,t(1)); % I plot a point to
                                                % to display the name stations
						% on the right axis
%[AX,H1,H2]=plotyy(Pwave,dist,sP,dist);		%uncomment

%load ST.dat
%[AX,H1,H2]=plotyy(ST(:,1),dist,ST(:,2),dist);
%legend('Mase','USGS')

hold off;
xlabel('Time');
ylabel('\Delta [Degrees]')
SetTitle(Component);
List=GetStaNamesDst(Component);

set(AX,'XLim',xlimit);		% change gca->AX
set(AX,'XMinorTick','on');	% change gca->AX
set(AX,'XTick',Grid);		% change gca->AX

set(AX,'YLim',ylimits);		% change gca->AX
set(AX(2),'YTick',deltas);	% change gca->AX(2)
set(AX(2),'YTickLabel',List); 	% change gca->AX(2)

figure
plot(deltas,RMS)
end
