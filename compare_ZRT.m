function compare_ZRT
close all
[filesR N]=ValidateComponent('R');
[filesT N]=ValidateComponent('T');
[filesZ N]=ValidateComponent('Z');

for k=1:N
	sacR=rsac(filesR(k).name);
	sacT=rsac(filesT(k).name);
	sacZ=rsac(filesZ(k).name);
	plot(sacR.t,sacR.d,sacT.t,sacT.d,sacZ.t,sacZ.d);
    powerR(k)=sum(sacR.d.^2)/sacR.npts;
    powerT(k)=sum(sacT.d.^2)/sacT.npts;
    powerZ(k)=sum(sacZ.d.^2)/sacZ.npts; 
    dist_tr(k)=distance2trench(sacZ);
	legend('Radial','Tangential','Vertical');
    xlabel('Time [s]');
    ylabel('Amplitude [counts]');
	setw
	pause
end

figure
plot(dist_tr,[powerR' powerT' powerZ'],'s')
legend('Radial','Tangential','Vertical');
xlabel('Distance to the trench [km]')
ylabel('|u^2|')
setw


