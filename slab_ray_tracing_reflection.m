function slab_ray_tracing_reflection(i,Baz)
% v=slab_ray_tracing(i,Baz)
% This program computes and calculate the ray path and the travel times for
% an incoming P wave that hits the slab at an oblique angle. In this case
% we consider that the origin (0,0,0) is Mexico City and the slab is
% subducting Northwards at an angle alpha.
%
% By Paul Davis and Luis Dominguez, Nov 2008.
% 
% for m=1:5;
% for j=1:19

%clc
%clear all
close all

% All angles are measured in degrees.
%  INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%
    i=90;       % Incident angle measured from the vertical
    Baz=360;      % Backazimuth
    alpha=45;   % Dipping angle of the slab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

az=Baz-180;     % Azimuth of the incomming wave
alpha=70;   % Diping angle of the slab
num_sta=5;  % Number of stations
spacing=50; % Spacing in km
D=50;      % Offset in km
Vp=8.0;
Vs=8.0;
%Vs=Vp;
FS=20;

% X is North
% Y is East
% Z is Up


r=[sind(i)*cosd(az),sind(i)*sind(az),cosd(i)];% Incident ray - unit vector
n=[sind(alpha),0,cosd(alpha)];  % Perpendicular to the slab.
theta=acosd(-r*n')              % Incident angle.
%phi=asind(sind(theta)/sqrt(3)); % Refracted angle. I commented this line
                                 % bc I think is wrong.
phi=-theta;                      % Incident anggle is equal to reflected angle                                 

xp=cross(-r,n)./sind(theta);     % x' unitary vector - Lies inside the 
                                % slab.
yp=-r;                           % y' unitary vector - antiparallel to the 
                                % inicident angle.
zp=cross(xp,yp);                 % z' unitary vector - It is not inside the 
                                % slab.
delta=theta-phi                % Angle between o and y'
o=[ cosd(delta)*yp(1)+sind(delta)*zp(1),...
    cosd(delta)*yp(2)+sind(delta)*zp(2),...
    cosd(delta)*yp(3)+sind(delta)*zp(3)]; % o refrated ray
% figure
% plot([0 r(1)],[0 r(3)],'b');
% hold on
% 
% plot(-[0 r(1)],-[0 r(3)],'k','LineWidth',2)
% plot([0 n(1)],[0 n(3)],'g');
% plot([0 o(1)],[0 o(3)],'r','LineWidth',2)
% axis equal
% grid
% return
R=[ 1, 0, 0, o(1); ...
    0, 1, 0, o(2); ...
    0, 0, 1, o(3); ...
    1, 0, cotd(alpha), 0];
eigen_values=sort(eig(R),'descend')


% Slab picture
figure(1)
set(1,'tag','slab')
x_s=0:10:200;
y_s=-100:10:100;
[Xs Ys]=meshgrid(x_s,y_s);
Zs=-Xs.*tand(alpha);
mesh(Xs,Ys,Zs);
%shading interp
%colormap gray
%light('Position',[100 0 0],'Style','infinite');
xlabel('North','FontSize',FS)
ylabel('East','FontSize',FS)
zlabel('Depth','FontSize',FS)
set(gca,'YDir','rev')
hold on
mesh(Xs,Ys,zeros(size(Zs)),'FaceAlpha',0.5)


for k=1:num_sta
    x=(k-1)*spacing;
    y=0;
    z=0;
    X=[x y z 0]';
    
    X0=pinv(R)*X;
    s=X0(4);
    
    rb_x=[X0(1)-D*r(1), X0(1)];
    rb_y=[X0(2)-D*r(2), X0(2)];
    rb_z=[X0(3)-D*r(3), X0(3)];
    % b stands for backwards
    
    o_x=[X0(1), X0(1)+o(1)*s];
    o_y=[X0(2), X0(2)+o(2)*s];
    o_z=[X0(3), X0(3)+o(3)*s];
    % f stands for forward
    
   plot3(o_x,o_y,o_z,'r','LineWidth',1.5)
   

   
   d=r(1)*X0(1)+r(2)*X0(2)+r(3)*X0(3)+D;
d=abs(d);  % ?????????????

   ri1=[X0(1)-d*r(1),X0(1)];
   ri2=[X0(2)-d*r(2),X0(2)];
   ri3=[X0(3)-d*r(3),X0(3)];
   
   plot3(ri1,ri2,ri3)
   
   x_sta(k)=x;
   Tss(k)=s/Vs;   % Time from the (s)lab to the (s)urface
   Tps(k)=d/Vp;   % Time from the (p)lane wave to the (s)lab
   
       
end
plot3(x_sta,zeros(size(x_sta)),zeros(size(x_sta)),'o')


T=Tss+Tps;

DT=T-min(T);
Vapparent=x_sta./DT
set(gca,'ydir','reverse')
title(['V_{apparent}=' num2str(Vapparent(end),'%10.2f') ' km/s'],'FontSize',15);
set(gcf,'Color','w')
Content=['\alpha: ' num2str(alpha) '    i: ' num2str(i)];
annotation('textbox','EdgeColor','w','Position',[0 0 0.3 0.1],'String',Content)

%Va(j,m)=Vapparent(end);

% end
% end
%az=180+5*((1:19)-1)                                ;
%close all
%plot(az,Va)                                