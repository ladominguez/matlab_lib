function []=snoplotTrench(Component,h)
% []=snoplotLat(Component)
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
Gain=20;
LinWidth=1.5;
FontSize=12;
WinSize=75;
Markers='off';


if nargin==0
    [files NumFiles]=ValidateComponent();
    Component='z';
    close all
    figure; h=gca;
elseif nargin == 1
    [files NumFiles]=ValidateComponent(Component);
    close all
    figure; h=gca;
elseif nargin == 2
    [files NumFiles]=ValidateComponent(Component);
else
    error('snoplotDist.m - Too many input paramenters');    
end


%Grid=[0 10 20 30 40 50 60 70 80 90 100 150];
%xlimit=[0 150];
%e=earthquake();

hold on
ix=1;
dist=zeros(NumFiles,1);
%Index=IndexGen(Component); % Sorts the stations by latitude
% latlons=GenLatLons(Component);
% latlons=sortrows(latlons);
% latlons=latlons(1,:);  % The most Southern statation
% This cycle plots the station's seismograms in a single figure
%Color=['y' 'm' 'c' 'r' 'g' 'b']';
nn=1;

for ii=1:NumFiles 
    FullName=fullfile(pwd,files(ii).name);
    s=rsac(FullName);
    slat=s.stla; % Latitude
    slon=s.stlo;

    % Change  Color
    % Color=circshift(Color,1);	
    ys=s.d;
    ys=ys-mean(ys);
    Max=max(abs(ys));
    if Max==0, continue; end
    ys=Gain*ys./Max; % Normalizes the ampitude
    dist=distance2trench([slat slon]);
    
    %dist=distance(latlons,[slat slon]);
    plot(h,s.t(1:1:end),ys(1:1:end)+dist,'Color',[0.4 0.4 0.4],'LineWidth',LinWidth);%Color(1));  
    for k=1:10
        if s.picks(k)~=-12345 & strcmp(Markers,'on')
            plot(h,s.picks(k) ,dist,'*')
%        plot(s.picks(1)+WinSize,dist,'*')
        end
    end
end

axis tight;
ylimits=get(h,'YLim');
set(h,'YLim',[0 ylimits(2)])
%deltas=GenDeltasByLatitude(Component);
SetTitle(Component,s);
xlabel(h,'Time [s]','FontSize',FontSize);
ylabel(h,'Distance to the trench [km]','FontSize',FontSize)
set(gcf,'Color','w')
%set(h,'FontWeight','bold')
return

[AX,H1,H2]=plotyy(s.t(1),dist,s.t(1), dist); % I plot a point to
                                                % to display the name stations
						% on the right axis
%[AX,H1,H2]=plotyy(Pwave,dist,sP,dist);		%uncomment

hold off;

ylabel('\Delta [Degrees]')

add2title('-- Sorted by Latitude')
ShowStatics(Component);
List=GetStaNames(Component);

%set(AX,'XLim',xlimit);		% change gca->AX
%set(AX,'XLim',[25 150])
set(AX,'XMinorTick','on');	% change gca->AX
%set(AX,'XTick',Grid);		% change gca->AX
return
set(AX,'YLim',ylimits);		% change gca->AX
%set(AX(2),'XLim',[25 150])
set(AX(2),'YTick',deltas);	% change gca->AX(2)
set(AX(2),'YTickLabel',List); 	% change gca->AX(2)

end
