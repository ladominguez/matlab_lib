close all
clear all
clc
N=2000; % Number of particles
Duration=300; % Number of step
directivety=deg2rad(45); % Directivety
theta0=linspace(0,360,N);
%theta0=0:5:355;
snew=1;
s_sum=0;
dx_sum=0;
dy_sum=0;
X=zeros(N,Duration+1);
Y=zeros(N,Duration+1);
T=zeros(N,Duration+1);
R=zeros(N,Duration+1);
for k=1:N
    for m=1:Duration
        s=rand(1);
        new_pos=s*exp(-i*deg2rad(theta0(k)));
        dx=real(new_pos);
        dy=imag(new_pos);
        theta_aux=theta0(k);
        theta0(k)=theta_aux+rad2deg(directivety*randn(1));
        dx_sum=dx_sum+dx;
        dy_sum=dy_sum+dy;
        s_sum=s_sum+s;
        X(k,m+1)= dx_sum;
        Y(k,m+1)= dy_sum;
        T(k,m+1)= s_sum;
        R(k,m+1)=sqrt(X(k,m+1).^2+Y(k,m+1).^2);
    end
    s_sum=0;
    dx_sum=0;
    dy_sum=0;
    disp(k)
end
plot(X',Y')
axis equal
setw
figure(2)
hold on
Ndist=7;
Ntimes=500;
distances=linspace(0.05*max(max(R)),0.35*max(max(R)),Ndist);
times=linspace(0,0.7*max(max(T)),Ntimes);
dt=times(2);
dR=1;

for j=1:1:Ndist;  %distance
    for l=1:Ntimes;% times
        I1(l)=length(find(R>distances(j) & R<=distances(j)+dR & ...
            T>times(l) &T<times(l)+dt));
    end
    coda(j,:)=I1;
    disp(j)
end
plot(times,coda')
hold off
setw;
legend(num2str(distances'))
title(['Directivety = ' num2str(rad2deg(directivety)) ' \circ'])

return
%%%%%%%%%%%%%%%%SIMULACION CHAQUETA%%%%%%%%%%%%%%%%%%%%%%%
for i=1:Duration
plot(X(:,i),Y(:,i),'.')
axis([-100 100 -100 100])
pause(0.05)
clf
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:N
    for m=1:Duration
        s(m)=rand(1);
        new_pos=s(m)*exp(-i*deg2rad(theta0(k)));
        dx(m)=real(new_pos);
        dy(m)=imag(new_pos);
        theta_aux=theta0(k);
        theta0(k)=theta_aux+rad2deg(directivety*randn(1));
    end
    X(k,:)=[0 cumsum(dx)];
    Y(k,:)=[0 cumsum(dy)];
    T(k,:)=[0 cumsum(s)];
    R(k,:)=sqrt(X(k,:).^2+Y(k,:).^2);
    disp(k)
end
