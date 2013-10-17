clear all
close all
[delta_sta times_sca]=tt_slab(330,2.27);

close all;
snoplotDist('N');
t=plotmarkers_horiz();
t=sortrows(t);
ns=length(times_sca);
t(end-ns+1:end,1)';

ts=t(end-ns+1:end,1)'+times_sca
hold on
plot(ts,delta_sta,'r','LineWidth',2)
