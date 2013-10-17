function []=snoplot_filter(Component,sorting)
% snoplot.m
% This program plot the seismograms of n stations in
% latitude order. For example, for Mexico station 1 is Acapulco 
% 
% SINTAXIS
%	snoplot(Compoent)
%
% IN
%	Component. 'N', 'E' or 'Z' (Default)
% OUT
%	No output parameters.
%
% By Luis Dominguez 2006.
%   ladominguez@ucla.edu

close all
if nargin==0
    Component='z';
    [files N]=ValidateComponent(Component);
    sorting='distance';
elseif nargin==1
    [files N]=ValidateComponent(Component);
    sorting='distance';
elseif nargin==2    
    [files N]=ValidateComponent(Component);
else
    error('snoplot.m - Too many input parameters.')
end

% files cointains the name of the files
% of the available stations

hold on
ix=1;

% FILTER PARAMETERS
NumFiles=length(files);
no_poles=5;
min_f=0.0;
max_f=1.0;

if strcmp(sorting,'distance')
    Index=IndexGenDst(Component); % Sorts the stations by latiude
    disp('Stations sorted by distance.');
    ShowStatics(Component);
else
    Index=IndexGen(Component);
    disp('Stations sorted by latitude.')
end

% This cycle plots the station's seismograms in a sigle figure
B=1:NumFiles;
B=B(Index);
for ii=1:NumFiles 
    full_name=fullfile(pwd,files(ii).name); 
    s=rsac(full_name);
    s.d=s.d-mean(s.d);
    Max=max(abs([s.depmin s.depmax]));
    if Max==0,  continue,	end 
    ys=s.d./Max; % Normalizes the ampitude
    
    Nyquist=0.5*(1/s.dt);
    [b,a]=butter(no_poles,max_f./Nyquist,'low');
%    [b,a]=butter(no_poles,[min_f max_f]./Nyquist);
%    [b,a]=butter(no_poles,min_f./Nyquist,'high');
    ys=filter(b,a,ys);
    ys=ys./max(abs(ys));
    plot(s.t,2*ys+find(Index==ii),'k');


end
hold off;
axis tight;
xlabel('Time (s)');
ylabel('Station ID')
SetTitle(Component,s);
axis([min(s.t) max(s.t) 0 NumFiles+1]);

if strcmp(sorting,'distance')    
    List=GetStaNamesDst(Component);
else
    List=GetStaNames(Component);
end

set(gca,'YTick',(1:NumFiles));
set(gca,'YTickLabel',List);
%set(gca,'XTick',[0 10 20 30 40 50 60 70 80 90 100 150 200]);
set(gca,'XMinorTick','on');
set(gcf,'Color','w')

disp(['Number of stations - ' num2str(NumFiles)]);
