function z=FFTshift(signal,delay,sample_Frequency);
% Created by Piero Poli polipiero85@gmail.com

X=signal; %signal to shift
NX = numel(X);
Fs=sample_Frequency; %sample frequency
Xdelta=1/Fs;

TF=fft(X);
w=[0:floor((NX-1)/2) -ceil((NX-1)/2):-1]/(Xdelta*NX);

TFshifted     = TF.*exp(-i*w*2*pi*delay);
n1            = ceil(abs(delay)/Xdelta);
Xs            = real( ifft(TFshifted) );
OUTPUT_SIGNAL = Xs;

if n1 > NX % DRLA
    n1=NX;
end
    
if delay <0
    OUTPUT_SIGNAL(1:NX-n1)=Xs(1:NX-n1);
    OUTPUT_SIGNAL(NX-n1+1:end)=0;
elseif delay>0
     OUTPUT_SIGNAL(n1:NX)=Xs(n1:NX);
     OUTPUT_SIGNAL(1:n1-1)=0;
end

z=OUTPUT_SIGNAL(1:NX);

