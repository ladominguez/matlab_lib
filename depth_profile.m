clear all
close all

bins_depth = 0:2:100;
bins_dist  = 0:5:200;
[files N]=ValidateComponent('z');


for k = 1: N
    sac          = rsac(files(k).name);
    depths(k)    = sac.evdp;
    distances(k) = sac.dist; 
%     if depths(k) > 40.0
%         movefile(sac.filename,'Depth_events')
%     end
end

ref_sta = sac.kstnm;
subplot(2,1,1)
hist(depths,bins_depth)
xlim([bins_depth(1) bins_depth(end-1)])
xlabel('Depth [km]')
ylabel('No. of Earthquakes')

subplot(2,1,2)
hist(distances,bins_dist)
xlim([bins_dist(1) bins_dist(end-1)])
xlabel('Distances [km]');
ylabel('No. Earthquakes');
% N_elem = histc(depths, bins);
% C_elem = cumsum(N_elem);
% bar(bins, C_elem)
% draw_vert(10)
% xlabel('Depth [km]')
% ylabel('No. of Earthquakes')
suptitle(ref_sta(1:4))
setw

saveas(gcf, [ref_sta(1:4) '_depth_profile'],'jpg')
