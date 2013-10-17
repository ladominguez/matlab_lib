function [Vp Vs h]=IASPEI()
% [Vp Vs h]=IASPEI()
% 
% IASPEI modiel page 166;
% OUT
%   Vp  P wave speed.
%   Vs  S wave speed.
% 
%   By Luis Dominguez 2007.

Vp1=5.8;
Vp2=6.5;
VmP=8.04; 

Vs1=3.36;
Vs2=3.75;
VmS=4.49;



Vp=[Vp1 Vp2 VmP]; % Before Vp1=5.8 Vp2=6.5 8.04
Vs=[Vs1 Vs2 VmS]; % Before Vs1=3.36 Vs2 =3.75 VmS=4.49
h =[20 15];
