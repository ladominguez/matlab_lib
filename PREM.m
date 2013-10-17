%IASPEI modiel page 166;
function [Vp Vs h]=PREM(layer)

Vp1=5.8;
Vp2=6.5;
VmP=8.04; 

Vs1=3.46;
Vs2=3.85;
VmS=4.48;

Vp=[Vp1 Vp2 VmP]; % Before Vp1=5.8 Vp2=6.5 8.04
Vs=[Vs1 Vs2 VmS]; % Before VsX1=3.36 Vs2 =3.75 VmS=4.49
h =[20 15];

if nargin==1    
    Vp=Vp(layer);
    Vs=Vs(layer);
   % h=h(layer);
end