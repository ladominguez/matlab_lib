function [X deltas]=dist_from_DF()

[files subdir]=ValidateComponent();
ACAP=[16.8839  -99.8494]; % Acapulco, Mexico
MULU=[19.4368  -99.1296]; % Museo de la Luz, Mexico City
d0=distance(ACAP,MULU);
N=length(files);
j=1;
for i=1:N
    fullname=fullfile(pwd,subdir,files(i).name);
    s=rsac(fullname);
    latlon=[s.stla s.stlo];
    dsta=distance(ACAP,latlon);
    if dsta>=d0
        X(j)=distance(MULU,latlon)*111.1;
        deltas(j)=s.gcarc;
        j=j+1;
    end
end