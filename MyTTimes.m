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
[P Travel]=FindAngles(X,flag,Depth,a,Inc);
PuPu=funcScat(P,'PuPu');
A(:,flag)=abs(PuPu);
T(:,flag)=Travel;

%%% SuPu
clear XRecord pRecord TravelRecord
flag=2; 
a=40;
Inc=0.0005;
[P Travel]=FindAngles(X,flag,Depth,a,Inc);
SuPu=funcScat(P,'SuPu');
A(:,flag)=abs(SuPu);
T(:,flag)=Travel;

%%%SuSuPgPg
clear XRecord pRecord TravelRecord
flag=3;
a=0;
Inc=0.5;
[P Travel]=FindAngles(X,flag,Depth,a,Inc);
[PP, SS, SP, PS]=funcPP_SS_SP_PS(P);
SuSu=funcScat(P,'SuSu');
PdPu=funcScat(P,'PdPu');
ASuSuPgPg=SuSu.*SP'.*PdPu; 
A(:,flag)=abs(ASuSuPgPg);
T(:,flag)=Travel;

%%% SuSuPbPb
clear XRecord pRecord TravelRecord
flag=4;
a=0;
Inc=0.5;
[P Travel]=FindAngles(X,flag,Depth,a,Inc);
[PP, SS, SP, PS]=funcPP_SS_SP_PS(P);
SuSu=funcScat(P,'SuSu');
PdPu=funcScat(P,'PdPu');
ASuSuPbPb=SuSu.*SP.*PdPu; 
A(:,flag)=abs(ASuSuPbPb);
T(:,flag)=Travel;

%%% SuSu
clear XRecord pRecord TravelRecord
flag=5;
a=0;
Inc=0.5;
[P Travel]=FindAngles(X,flag,Depth,a,Inc);
SuSu=funcScat(P,'SuSu');
A(:,flag)=abs(SuSu);
T(:,flag)=Travel;

% Caliculate Rayleigh arrival time
flag=6;
TR=func_Rayleigh();
AR=0.3.*ones(1,NumSta);
A(:,flag)=AR;
T(:,flag)=TR;



figure
h1=plot(deltas,T);
legend(h1,'TPuPu','TSuPu','TSuSuPgPg',...
                'TSuSuPbPb','TSuSu','TR');
xlabel('delta [Degrees]');
ylabel('Time [s]');
SetTitle;

figure;
h2=plot(deltas,A);
h2=legend(h2,'APuPu','ASuPu', 'ASuSuPgPg',...
                'ASuSuPbPb','ASuSu','AR');
xlabel('delta [Degrees]');
ylabel('Amplitudes');
SetTitle;

