
M=[3.09	94.26   9.0  nan nan nan 
43.05   146.81  6.8  163 38  15
42.48   144.82  6.7  248  19  124
37.89   142.68  7.0  196  9  80 
32.94   137.00  7.2  277 38 100
33.13   137.22  7.4  79  46  72
42.86	145.37  7.0  242    26  122
42.21	143.84  8.3  250    11  132
38.94	141.57  7.0  352    19  70
33.97	132.52  6.8  323    39  -121%59
35.33 133.20    6.7  241    89  173
%35.33	133.20  6.7  331    83  1
48.77	142.03  6.8  328    36  60 
22.32	143.76  7.6  255    6   -127%53
24.15	120.80  7.6  37 25  96
22.37	125.53  7.4  139    82  1];

lat=M(:,1); lon=M(:,2); mag=M(:,3); strike=M(:,4); dip=M(:,5); rake=M(:,6);
latlim=[20 50]; lonlim=[120 150];
myjapan=gshhs('gshhs_h.b',latlim,lonlim);a=length(myjapan);
%h = worldmap('japan'); mstruct=getm(h);
%setm(gca,'fontsize',14,'fontname','hp system');
%geoshow(h,'worldlakes.shp', 'FaceColor', 'cyan')
%geoshow(h,'worldrivers.shp', 'Color', 'blue')
%grid on
figure(1)
set(gca,'box','on','DataAspectRatioMode','manual','fontsize',16,'fontname','Helvetica');
v=[120 150 20 50];
axis(v)
 hold on
for i=1:a
    patch(myjapan(i).Lon, myjapan(i).Lat,[0.15 .5 .15])
end

%geoshow('landareas.shp', 'FaceColor', [0.15 0.5 0.15])
%geoshow(myjapan,'landareas','Facecolor',[0.15 0.5 0.15])

hold on

a=length(M(:,1));
for i=2:a
    beachball((strike(i)+0),(dip(i)),(rake(i)+0),lon(i),lat(i),mag(i)/6,'r')
end



