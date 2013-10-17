function compute_dist_event()
clc
[files subdir N]=ValidateComponent('Z');
event=dir('*.evnt');
fid=fopen(event.name);

line=fgetl(fid);
evnt_loc=str2num(line(37:57));

for i=1:N
    a=rsac(files(i).name);
    pos=[a.stla a.stlo];
    dd=distkm(pos,evnt_loc);
    disp([a.kstnm(1:4) char(9) num2str(pos) char(9)...
        num2str(dd,'%3.2f') 'km']); % char(9)=TAB char(15)=RETURN
end


