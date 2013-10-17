function [vel dis]=vel_conversion()

fid=fopen('/home/antonio/mat_work/MASE_files/stations_name_lat.txt');

if fid<=0
    error('Error readin station_name_lat.txt')
end

flag = 0;
jj=1;
while 1
    line=fgetl(fid);
    if isnumeric(line)
        break
    end
    if strcmp(line,'MULU')
        flag=1;
    end
    
    fileA=['*' line '*' 'T' '.sac'];

    fnameA=dir(fileA);
%    fnameB=dir(fileB);
    if (~isempty(fnameA)) && flag    
        s1=rsac(fnameA(1).name);
%        s2=rsac(fnameB(1).name);
        plot(s1.t,s1.d,'LineWidth',2)
%        legend(cmpA)
        axis tight
        grid
        title(s1.kstnm)
        vel(jj,:)=ginput(1)
        dis(jj)=s1.gcarc;
        jj=jj+1;
    end
   
end