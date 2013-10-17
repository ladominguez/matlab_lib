function A=plotwbl(Component, lineup)
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

[files subdir]=ValidateComponent(Component);
NumFiles=length(files);
ACAP_sta=[16.8839  -99.8494];
fullname=fullfile(pwd,subdir,files(1).name);
sac_file=rsac(fullname);
A=zeros(NumFiles,sac_file.npts);
A(1,:)=sac_file.d;
d(1)=distance(ACAP_sta,[sac_file.stla sac_file.stlo])*111.1;
t=sac_file.t;
flagt=0;

for ii=2:NumFiles
    fullname=fullfile(pwd,subdir,files(ii).name);

    sac_file=rsac(fullname);
    A(ii,:)=sac_file.d(:);    
    d(ii,1)=distance(ACAP_sta,[sac_file.stla sac_file.stlo])*111.1;
    
    if sac_file.picks(1)~=-12345
        t0(ii)=sac_file.picks(1);
        flagt=1;
    end
end



[d Ind]=sortrows(d);
A=A(Ind,:);
if flagt==1
%    t0=t0(Ind);
end
disp(['EQ Latitude : ' num2str(sac_file.evla) ])	 
disp(['EQ Longitude: ' num2str(sac_file.evlo) ])	 
disp(['EQ Depth    : ' num2str(sac_file.evdp) ])	 
disp(['Backazimuth : ' num2str(sac_file.baz)  ])

Max_A=wigb(A',6,d,t);
ShowStatics(Component);
SetTitle(Component,sac_file);
xlabel('Distance from ACAP in [Km]','FontSize',15)
ylabel('Time [s]','FontSize',15)

% To fix the scale for all axis

All_sta=GenLatLons('ALL');
deltas=distance(ACAP_sta,All_sta).*111.1;
Ddiff=max(deltas)-min(deltas);
xlimits(1)=min(deltas)-0.025*Ddiff;
xlimits(2)=max(deltas)+0.025*Ddiff;
set(gca,'xlim',xlimits)
set(gcf,'Color',[1 1 1])
List=GetStaNamesLat();
set(gca,'XTick',deltas);
set(gca,'FontSize',6)
set(gca,'XTickLabel',List);
xticklabel_rotate();

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

return
if flagt
    hold on
    plot(d,t0,'k','LineWidth',3)
    plot(d,t0+30,'k','LineWidth',3)
end
