function A=plotwbd(Component, lineup)
% plotwb(Component, shift)
%
% Plots the seismic records using wigb by distance.
%
% IN.
%   Component. East ('E'), North ('N') and Vertical ('Z')
%              (capitalization is not required)
%   Shift.     Starting Value.
% OUT.
%   A.         Data matrix, every row represent a seismogram
%              - the output is normalized.
%               By Luis A. Dominguez 2008
%                  ladominguez@ucla.edu

close all

if nargin==0 | Component=='Z' | Component=='z'
    Component='Z';
end

[A t t0]=AllRecords(Component);
SF=1/(t(2)-t(1)); % Sampling frequency
tin=t(1); % This must be read it directly from the header - CHANGE IT

if exist('lineup','var')
    %load PArrival.dat;
    PArrival=25.*ones(size(t0));
    %minimum=min(PArrival);
    minimum=min(t0);
    PArrival=(PArrival-tin )-10;
    PArrival=PArrival*SF;

    for i=1:size(A,1)
        A(i,:)=circshift(A(i,:)',-round(PArrival(i)))';
        %        A(i,:)=circshift(A(i,:)',10000)';
    end
end

%SF=100; % Sampling frequency
t1=t(1);
t=0:size(A,2)-1;
t=t./SF+t1;

NF=size(A,1);
d=GenDeltas(Component);
Max_A=wigb(A',5,d,t);
ShowStatics(Component);
sac_files=dir('*.sac');
sac=rsac(sac_files(1).name); % I used this random file to set thte title of the figure
SetTitle(Component,sac);
xlabel('Distance [Degrees]','FontSize',15)
ylabel('Time [s]','FontSize',15)
% To fix the scale for all axis

[dummy deltas]=IndexGenDst(Component);
Ddiff=max(deltas)-min(deltas);
xlimits(1)=min(deltas)-0.025*Ddiff;
xlimits(2)=max(deltas)+0.15*Ddiff;
set(gca,'xlim',xlimits)
set(gcf,'Color',[1 1 1])
% List=GetStaNamesDst('all');
% set(gca,'XTick',deltas);
% set(gca,'XTickLabel',List);
% set(gca,'FontSize',8)
% xticklabel_rotate();


%******************************************
% I moved this lines to double axis
% ax1=gca;
% ax2 = axes('Position',get(ax1,'Position'),...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'XColor','k','YColor','k');
% set(ax2,'ylim',get(ax1,'ylim'))
% set(ax2,'ydir','reverse')
% set(ax2,'xlim',get(ax1,'xlim'))
% set(ax1,'xlim',get(ax1,'xlim'))
% grid
%******************************************

% max_legend=['Maximum Amplitude: ' num2str(Max_A)];
% text(d(1),t(end)+0.2*abs(t(end)-t(1)),max_legend,'FontSize',20)
if nargin==2
    NewTitle=[get(get(gca,'Title'),'String') ' - Lined up'];
    title(NewTitle);
end

if nargout==0
    A=1;
else
    A=inv(diag(max(A')))*A;
end

