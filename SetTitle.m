% [Title handle]=SetTitle(Component,sac)
%
% Writes the title in the current figure. 
% 
% FILES:	
% 	Title.dat Contains the name of the event
% IN:
% 	Component: 'N', 'E' or 'Z'.
%	Default:   'Z'.
%   sac: sac strcture.
% OUT:
%	Not output arguments.
%
% By Luis Dominguez 2007.
%    ladominguez@ucla.edu

function [Title handle]=SetTitle(Component, sac)

if exist('Component','var')
    CompAux=Component;
    Component=upper(Component);
end
    
if nargin==0 | strcmp(Component,'Z')
	Comp='Vertical'; 
elseif strcmp(Component,'E')
	Comp='East';
elseif strcmp(Component,'N') 
	Comp='North';
elseif strcmp(Component,'R')
	Comp='Radial';    
elseif strcmp(Component,'T')
	Comp='Tangential';  
elseif strcmp(Component,'DCT')
	Comp='Deconvolution tangetial component';     
elseif strcmp(Component,'DCR') 
	Comp='Deconvolution radial component';     
elseif strcmp(Component,'CRR')
    Comp='Autocorrelation Radial Component';
elseif strcmp(Component,'CRT')    
    Comp='Correlation of the Radial and tangential component'
elseif strcmp(Component,'NONE')
    Comp='';
else
	Comp=CompAux;
end
yy=sac.nz(1);
[mm dd]=jul2greg(sac.nz(2),yy);

date=[num2str(mm) '/' num2str(dd) '/' num2str(yy)];
time=[num2str(sac.nz(3),'%.2d') ':' num2str(sac.nz(4))];

if sac.user(1)~=-12345 && sac.user(2)~=-12345     % Band pass
    Band=[num2str(sac.user(1)) '-' num2str(sac.user(2)) 'Hz'];
elseif sac.user(1)~=-12345 && sac.user(2)==-12345 % High pass
    Band=[num2str(sac.user(1)) '-Inf Hz'];
elseif sac.user(1)==-12345 && sac.user(2)~=-12345 % low pass
    Band=['0-' num2str(sac.user(1)) 'Hz']
else
    Band='Raw';
end

Title=[sac.kevnm ' - ' date ' - ' time ' - ' ...
    'Magnitude: ' num2str(sac.mag,'%2.1f') ' - ' ...
    Band ' - ' Comp];
Title=strrep(Title,'_',' ');

if nargout==0
    title(Title,'FontSize',16);
end

if nargout==2
    handle=title(Title,'FontSize',16);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% if exist('Title.dat','file')
%     fidTitle=fopen('Title.dat');
% elseif exist('../Title.dat','file')
%     fidTitle=fopen('../Title.dat');
% else
%     return;
% end
% comand=['!ls .. | grep ' char(39) 'Hz' char(39)]; % char(39)='
% Band=evalc(comand);
% Title=fgetl(fidTitle);
% Title=[Title ' - ' Comp ' - ' Band];
% title(Title,'FontSize',12,'FontWeight','bold');
% end
