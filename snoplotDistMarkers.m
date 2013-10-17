function []=snoplotDst(Component,aligment)
% []=snoplotDst(Component)
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
%    ladominguez@ucla.edu
close all

if nargin==0
    Component='z';
elseif nargin>2
    error('snoplotDist.m - Too many input paramenters');
end
[files N]=ValidateComponent(Component);
figure

hold on
ix=1;
NumFiles=length(files);
dist=zeros(NumFiles,1);
Index=IndexGenDst(Component); % Sorts the stations by distance
ShowStatics(Component);
% This cycle plots the station's seismograms in a single figure
%Color=['y' 'm' 'c' 'r' 'g' 'b']';
nn=1;

for ii=1:NumFiles
    FullName=fullfile(pwd,files(ii).name);
    s=rsac(FullName);

    ys=s.d;
    t=s.t;

    % Change  Color
    % Color=circshift(Color,1);
    baz(ii)=s.baz;
    ys=ys-mean(ys);
    Max=max(abs(ys));
    if Max==0, continue; end
    ys=0.1.*ys./Max; % Normalizes the amplitude
    %dist(ii)=s.gcarc;  WARNING. This may causes problems, next line is
    %better
    if s.evla==-12345 || s.evlo==-12345
	error('Sac header does not containt earthquake coordinates.')
    else
	dist(ii)=distance([s.evla s.evlo],[s.stla s.stlo]);	
    end
    if isnan(dist)
        e=earthquake();
        dist=distance(e.latlon,[slat slon]);
    end
    if nargin==2
        aligment=s.a;
    else
        aligment=0;
    end

    plot(t-aligment,ys+dist(ii),'Color',[0.5 0.5 0.5]);%Color(1));
    if s.a~=-12345
        plot(s.a,dist(ii),'o','MarkerFaceColor','r');
    end
    for kk=1:10
	if s.picks(kk)~=-12345
        	plot(s.picks(kk),dist(ii),'o','MarkerFaceColor','r')
	end
     end

end

disp(['EQ Latitude : ' num2str(s.evla) ])
disp(['EQ Longitude: ' num2str(s.evlo) ])
disp(['EQ Depth    : ' num2str(s.evdp) ])
disp(['Low  frq:  '     num2str(s.user(1))])
disp(['High frq: '     num2str(s.user(2))])
disp([''])
disp(['Back azimuth: ' num2str(s.baz)])

%axis tight
%ylimits=get(gca,'YLim');
%set(gca,'XLim',xlimit);

%deltas=GenDeltas(Component);

hold off;
xlabel('Time (s)');
ylabel('\Delta [Degrees]')
SetTitle(Component,s);
%List=GetStaNamesDst(Component);


% To fix the scale for all axis
deltas=GenDeltas('all');
Ddiff=max(deltas)-min(deltas);
ylimits(1)=min(deltas)-0.025*Ddiff;
ylimits(2)=max(deltas)+0.025*Ddiff;
clear List
List=GetStaNamesDst('all');

ax1=gca;

ax2 = axes('Position',get(ax1,'Position'),...
    'YAxisLocation','right',...
    'Color','none',...
    'XColor','k','YColor','k');
set(ax2,'xlim',get(ax1,'xlim'))
%set(ax2,'ydir','reverse')
%set(ax2,'ylim',ylimits)
%set(ax1,'ylim',ylimits)
set(ax2,'YTick',deltas)
set(ax2,'YTickLabel',List)
set(gcf,'Color',[1 1 1])
end
