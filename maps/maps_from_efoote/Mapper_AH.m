clear all;
close all

%set lat lon limits
%latlim = [16, 22]; %Close up on MASE stations
latlim=[12, 35];
%latlim = [43 46];
%latlim=[32.5,49.5];
%lonlim = [-100, -98];  %Close up on MASE stations
lonlim = [-120, -85];
%lonlim=[-118 -114];
%lonlim=[-125,-109];
%scalefactor=1;
%[topo,topolegend] = tbase(scalefactor, latlim,lonlim);

axesm('MapProjection','eqdcylin',...
      'ParallelLabel','on',...
      'PLabelLocation',10,...
      'MeridianLabel','on',...
      'MLabelLocation',10,...
      'MLabelParallel','south',...
      'Grid','on',...
      'MLineLocation',10,...
      'PLineLocation',10,...
      'MapLatLimit',latlim,...
      'MapLonLimit',lonlim,...
      'Frame','off')
%      'Origin',[33 53])

%lis=dteds(latlim,lonlim);
%for i=1:length(lis)
%    [topo,topolegend]=dted(['C:\Documents and Settings\default\My Documents\maps' lis{i}]);
%    meshm(topo,topolegend)
    %pause
%    if i==33
%        demcmap(topo)
        %pause
        %    end
        %end
%camlight;
%boundary=extractm(worldhi('Mexico'));
%load worldlo POpatch
%displaym(worldlo('POpatch'))
boundary=extractm(worldlo('POpatch'));
%plotm(boundary,'Color',[0 0 0])
patchm(boundary(:,1),boundary(:,2),[0.75 0.75 0.75])
plotm([latlim(1)+.01 latlim(2)-.1 latlim(2)-.1 latlim(1)+.01 latlim(1)+.01],[lonlim(1)+.01 lonlim(1)+.01 lonlim(2)-.01 lonlim(2)-.01 lonlim(1)+.01],'k','LineWidth',2)
clear boundary
%worldmap 'North America'
axis off
set(gcf,'Color',[1 1 1])

%plot stations
fid=fopen('my_station_list');
latlons=fscanf(fid,'%*d %*s %*s %f %f %*d %*s %*s', [2 inf])';
fclose(fid);
plotm(latlons(:,1),latlons(:,2),'k.','MarkerSize',3.5);


%plot volcanoes
fid=fopen('Volcanoes.dat');
latlons=fgetl(fid);
while(length(latlons>64))
    if str2num(latlons(71:78))>-110 & str2num(latlons(64:69))<30
        plotm(str2num(latlons(64:69)),str2num(latlons(71:78)),'k^');%,'MarkerSize',3.5);
    end
    latlons=fgetl(fid);
end
fclose(fid);
