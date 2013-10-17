function [t d]=mark_first_arrival(Component,zoom)
% [t d]=mark_first_arrival(Component,zoom)
%
% Displays record by record and saves the graphical input
% in the "a" field of the sac file.
% 
% Component. Default 'T'
% zoom.      Optional - Default "off"
%
% By Luis Dominguez Nov 2008
close all
if nargin==0
    Component='T';
end

disp(['Component: ' Component])

[files subdir]=ValidateComponent(Component);
N=length(files);

for i=1:N
    full_name=fullfile(pwd,subdir,files(i).name); 
    s=rsac(full_name);
    plot(s.t,s.d)
    title([num2str(i) ' out of ' num2str(N)])
    set(gca,'Xlim',[zoom-20 zoom+20])
    if s.picks(1)~=-12345
        hold on
        draw_vert(s.picks(1))
        hold off
    end
    [t(i) a]=ginput(1);
    s.a=t(i);
    t(i)=s.a;
    wsac(s,full_name);
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
