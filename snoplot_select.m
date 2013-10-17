function []=snoplot_select(Component)
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
Markers ='on';
low_f   = 1;
high_f  = Inf;

close all
if nargin==0
    Component='z';
    [files N]=ValidateComponent(Component);
elseif nargin==1
    [files N]=ValidateComponent(Component);
else
    error('snoplot.m - Too many input parameters.')
end

if N==0
    return;
end
% files cointains the name of the files
% of the available stations

hold on
ix=1;

disp(['Filtering ' num2str(low_f) ' - ' num2str(high_f) ' Hz.'])
ShowStatics(Component);

% This cycle plots the station's seismograms in a sigle figure
Index=IndexGenDst(Component);
List=char(ones(N,4));
for k=1:N
    full_name = fullfile(pwd,files(Index(k)).name); 
    s         = rsac(full_name);
    List(k,:) = s.kstnm(1:4);
    s.d       = s.d-mean(s.d);
    s         = filter_sac(s, low_f, high_f, 2);
    Max=max(abs([s.depmin s.depmax]));
    if Max==0,  
        ys=zeros(sizeof(s.d));
    else
        ys=s.d./Max; % Normalizes the ampitude
    end
    h(k)=plot(s.t,2*ys+k,'k');  
    
    
end
disp(['Event Depth - ' num2str(s.evdp) ' km.'])
hold off;
axis tight;
xlabel('Time (s)');
ylabel('Station ID')
%SetTitle(Component,s);
axis([min(s.t) max(s.t) 0 N+1]);

set(gca,'YTick',(1:N));
set(gca,'YTickLabel',List);
set(gca,'XMinorTick','on');
set(gcf,'Color','w')

title('Left click to delete - Middle click deletes all - Right click to finish',...
    'Color','r','FontSize',14,'FontWeight','bold')
set(gcf,'OuterPosition',[923 100 800 1000])
if ~exist('Noisy','dir')
    mkdir('Noisy');
end
while 1
    [dummy stations button] = ginput(1);
    if button == 1;   % left click
        sta_ind = round(stations);
        delete(h(sta_ind))
        disp(['Moving ' files(Index(sta_ind)).name ' to Noisy folder.'])    
        movefile(files(Index(sta_ind)).name,'Noisy');
    elseif button == 2 % Middle buttom
        for k = 1:N
            delete   (h(k))
            disp     (['Moving ' files(Index(k)).name ' to Noisy folder.'])    
            movefile ( files(Index(k)).name, 'Noisy' );                                   
        end
        break
    elseif button == 3
        break;
    end 

end
close all

