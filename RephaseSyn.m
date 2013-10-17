%Rephase changes the phases of seismograms by the travel
% time T run MyTTimes first
function RephaseSyn(seis)
load T;
NumSta=58;
seis=seis';
clear Rseis
for i=1:NumSta
    
    Rseis(:,i)=[rephase(seis(i,1:14000),1,1000-T(1,i)*100)]';
    
end
pseis=Rseis;
x=[1:NumSta];
load deltas;
clf
[n m]=size(pseis);
z=[1:1:n]/100;
wigb2(pseis,1,deltas,z)
