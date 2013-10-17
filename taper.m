function sac=taper(sac,width,type)
%   sac=taper(sac,width,type)
%
%   tapers sac structure
%          sac:  Input sac structure.
%          width: between 0.0 and 0.5
%           type: Hanning(default)|Hamming|Cosine
%                   no-case sensitive.


if nargin == 1
    type='HANNING';
    width=0.05;
elseif nargin == 2
    type='HANNING';
else
    error('Error in taper.m')
end
if isstruct(sac)
    y=sac.d;
else
    y=sac;
end
type=upper(type);
N  = length(y);
N1 = ceil(N*width);

switch type
    case 'HANNING'
        F0=0.50; 
        F1=0.50; 
        OMEGA=pi/N1;
    case 'HAMMING'
        F0=0.54; F1=0.46; OMEGA=pi/N1;
    case 'COSINE'
        F0=1.00; F1=1.00; OMEGA=pi/(2*N1);
    otherwise
        F0=0.50; F1=0.50; OMEGA=pi/N1;
end

y(1:N1)=y(1:N1).*reshape((F0-F1.*cos(OMEGA*(0:N1-1)')),size(y(1:N1)));
y(end-N1+1:end)=y(end-N1+1:end).*reshape((F0-F1*cos(OMEGA*(N1+1:2*N1)')),size(y(end-N1+1:end)));

if isstruct(sac)
    sac.d=y;
else
    sac=y;
end