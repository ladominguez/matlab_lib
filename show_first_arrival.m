function [t d vel]=show_first_arrival(Component)
% [t d vel]=mark_first_arrival(Component,zoom)
%
% Plots the first arrival in the "a" field of the sac file
% versus the distance. Returns the time the distance and the
% velocity in km/s.
% 
% Component. Default 'T'
% zoom.      Optional - Default "off"
%
% By Luis Dominguez Nov 2008
if nargin==0
    Component='T';
end

disp(['Component: ' Component])

[files subdir]=ValidateComponent(Component);
N=length(files);

for i=1:N
    full_name=fullfile(pwd,subdir,files(i).name); 
    s=rsac(full_name);
    t(i)=s.a;
    d(i)=s.gcarc;
end

aux=sortrows([d' t']);
figure
plot(aux(:,1),aux(:,2),'*')
List=GetStaNamesDst(Component);
set(gca,'XTick',aux(:,1));
set(gca,'XTickLabel',List);
xticklabel_rotate();

% getting the speed
p=polyfit(aux(:,1),aux(:,2),1)
m=1/p(1);
v=m*111.1
y=polyval(p,aux(:,1));
hold on
plot(aux(:,1),y);
d=d*111.1;
