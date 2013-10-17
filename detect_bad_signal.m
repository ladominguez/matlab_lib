function detect_bad_signal();

[files N ] = ValidateComponent('ALL');


for k = 1:N
	sac = rsac(files(k).name);
	amp(k) = sum(sac.d);

end

plot(amp)
