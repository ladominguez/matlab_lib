function []=snoplotLat(Component)
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
close all

if nargin==0
    [files subdir]=ValidateComponent();
    Component='z';
elseif nargin==1
    [files subdir]=ValidateComponent(Component);
else
    error('snoplotDist.m - Too many input paramenters');    
end

figure

%Grid=[0 10 20 30 40 50 60 70 80 90 100 150];
%xlimit=[0 150];
%e=earthquake();

hold on
ix=1;
NumFiles=length(files);
dist=zeros(NumFiles,1);
Index=IndexGen(Component); % Sorts the stations by latitude
latlons=GenLatLons(Component);
latlons=sortrows(latlons);
latlons=latlons(1,:);  % The most Southern statation
% This cycle plots the station's seismograms in a single figure
%Color=['y' 'm' 'c' 'r' 'g' 'b']';
nn=1;
ACAP_sta=[16.8839  -99.8494];
for ii=1:NumFiles 
    FullName=fullfile(subdir,files(ii).name);
    s=rsac(FullName);
    slat=s.stla; % Latitude
    slon=s.stlo;

    % Change  Color
    % Color=circshift(Color,1);	
    ys=s.d;
    ys=ys-mean(ys);
    Max=max(abs(ys));
    if Max==0, continue; end
    ys=10*ys./Max; % Normalizes the ampitude
    dist=distkm(ACAP_sta, [slat slon]);
    
    %dist=distance(latlons,[slat slon]);
    plot(s.t,ys+dist,'k');%Color(1));
    if s.picks(1)~=-12345
        plot(s.picks(1),dist,'*')
        plot(s.picks(1)+30,dist,'*')
    end
end

axis tight;
ylimits=get(gca,'YLim');

%deltas=GenDeltasByLatitude(Component);

return

[AX,H1,H2]=plotyy(s.t(1),dist,s.t(1), dist); % I plot a point to
                                                % to display the name stations
						% on the right axis
%[AX,H1,H2]=plotyy(Pwave,dist,sP,dist);		%uncomment

hold off;
xlabel('Time (s)');
ylabel('\Delta [Degrees]')
SetTitle(Component,s);
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
