function set_params(file)
% set_params(file)
% 
% Reads the text file in CMT format. You should run 
% create_subdir.m first. You should run this function
% from the base directory. It will go to every directory 
% create the file EarthquakeParams.dat with three lines.
% Latitude, longitude and depth. You need this file to run
% functions such as snoplot.m, snoplotDist.m, plotwb.m and
% plotwbd.m
%
% TODO: Rewrite this program in shell.
%
% INPUT file= File name.
%       By Luis Dominguez, Nov 2008
  

fin=fopen(file);
% Latitude l(31:36)
% Longitude l(38:44)
% Depth l(47:48)

while 1
    l=fgetl(fin);
    if ~ischar(l),    break,  end
    latitude=str2num(l(31:36));
    longitude=str2num(l(38:44));
    depth=str2num(l(47:48))*1000;
    dir=[l(9:12) l(15:16) l(18:19) l(21:26)];
    cd(dir)
    fa=fopen('EarthquakeParams.dat','w');
    fprintf(fa,'%3.2f\n',latitude);
    fprintf(fa,'%3.2f\n',longitude);
    fprintf(fa,'%d',depth);
    fclose(fa);
    cd('..')
end

fclose(fin);

