clear all; close all; clc
sampling=100;  % In Hz
WinSize=20;  % Time in seconds
WinSize=WinSize*sampling;
[A_aux t]=AllRecords('t');
figure(1);
plotwb('t')
add2title(' -- Maximum')

hold on

n_sta=size(A_aux,1);
for i=1:n_sta
    A=A_aux(i,:)';
    A_next=circshift(A,-1);
    Ap=(A_next-A)*100;
    s=sign(Ap);
    sp=(s(2:end)-s(1:end-1));
    maxs=find(sp < -1); % Maximum
    mins=find(sp > 1);  % Minimum

    plot(i,t(maxs),'b*')
end

