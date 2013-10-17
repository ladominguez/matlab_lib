[n m]=size(seis);
z=[1:1:n]/100;        
wigb(seis,+3,deltas,z);
hold
plot(deltas,T(6,:)-20,'c','linewidth',2)
plot(deltas,T(4,:)-20,'b','linewidth',2)
plot(deltas,T(2,:)-20,'g','linewidth',2)
plot(deltas,T(1,:)-21,'r') 
