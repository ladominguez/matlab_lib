%This main runs synthetics
load deltas; fact=1e-11;
MyTTimes;
syndata=Synth(A,T,deltas);
seis=syndata;
RephaseSyn(seis);
hold
plot(deltas,T(1,:)-T(1,:)+9)
plot(deltas,T(2,:)-T(1,:)+9)
plot(deltas,T(3,:)-T(1,:)+9)
plot(deltas,T(4,:)-T(1,:)+9)
plot(deltas,T(5,:)-T(1,:)+9)
plot(deltas,T(6,:)-T(1,:)+9)

