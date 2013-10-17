function retarded_time()
close all
Comp='t';
factor=10;
V=8;
filtering='n';
no_poles=6;
min_f=1;
max_f=10;

[files subdir N]=ValidateComponent(Comp);
figure;
hold on;

for k=1:N
	sac=rsac(fullfile(pwd,subdir,files(k).name));
	sac=normalize(sac);
	sac.d=sac.d.*factor;
	if strcmp(filtering,'y')
		Nyquist=0.5*(1/sac.dt);
        [b,a]=butter(no_poles,[min_f max_f]./Nyquist);
        sac.d=filter(b,a,sac.d);
	end
        plot(sac.dist+sac.d, sac.t-sac.dist/V,'k')

end

ylim([0 100]);
box on
set(gcf,'color','w')
SetTitle(Comp,sac);
xlabel('Distance [km]')
ylabel('T-Distance/8.0 [s]')
hold off
