function create_locsat()

[files N]=ValidateComponent('Z');

N=length(files);
fid=fopen('dist.locsat','w');
fprintf(fid,'n\t# This is a locsat format file - Luis Dominguez \n');
fprintf(fid,'1\t# Number of depth samples\n');
full_name=fullfile(pwd,files(1).name);
s=rsac(full_name);
fprintf(fid,'%d\n',s.evdp);
fprintf(fid,'%d\t# number of distances\n',N);
for i=1:N
     full_name=fullfile(pwd,files(i).name);
     s=rsac(full_name);
     event=[s.evla s.evlo];
     stat=[s.stla s.stlo];
     delta=distance(event,stat);
     fprintf(fid,'%3.4f\t \n',delta);
 end
%deltas=GenDeltas(); % I assume there is the same number of 
%                   % files in the E, Z and N components.
%fprintf(fid,'%3.4f\n',deltas)         

fclose(fid)
type dist.locsat
