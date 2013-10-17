% hoshiba Monte Carlo simulation
%% Particles
clear
close all
imax=3000;
Steps=300;
theta_sum=0;
s_sum=0;
dx_sum=0;
dy_sum=0;
X=zeros(imax,Steps+1);
Y=zeros(imax,Steps+1);
T=zeros(imax,Steps+1);
R=zeros(imax,Steps+1);
for i=1:imax;  %%%%% particle number
    for j=1:Steps;   % number of brownian steps
        theta=rand(1)*2*pi;
        s=rand(1);
        dx=s*cos(theta);
        dy=s*sin(theta);
        dx_sum=dx_sum+dx;
        dy_sum=dy_sum+dy;
        s_sum=s_sum+s;
        X(i,j+1)= dx_sum;
        Y(i,j+1)= dy_sum;
        T(i,j+1)= s_sum;
        R(i,j+1)=sqrt(X(i,j+1).^2+Y(i,j+1).^2);
    end
    s_sum=0;
    dx_sum=0;
    dy_sum=0;
    
end
plot(X',Y')
figure(1)
pause(1)
figure(2)
hold on
%%%%%%%%%%%%%%%%%%%% Sort data into times and distances %%%%
for j=1:2:20;  %distance
    for i=1:1000;% times
        I1(i)=length(find(R>j-1 & R<=j & T>(i-1)*0.1 &T<i*0.1));
    end
    % semilogy(I1)
    coda(j,:)=I1;
    disp(j)
end
plot(coda');
hold off
