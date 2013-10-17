function OUT=select_events(minlat,maxlat,minlon,maxlon)
%function select_events(minlat,maxlat,minlon,maxlon)
%
%

A=load('/home/antonio/lib/MASE_files/LATLON-EVENT-SSN');
N=size(A,1);
fid = fopen('/home/antonio/lib/MASE_files/EVENT-SSN');
j=1;
OUT=[0 0];
for k = 1:N
    line=fgetl(fid);
    if A(k,1) >= minlat && A(k,1) <= maxlat
         if A(k,2) >= minlon && A(k,2) <= maxlon
              disp(line)
              OUT(j,:)=A(k,:);
              j=j+1;
         end
    end
end
