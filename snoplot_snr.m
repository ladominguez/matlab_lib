function []=snoplot_snr(Component)
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


Markers='on';
threshold = 3;

clc
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
    return
end

% files cointains the name of the files
% of the available stations

hold on
ix=1;
win=2;   % Time window in s

% This cycle plots the station's seismograms in a sigle figure
Index=IndexGenDst(Component);
List=char(ones(N,4));
counter=0;

for k=1:N
    full_name=fullfile(pwd,files(Index(k)).name); 
    s=rsac(full_name);
    List(k,:)=s.kstnm(1:4);
    s.d=s.d-mean(s.d);
    Max=max(abs([s.depmin s.depmax]));
    if s.dist > 300
        vs=3.9;
    elseif s.dist > 200        
        vs=4.1;
    elseif s.dist > 50
        vs=4.1;
    else
        vs=4.4;
    end
    vp=sqrt(3)*vs;
    tp=s.dist/vp-2;
    if tp < 0  % For very close stations, tp may become negative
        tp=win;
    end
    ts=s.dist/vs;
    noise_ind  = find(s.t<tp ,round(win/s.dt), 'last');
    signal_ind = find(s.t>ts   ,round(win/s.dt), 'first');
    snr=rms(s.d(signal_ind))/rms(s.d(noise_ind));
    
    if snr > threshold
        color='k';
    else
        color='r';
        counter=counter+1;
        files_bad(counter).name=full_name;
        disp(full_name)
    end
    if Max==0,  
        ys=zeros(sizeof(s.d));
    else
        ys=s.d./Max; % Normalizes the ampitude
    end
    
    stations(k,:)=[s.stlo s.stla];
    color_sta(k)=color;
    h(k)=plot(s.t,2*ys+k,color);    
    plot(s.t(signal_ind),2*ys(signal_ind)+k,'b')
    plot(s.t(noise_ind), 2*ys(noise_ind) +k,'g');
    text(s.e + 5,k,num2str(s.dist))
    
end

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
set(gcf,'OuterPosition',[647 26 856 1023])

title('Left click to delete - Right click to cancel',...
    'Color','r','FontSize',14,'FontWeight','bold')
set(gcf,'OuterPosition',[150 100 800 1000])
if ~exist('Noisy','dir')
    mkdir('Noisy');
end
%xlim([0 50])

%% Plot map Mexico %%%%%%%%%%%%%%%%%%%
figure(2)
plot_map_mexico(gca);
hold on
for k=1:N
    plot(stations(k,1),stations(k,2),'^','MarkerSize',6,'MarkerFaceColor',color_sta(k),'MarkerEdgeColor','k')
end
plot(s.evlo,s.evla,'p','MarkerSize',12,'MarkerFaceColor','r')
set(gcf,'OuterPosition',[997   421   746   600])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
[dummy stations buttom]=ginput(1);
close all
if buttom == 3;     
    return; 
end
disp(' ')
if exist('files_bad','var')
    for k=1:length(files_bad)
        disp(['Moving ' files_bad(k).name ' to Noisy folder.'])    
        movefile(files_bad(k).name,'Noisy');
    end
end


