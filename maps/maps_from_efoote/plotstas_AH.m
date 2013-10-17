%plot the different MASE sections with different symbols

%ALLEN  -- LOAD MY_STAION_NAMES NOT LATLONS
%plot Mexico background
figure(1)
clf
worldmap('Mexico')
%Mapper

%get MASE station locations to be plotted
fid=fopen('my_station_list');
latlons=fscanf(fid,'%*d %*s %*s %f %f %*d %*s %*s', [2 inf])';
fclose(fid);

msize=3.5;

%Caltech Sur stations
I=find(latlons(:,1)<18.65);
plotm(latlons(I,1),latlons(I,2),'k.');%,'MarkerSize',msize);

%Cuernavaca line
I=find(latlons(:,1)>18.65 & latlons(:,1)<19.07);
plotm(latlons(I,1),latlons(I,2),'kx');%,'MarkerSize',5);

%UNAM line
I=find(latlons(:,1)>19.07 & latlons(:,1)<19.61);
plotm(latlons(I,1),latlons(I,2),'k^');%,'MarkerSize',5);

%Pachuca line
I=find(latlons(:,1)>19.61 & latlons(:,1)<20.13);
plotm(latlons(I,1),latlons(I,2),'k+');%,'MarkerSize',msize);

%Caltech norte
I=find(latlons(:,1)>20.13 & latlons(:,1)<20.81);
plotm(latlons(I,1),latlons(I,2),'k.');%,'MarkerSize',msize);

%4 line
I=find(latlons(:,1)>20.81 & latlons(:,1)<21.01);
plotm(latlons(I,1),latlons(I,2),'ks');%,'MarkerSize',msize)

%Huejutla
I=find(latlons(:,1)>21.01);
plotm(latlons(I,1),latlons(I,2),'kd');%,'MarkerSize',msize)

%Direct to Internet
plotm(19.3735,-99.1832,'ko');%,'MarkerSize',msize) % MIXC
plotm(19.4364,-99.1294,'ko');%,'MarkerSize',msize) % MULU

%true standalone
plotm(19.2711,-99.1372,'k.');%,'MarkerSize',msize) % TEPE
plotm(19.3870,-99.1573,'k.');%,'MarkerSize',msize) % CIRE
plotm(19.5335,-99.1422,'k.');%,'MarkerSize',msize) % ARBO
plotm(20.1413,-98.6816,'k.');%,'MarkerSize',msize) % MIMO

axis off
set(gcf,'Color',[1 1 1])