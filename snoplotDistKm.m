function [dist]=snoplotDstKm(Component)
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
Markers='on';
if nargin==0
    Component='z';
elseif nargin>2
    error('snoplotDist.m - Too many input paramenters');
end
[files N]=ValidateComponent(Component);
figure
Gain =15;
hold on
ix=1;
NumFiles=length(files);
dist=zeros(NumFiles,1);
% This cycle plots the station's seismograms in a single figure
%Color=['y' 'm' 'c' 'r' 'g' 'b']';
nn=1;

for ii=1:NumFiles
    FullName=fullfile(pwd,files(ii).name);
    s = rsac(FullName);
    %s = filter_sac(s,9,12,4);

    ys=s.d;
    t=s.t;

    % Change  Color
    % Color=circshift(Color,1);
    
    ys      = ys-mean(ys);
    Max     = max(abs(ys));
    if Max ==0 , continue; end
    ys=Gain*ys./Max; % Normalizes the amplitude
    %dist(ii)=s.gcarc;  WARNING. This may causes problems, next line is
    %better
    
    dist(ii)=sqrt(s.evdp^2 + s.dist^2);%distance([s.evla s.evlo],[s.stla s.stlo]);	    

    plot(t,ys+dist(ii),'k');%Color(1));
    %plot(dist(ii)/3.7,dist(ii),'d','MarkerFaceColor','r')   
    %plot(dist(ii)/6.4,dist(ii),'d','MarkerFaceColor','r')
  %  text(s.beg,dist(ii),s.kstnm(1:4))
    if strcmp(Markers,'on')
        if s.a~=-12345
     %       plot(s.a,dist(ii),'o','MarkerFaceColor','r'); 
            
        end
        for k=1:10
            if s.picks(k) ~= -12345
      %          plot(s.picks(k),dist(ii),'o','MarkerFaceColor','r')  

            end
        end
    end

end

axis tight
%ylimits=get(gca,'YLim');
%set(gca,'XLim',xlimit);

%deltas=GenDeltas(Component);

hold off;
xlabel('Time (s)');
ylabel('Distance [km]')
%SetTitle(Component,s);
setw
%List=GetStaNamesDst(Component);


% To fix the scale for all axis
% deltas=GenDeltas('all');
% Ddiff=max(deltas)-min(deltas);
% ylimits(1)=min(deltas)-0.025*Ddiff;
% ylimits(2)=max(deltas)+0.025*Ddiff;
% clear List
% List=GetStaNamesDst('all');
% 
% ax1=gca;
% 
% ax2 = axes('Position',get(ax1,'Position'),...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'XColor','k','YColor','k');
% set(ax2,'xlim',get(ax1,'xlim'))
% %set(ax2,'ydir','reverse')
% set(ax2,'ylim',ylimits)
% set(ax1,'ylim',ylimits)
% set(ax2,'YTick',deltas)
% set(ax2,'YTickLabel',List)
% set(gcf,'Color',[1 1 1])

end
