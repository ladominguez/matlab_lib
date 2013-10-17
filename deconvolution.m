% deconvolution.m
%
% deconvolution(level, Component)
% IN:
%          Component - 'R' radial or 'T' tangential - no case sensitive
% OUT:
%          TODO
% Deconvolves either
%             r(t)=s(t)*v(t) or,
%             t(t)=s(t)*v(t).
%
%  By Luis Dominguez, 2008
%     ladominguez@ucla.edu

function deconvolution(level, Component)

if nargin==0
    level=0.001;
    Component='T';
elseif nargin==1
    Component='T';
end

[vert subdir]=ValidateComponent('z');
[horz subdir]=ValidateComponent(Component);

dt=0.01;  % NOTE. Change this in a future version

N=length(vert);

for ii=1:N
    vertical=fullfile(pwd,subdir,vert(ii).name);
    horizontal=fullfile(pwd,subdir,horz(ii).name);
    num=rsac(horizontal);
%    average=dir('*ZAVG.sac');
     average=dir('20050926015537.TO.TEPE.HHZ.sac');
    den=rsac(average.name);
   % tshift=num.picks(1)-num.beg(1)-10;
    tshift=num.a-num.beg(1)-10;
    [decon t]=wlevel(num, den, level,tshift);
    decname=strrep(vertical,'HHZ',['DC' upper(Component)]);
    decon.o=0;
    decon.picks=zeros(10,1);    decon.stla = num.stla;
    decon.stlo = num.stlo;      decon.stel = num.stel;
    decon.stdp = num.stdp;      decon.evla = num.evla;
    decon.evlo = num.evlo;      decon.evel = num.evel;
    decon.evdp = num.evdp;      decon.mag  = 0;
    decon.user = zeros(1:10);   decon.dist = num.dist;
    decon.az   = num.az;        decon.baz  = num.baz;
    decon.gcarc= num.gcarc;     decon.nz   = num.nz;
    decon.kstnm= num.kstnm;     decon.kevnm= num.kevnm;
    wsac(decon,decname);
    disp([num2str(ii) ' out of ' num2str(N)])
    
end
    
plotwbd(['DC' Component]);
 




