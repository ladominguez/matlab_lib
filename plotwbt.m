function A=plotwbt(Component, lineup)
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
clc
if nargin==0 | Component=='Z' | Component=='z'
    Component='Z';
end
nn=5; % Downsampling
[files NumFiles]=ValidateComponent(Component);
%ACAP_sta=[16.8839  -99.8494];
fullname=fullfile(pwd,files(1).name);
sac_file=rsac(fullname);
aa=sac_file.d(1:nn:end);
A=zeros(NumFiles,numel(aa));
A(1,:)=sac_file.d(1:nn:end);
d(1)=distance2trench(sac_file);
t=sac_file.t(1:nn:end);
flagt=0;

for ii=1:NumFiles
    fullname=fullfile(pwd,files(ii).name);

    sac_file=rsac(fullname);
    A(ii,:)=sac_file.d(1:nn:end);    
    d(ii,1)=distance2trench([sac_file.stla sac_file.stlo]);
    
    if sac_file.picks(6)~=-12345
        t0(ii)=sac_file.picks(6);
        flagt=1;
    else
        disp(sac_file.filename)
        sac_file.picks
        pause
    end
end
t0;


[d Ind]=sortrows(d);
%t0=t0(Ind);
A=A(Ind,:);
if flagt==1
    t0=t0(Ind);
end
disp(['EQ Latitude : ' num2str(sac_file.evla) ])	 
disp(['EQ Longitude: ' num2str(sac_file.evlo) ])	 
disp(['EQ Depth    : ' num2str(sac_file.evdp) ])	 
disp(['Backazimuth : ' num2str(sac_file.baz)  ])

Max_A=wigb(A',4,d,t);
ShowStatics(Component);
SetTitle(Component,sac_file);
xlabel('Distance to the trench [Km]','FontSize',15)
ylabel('Time [s]','FontSize',15)

% To fix the scale for all axis
set(gcf,'OuterPosition',[677 278 750 650])
setw

if nargin==2
    NewTitle=[get(get(gca,'Title'),'String') ' - Lined up'];
    title(NewTitle);
end

if nargout==0
    A=1;
else
    A=inv(diag(max(A')))*A;
end

%return
if flagt
    hold on
    plot(d,t0,'k','LineWidth',3)
%    plot(d,t0+30,'k','LineWidth',3)
end
