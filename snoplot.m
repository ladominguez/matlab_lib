function []=snoplot(Component,sorting,h)
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
Markers='off';

if nargin==0
    Component='z';
    [files N]=ValidateComponent(Component);
    sorting='distance';
    close all;
    h=gca;
elseif nargin==1
    [files N]=ValidateComponent(Component);
    sorting='distance';
    close all;
    h=gca;
elseif nargin==2    
    [files N]=ValidateComponent(Component);
    close all;
    h=gca;
elseif nargin==3
    [files N]=ValidateComponent(Component);    
else
    error('snoplot.m - Too many input parameters.')
end

% files cointains the name of the files
% of the available stations

hold on
ix=1;
NumFiles=length(files);

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
plot(h,s.t,2*ys+find(Index==ii),'k');
    if s.a ~= -12345 & strcmp(Markers,'on')
            plot(h,s.a,find(Index==ii),'r*')
    end
    for k=1:10
        if s.picks(k)~=-12345 & strcmp(Markers,'on')
            plot(h,s.picks(k) ,find(Index==ii),'*')
%        plot(s.picks(1)+WinSize,dist,'*')
        end        
    end

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

set(h,'YTick',(1:NumFiles));
set(h,'YTickLabel',List);
%set(gca,'XTick',[0 10 20 30 40 50 60 70 80 90 100 150 200]);
set(h,'XMinorTick','on');
set(gcf,'Color','w')

disp(['Number of stations - ' num2str(NumFiles)]);
