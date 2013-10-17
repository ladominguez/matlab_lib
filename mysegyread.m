%filenm='C:\SMONICA\SMONICA.SEGY'
filenm='SMONICA.SEGY' 

[FID, MESSAGE] = fopen(filenm,'r','ieee-be')

[A, COUNT] = fread(FID,3600,'char');
char(A)'

%fseek(fid,3600+4*8240,-1),[A] = fread(4,4,'int'),fread(4,1,'int'),fread(4,1,'int'),ftell(4)
% Max jj =166
% shots to be plotted
for jj=1:336
kk=0
for i=1:336

fseek(FID,3600+((jj-1)*336+i)*8240,-1),[A] = fread(FID,1200,'int');
%plot(A)
%figure(1)
%pause(1)
kk=kk+1;
%seis(i,1:1200)=(A+kk*1e8)';
seis(i,1:1200)=(A/max(A)+kk*1)';

end
figure(1)
 plot(seis')
 pause(1)
 offset=(jj-1)*(336*8240);
 myreadhdr
end