function [YC t0]=SelectWin(Station1, Component, time)
% SelectWin.m
%
% Selects a window for correlation.
%
% SINTAXIS:
%	 [y t]=SelectWin(Station)
% IN:
%	Station. Station code 4 Digits
% OUT: 
%	y. Amplitud vector.
%	t. Time vector.
%
% By Luis Dominguez 2007

if nargin==1
    [files subdir]=ValidateComponent();
    Component='Z';
elseif nargin==2
    [files subdir]=ValidateComponent(Component);
elseif nargin==3
    [files subdir]=ValidateComponent(Component);
    time=time;
else
    error('Too many/few input arguments')
end


e=earthquake();		 	% Load lat, long and Depth
Fs=100;					% Sampling frequency
WinSize=15;				% Size of the window 15s
WinSize=WinSize*Fs; 	% Size of the window 1500 samples

close all;
Station1=['*' Station1 '*' Component '*.sac'];
Sta1=dir(fullfile(pwd,subdir,Station1));
fullname=fullfile(pwd,subdir,Sta1.name);
[t Ys1 p]=readsac(fullname);

PosX=[p(17) p(18)]; 				% Earthquake position
Dst1=distance(e.latlon,PosX);	
TTimeX=time; %DRLA 05/2008 TravelTime(Dst1,e.depth,'P');% Theoretical travel time
TTIndex=round(TTimeX*Fs)-round(t(1)*Fs);

% PLOT AROUND THE THEORETICAL TRAVEL TIME (+/-)15s

plot(t,Ys1)
hold on
% Plot a vertical line on the teoretical travel time
plot([TTimeX TTimeX],[min(Ys1) max(Ys1)],'r');
 
% Limits
MinLim=min(Ys1((TTIndex-WinSize):(TTIndex+WinSize)));   
MaxLim=max(Ys1((TTIndex-WinSize):(TTIndex+WinSize)));
axis([TTimeX-round(WinSize/Fs) TTimeX+round(WinSize/Fs) MinLim MaxLim]);
%Signal=Ys1(TTimeX-WinSize:TTimeX+WinSize);
ts0=TTimeX-WinSize;
% Select the filter
[LimLow Dummy]=ginput(1);
t0=LimLow;

plot([LimLow LimLow],[min(Ys1) max(Ys1)],'g') % Plot a line for the lower limit
[LimUp Dummy]=ginput(1);
plot([LimUp LimUp],[min(Ys1) max(Ys1)],'g')   % Plot a line for the upper limit

IndLow=round(LimLow*Fs)-round(t(1)*Fs);
IndUp=round(LimUp*Fs)-round(t(1)*Fs);

% Returns the filter
%for i=IndLow:IndUp
YC((IndLow:IndUp)-IndLow+1)=Ys1(IndLow:IndUp);
%end

close all;
end

%Ys1=Ys1(TTIndex-Span:TTIndex+Span); % Cropped the Station 1 around the theoretical Travel Time
%for i=IndUp:length(Ys1)
%	Ys1(i)=Ys1(i)*0;
%end
%YC=Ys1;
