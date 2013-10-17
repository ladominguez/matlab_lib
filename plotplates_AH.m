function plotplates_AH(limits)
%plot all plates on current axis
% plotplates_AH(limts)
%     limits - [min_lon max_lon min_lat max_lat]
%first open extract axis lines

lon_lim=limits(1:2);%[-120 -75];
lat_lim=limits(3:4);%[5 35];
fid=fopen('/home/antonio/lib/maps/plates-1.kml');
plateskml=fscanf(fid,'%c');
fclose(fid);
Icoord=strfind(plateskml,['<coordinates>' char(13)]); %return characters
Icomma=strfind(plateskml,',');
I9=strfind(plateskml,'999.9999999999999 ');
figure(1); hold on
for i=1:length(Icoord)
    if (i+1>length(Icoord))
        continue
    end
    Icomma_=find(Icomma>Icoord(i) & Icomma<Icoord(i+1));
    I9_=find(I9>Icoord(i) & I9<Icoord(i+1));
    ic=1;
    n1=Icoord(i)+15;
    for n=1:length(I9_)
        lon(n)=str2num(plateskml(n1:Icomma(Icomma_(ic))-1));
        n1=Icomma(Icomma_(ic))+1;
        ic=ic+1;
        lat(n)=str2num(plateskml(n1:Icomma(Icomma_(ic))-1));
        n1=I9(I9_(n))+18;
        ic=ic+1;
    end
    %plotm(lat,lon,'k')
    if (max(lon)<=lon_lim(2) && min(lon)>=lon_lim(1) && ...
        max(lat)<=lat_lim(2) && min(lat)>=lat_lim(1))
        plot(lon,lat,'k','LineWidth',2)
    end
    clear lat lon
    
end
