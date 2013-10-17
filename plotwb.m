function plotwb(Component, shift,lineup)
% plotwb(Component, shift)
%
% Plots the seismis records using wigb.
%
% IN.
%   Component. East ('E'), North ('N') and Vertical ('Z')
%              (capitalization is not required)
%   Shift.     Starting Value.
% OUT. 
%   Not Output
%               By Luis A. Dominguez 2008
%                  ladominguez@ucla.edu

close all

if nargin==0 | Component=='Z' | Component=='z'
    Component='Z';
end

[A t]=AllRecords(Component);
SF=1/(t(2)-t(1)); % Sampling frequency
tin=t(1); % This must be read it directly from the header - CHANGE IT

if exist('lineup','var')
    load PArrival.dat;
    minimum=min(PArrival);
    PArrival=PArrival - minimum;
    PArrival=PArrival*SF;
    
    for i=1:size(A,1)
        A(i,:)=circshift(A(i,:)',-round(PArrival(i)))';
%        A(i,:)=circshift(A(i,:)',10000)';
    end
end

SF=100; % Sampling frequency

t1=t(1);
%t=0:size(A,2)-1;
%t=t./SF+t1;


if nargin>=2
    t=t+shift;
else    
    %e=earthquake();
    t=t;%+e.shift;
end

NF=size(A,1);
x=1:NF;

wigb(A',1,x,t);
ShowStatics(Component);
sac_file=dir('*.sac');
sac=rsac(sac_file(1).name);
SetTitle(Component,sac);

List=GetStaNamesDst(Component);
set(gca,'XTick',(1:NF));
set(gca,'XTickLabel',List);
xticklabel_rotate;

setw
