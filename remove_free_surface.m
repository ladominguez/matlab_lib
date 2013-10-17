close all
clear all

p=0.1:0.01:0.3;
alpha=5.8;
beta=3.5;

qa=sqrt(alpha^-2-p.^2)
qb=sqrt(beta^-2-p.^2);
Vpz=-(1-2*beta^2*p.^2)./(2*alpha*qa);
Vpr=p*beta^2/alpha; Vsz=p*beta;
Vsr=(1-2*beta^2*p.^2)./(2*beta*qb);  Vht=0.5*ones(size(p));

plot(p,abs(Vpz),p,Vpr,p,Vsz,p,abs(Vsr),p,Vht)

