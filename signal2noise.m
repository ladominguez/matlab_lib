function snr=signal2noise(sac);

if sac.picks(1) == -12345
	error(['Header Empty' pwd '/' sac.filename]);
end

noise_i  = find(sac.t >=5 & sac.t <=10);
signal_i = find(sac.t >= 2*sac.picks(1) & sac.t < 2*sac.picks(1) +5 );

noise  = sac.d(noise_i);
signal = sac.d(signal_i);

snr=rms(signal)/rms(noise);

