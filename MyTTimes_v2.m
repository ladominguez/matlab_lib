% To construct seismograms for ttimes
clear
close all

NumSta=GetNumSta();
RadiusEarth=6371;

xx=[1:NumSta]; 	% Number of stations
Earthquake=earthquake();
Depth=Earthquake.depth;

%h=35;
%d=Depth-h;

deltas=GenDeltas();
X=deg2rad(deltas)*RadiusEarth; % sin?

%%% PuPu
flag=1; 
a=0;
Inc=0.5;

[P Travel]=find_angles_direct_waves(X,flag,Depth,a,Inc);
PuPu=funcScat(P,'PuPu');
A(:,flag)=abs(PuPu);
T(:,flag)=Travel;

%figure
%h1=plot(deltas,T);
%legend(h1,'TPuPu','TSuPu','TSuSuPgPg',...
%                'TSuSuPbPb','TSuSu','TR');
%xlabel('delta [Degrees]');
%ylabel('Time [s]');
%SetTitle;

%figure;
%h2=plot(deltas,A);
%h2=legend(h2,'APuPu','ASuPu', 'ASuSuPgPg',...
%                'ASuSuPbPb','ASuSu','AR');
%xlabel('delta [Degrees]');
%ylabel('Amplitudes');
%SetTitle;

