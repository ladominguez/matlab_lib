% From Aki and Richards Page 144 Scatering MATRIX
% This scrips evaluates the scattering matrix. 
% For a function  see funcScat.m

alpha1=6.5;alpha2=8;beta1=6.5/sqrt(3);beta2=8/sqrt(3); rho1=2800;rho2=3200;
pmax=1/beta1;   
for i=1:1000;
p=pmax/1000*i;
i1=asin(p*alpha1); i2=asin(p*alpha2);j1=asin(p*beta1);j2=asin(p*beta2);

a= rho2*(1-2*beta2^2*p^2)-rho1*(1-2*beta1^2*p^2); b=rho2*(1-2*beta2^2*p^2)+2*rho1*beta1^2*p^2;
c= rho1*(1-2*beta1^2*p^2)+2*rho2*beta2^2*p^2;     d=2*(rho2*beta2^2-rho1*beta1^2);               

E=b*cos(i1)/alpha1+c*cos(i2)/alpha2;      F=b*cos(j1)/beta1+c*cos(j2)/beta2;
G= a-d*cos(i1)/alpha1*cos(j2)/beta2;     H=a-d*cos(i2)/alpha2*cos(j1)/beta1;

D=E*F+G*H*p^2;  
D2=det(M)/(alpha1*alpha2*beta1*beta2);

Earray(i)=E;
Farray(i)=F;
Garray(i)=G;
Harray(i)=H;
Darray(i)=D;
PdPuC(i)=((b*cos(i1)/alpha1-c*cos(i2)/alpha2)*F-(a+d*cos(i1)/alpha1*cos(j2)/beta2)*H*p^2)/D;
SdPuC(i)=-2*cos(j1)/beta1*(a*b+c*d*cos(i2)/alpha2*cos(j2)/beta2)*p*beta1/(alpha1*D);            
PuSdC(i)= 2*cos(i2)/alpha2*(a*c+b*d*cos(i1)/alpha1*cos(j1)/beta1)*p*alpha2/(beta2*D);            
SuPuC(i)=2*rho2*cos(j2)/beta2*H*p*beta2/(alpha1*D);
end
%plot(parray,real(SuPuC),parray,SuPu,'r*');figure(1)
plot(parray,real(PuSdC),parray,PuSd,'r*');figure(1);

