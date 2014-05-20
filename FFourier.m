function [f X]=FFourier(x,Fs)
% [f X]=FFourier(x,Fs)

if isstruct(x)
    Fs = 1/x.dt;
    x  = x.d;
end
    
    
    

T=1/Fs;
L=length(x);
NFFT=2^nextpow2(L);
X2=fft(x,NFFT)/L;
X=X2(1:NFFT/2+1);
f=Fs/2*linspace(0,1,NFFT/2+1);

if nargout==0
    subplot(2,1,1)
    semilogy(f,2*abs(X))
    loglog(f,2*abs(X))
    xlabel('Frequency Hz')
    ylabel('2*abs(X)')
    xlim([0.0 10])
    grid
    subplot(2,1,2)
    plot((0:L-1).*T,x)
    grid
    f=0;
    X=0;
else
    f = Fs/2*linspace(0,1,NFFT)';
    X = X2*L;
end

