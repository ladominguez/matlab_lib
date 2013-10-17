function []=snoplot_all(Component)

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
%
close all

if nargin==0
    [files subdir]=ValidateComponent();
    Component='z';
elseif nargin==1
    [files subdir]=ValidateComponent(Component);
else
    error('Too many input paramenters');    
end

% files cointains the name of the files
% of the available stations

hold on
ix=1;
NumFiles=length(files);

Index=IndexGen(Component); % Sorts the stations by latiude

% This cycle plots the station's seismograms in a sigle figure
for ii=1:NumFiles
    full_name=fullfile(pwd,subdir,files(ii).name); 
    code=files(ii).name(19:22);
    [t ys p]=readsac(full_name);
    ys=ys-mean(ys);
    Max=max(abs(ys));
    if Max==0,  continue,	end 	
    ys=ys./max(abs(ys)); % Normalizes the ampitude
    position=get_station_position(code);

    plot(t,ys+position,'k');
	
end
hold off;
axis tight;
xlabel('Time');
ylabel('\Delta [Degrees]')
SetTitle(Component);
axis([0 max(t) 0 101]);

List=get_complete_list();

set(gca,'YTick',(1:100));
set(gca,'YTickLabel',List);
set(gca,'FontSize',8);
%set(gca,'XTick',[0 10 20 30 40 50 60 70 80 90 100 150 200]);
set(gca,'XMinorTick','on');

disp(['Number of stations - ' num2str(NumFiles)]);
