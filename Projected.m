% Run Pwigdata first to plot data and load ad.
% rephases data to line up first arrivals
load PArrival.dat
tphase=PArrival
clear add;
tphase=tphase-mean(tphase)
m=66
for i=1:m,  add(i,:)=rephase(ad(i,1:10000),0.01,-tphase(i));end
% mute
% for i=1:53
% ad(i,1:600)=ones(1,600)*0;
% end
addd=add(:,1500:10000);
 figure(2),clf;wigb(addd',4);figure(2)
title('Guerrero Aug 11 2006 Earthquake')
xlabel('Station')
ylabel('time (s/100)')
load List.dat;
List=char(List);
set(gca,'Xtick',(1:66));
set(gca,'XTickLabel',List(1:66,:));
xticklabel_rotate;
