jj=0;
kk=0;
for i=1:336
%fseek(FID,3600+(i-1)*(8240),-1),[A] = fread(FID,60,'short');
fseek(FID,3600+(i-1)*8240+offset,-1); [A] = fread(FID,60,'short');

kk=kk+1;
%seis(i,1:1200)=(A+kk*1e8)';
head(kk,1:60)=A';
end
y=head(1:336,44);
x=head(1:336,42);
xs=head(1:336,38);
ys=head(1:336,40);
figure(2)
plot(x,y,'+',xs,ys,'*r')
axis equal
pause(1)


flag=-1;


for ii=1:336
dist(ii)=sqrt((xs(ii)-x(ii)).^2+(ys(ii)-y(ii)).^2);
if abs(dist(ii))<0.001, flag=1; end
dist(ii)=dist(ii)*flag;
end