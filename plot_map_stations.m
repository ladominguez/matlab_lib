figure
plot_map_mexico

[files subdir N]=ValidateComponent('Z');

for k=1:N
	s=rsac(fullfile(pwd,subdir,files(k).name));
	plot(s.stlo,s.stla,'^','MarkerFaceColor','r','MarkerSize',8);
        text(s.stlo,s.stla,s.kstnm);
end

