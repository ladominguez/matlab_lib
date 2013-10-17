clear all
map=shaperead('/home/antonio/lib/maps/MX_STATE.SHP');

fid=fopen('states_mx.gmt','w+');

for i=1:length(map)
   X=map(i).X;
   Y=map(i).Y;
   for j=1:length(X)
       if isnan(map(i).X(j))
           fprintf(fid,'>\n');
       else 
       fprintf(fid,'%3.4f %3.4f\n',[map(i).X(j) map(i).Y(j)]);
       end 
   end
end

fclose(fid)