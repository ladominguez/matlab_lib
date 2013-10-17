function mat=taper(mat,width,type)
%   sac=taper(mat,width,type)
%
%   tapers each column of a matrix 
%            mat:  matrix.
%          width:  between 0.0 and 0.5
%           type:  Hanning(default)|Hamming|Cosine
%                            no-case sensitive.
% Luis Dominguez - ladoimguez@ucla.edu

if nargin == 1
    type='HANNING';
    width=0.05;
elseif nargin == 2
    type='HANNING';
else
    error('Error in taper.m')
end

type=upper(type);
N  = size(mat,1);
M  = size(mat,2);
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

for k=1:M
    mat(1:N1,k)=mat(1:N1,k).*(F0-F1.*cos(OMEGA*(0:N1-1)'));
    mat(N-N1+1:N,k)=mat(N-N1+1:N,k).*(F0-F1*cos(OMEGA*(N1+1:2*N1)'));
end
