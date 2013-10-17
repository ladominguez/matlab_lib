function sac_out = downsample_sac(sac, fs)

dtnew = 1/fs;
step  = round(dtnew/sac.dt);

sac.t = sac.t(1:step:end);
sac.d = sac.d(1:step:end);
sac.e = sac.t(end);
sac.npts = numel(sac.d);
sac.dt   = sac.t(2) - sac.t(1);

sac_out = sac;