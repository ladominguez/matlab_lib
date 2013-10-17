function z=FFTshift(signal,delay,sample_Frequency);
% Created by Piero Poli polipiero85@gmail.com

X=signal; %signal to shift
Fs=sample_Frequency; %sample frequency
Xdelta=1/Fs;

TF=fft(X);
w=[0:floor((numel(X)-1)/2) -ceil((numel(X)-1)/2):-1]/(Xdelta*numel(X));

 TFshifted=TF.*exp(-i*w*2*pi*delay);
n1=ceil(abs(delay)/Xdelta);
Xs=real( ifft(TFshifted) );
if delay <0
OUTPUT_SIGNAL(1:numel(X)-n1)=Xs(1:numel(X)-n1);
elseif delay>0
 OUTPUT_SIGNAL(n1:numel(X))=Xs(n1:numel(X));
end

z=OUTPUT_SIGNAL;
