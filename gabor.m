function y=gabor(time,Tp,Ts)

A=pi.*(time-Ts)/Tp;
y=cos(2*pi.*A)/4.0.*exp(-0.8*A.^2);
