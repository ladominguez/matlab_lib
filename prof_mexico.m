function profile_mexico(h)

load /home/antonio/lib/mexico_profile.txt
plot(h,mexico_profile(:,4),mexico_profile(:,3),'k',...
	'LineWidth',2)
xlabel('Distance [km]')
ylabel('Elevation [m]')
fontsize(12)
