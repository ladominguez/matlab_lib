% plot rays from Guerrero Earthquake
%run MyTTimes first
VmP=8.04; VmS=4.49;
Depth=50;
h1=20;h2=15; d=Depth-h1-h2;
z1=Depth;z2=h1+h2; z3=h1; z4=0;
%IASPEI model page 166;
VmP=8.04; VmS=4.49;
Vp1=5.8;Vp2=6.5;
Vs1=3.36;Vs2=3.75;
%%%%%%%%%%%%%%%%%%%%%%%PP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=P(1,69);
thetamP=asin(p*VmP);
thetacP1=asin(p*Vp1);
thetacP2=asin(p*Vp2);
X1=0;
X2   =d*tan(thetamP)   
X3   =h2*tan(thetacP2);
X4   =h1*tan(thetacP1);
x=[X1 X1+X2 X1+X2+X3 X1+X2+X3+X4];
z=[-z1 -z2 -z3 -z4];
subplot(5,1,1)
plot(x,z,[0 max(x)],[-z2 -z2],[0 max(x)], [-z3 -z3])
TravelT=T(1,69);
text(250,-h/2,num2str(TravelT))
axis image
title('PuPu')
%%%%%%%%%%%%%%%%%%%%%%%SUPU%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SuPu;
p=P(2,69);
thetamP=asin(p*VmP);
thetamS=asin(p*VmS);
thetacP1=asin(p*Vp1);
thetacP2=asin(p*Vp2);
X1=0;
X2   =d*tan(thetamS);   
X3   =h2*tan(thetacP2); 
X4   =h1*tan(thetacP1);
x=[X1 X1+X2 X1+X2+X3 X1+X2+X3+X4];
z=[-z1 -z2 -z3 -z4];
subplot(5,1,2)
plot(x,z,[0 max(x)],[-z2 -z2],[0 max(x)], [-z3 -z3])
TravelT=T(2,69);
text(250,-h/2,num2str(TravelT))
axis image
title('SuPu')
%%%%%%%%%%%%%%%%%%%%%%%SUPgPg%%%%%%%%%%%%%%%%%%%%%%%%%
%SuPu;
p=P(3,69);
thetamP=asin(p*VmP);
thetamS=asin(p*VmS);
thetacP1=asin(p*Vp1);
thetacP2=asin(p*Vp2);
thetacS1=asin(p*Vs1);
thetacS2=asin(p*Vs2);
X1=0;
X2   =d*tan(thetamS);   
X3   =h2*tan(thetacS2); 
X4   =h1*tan(thetacS1);
X5   =h1*tan(thetacP1); 
X6   =h1*tan(thetacP1);
x=[X1 X1+X2 X1+X2+X3 X1+X2+X3+X4 X1+X2+X3+X4+X5 X1+X2+X3+X4+X5+X6];
z=[-z1 -z2 -z3 -z4 -z3 -z4];
subplot(5,1,3)
plot(x,z,[0 max(x)],[-z2 -z2],[0 max(x)], [-z3 -z3])
TravelT=T(3,69);
text(250,-h/2,num2str(TravelT))
axis image
title('SuPgPg')


%%%%%%%%%%%%%%%%%%%%%%%SUPbPb%%%%%%%%%%%%%%%%%%%%%%%%%
%SuPu;
p=P(4,69);
thetamP=asin(p*VmP);
thetamS=asin(p*VmS);
thetacP1=asin(p*Vp1);
thetacP2=asin(p*Vp2);
thetacS1=asin(p*Vs1);
thetacS2=asin(p*Vs2);
X1=0;
X2   =d*tan(thetamS);   
X3   =h2*tan(thetacS2); 
X4   =h1*tan(thetacS1);
X5   =h1*tan(thetacP1); 
X6   =h2*tan(thetacP2);
X7   =h2*tan(thetacP2);
X8   =h1*tan(thetacP1); 
xx=[X1 X2 X3 X4 X5 X6 X7 X8]
x=cumsum(xx);
z=[-z1 -z2 -z3 -z4 -z3 -z2 -z3 -z4];
subplot(5,1,4)
plot(x,z,[0 max(x)],[-z2 -z2],[0 max(x)], [-z3 -z3])
TravelT=T(4,69);
text(250,-h/2,num2str(TravelT))
axis image
title('SuPbPb')

%%%%%%%%%%%%%%%%%%%%%%%SuSu%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=P(5,69);
thetamS=asin(p*VmS);
thetacS1=asin(p*Vs1);
thetacS2=asin(p*Vs2);
X1=0;
X2   =d*tan(thetamS)   
X3   =h2*tan(thetacS2);
X4   =h1*tan(thetacS1);
x=[X1 X1+X2 X1+X2+X3 X1+X2+X3+X4];
z=[-z1 -z2 -z3 -z4];
subplot(5,1,5)
plot(x,z,[0 max(x)],[-z2 -z2],[0 max(x)], [-z3 -z3])
TravelT=T(1,69);
text(250,-h/2,num2str(TravelT))
axis image
title('SuSu')
xlabel('Distance km')
break
