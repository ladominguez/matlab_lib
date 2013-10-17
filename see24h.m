function see24h(sac)
close all
mmax = sac.depmax;
mmin = sac.depmin;
for k=1:1440
   plot(sac.t((k-1)*100+1:k*100+1),sac.d((k-1)*100+1:k*100+1))
   ylim([mmin mmax])
   pause(0.1)
end 
