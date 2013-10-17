clear_everything
files = dir('*.sac');
N     = numel(files);

for k = 1 : N
	a = rsac(files(k).name);
	if a.evdp > 700
		error('Distance may be in meters.');
    end
    r      = sqrt(a.dist^2 + a.evdp^2);
    s_wave = r/3.7;
	a.picks(1)  = s_wave;
    wsac(a,a.filename);
end
