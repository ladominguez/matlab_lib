function sac=sacshift(sac,shift,zero_per)

if nargin==0
	error('Not enough input arguments. sacshift.m');
elseif nargin==1
	error('Not enough input arguments. sacshift.m');
elseif nargin==2
	zero=0.1*(sac.e-sac.beg);  % zero will be locate at 10% of the length of the record.
else 
	 zero=zero_p*(sac.e-sac.beg)/100;   
	error('Too many input arguments. scshift.m')
end

if ischar(shift)
	if strcmp(shift,'a')
		shift_n=sac.a;
    end

    if strcmp(shift(1),'t')
        if length(shift)==2
            k=str2num(shift(2))+1;
            shift_n=sac.picks(k);
            if shift_n==-12345
                error(['Header information empty. sacshift.m ' sac.filename])
            end
        end
    end
else
	shift_n=shift;
end

N_steps=round(-(shift_n-sac.beg-zero)/sac.dt);

sac.d=circshift(sac.d,N_steps);  
sac.t=sac.t-zero;

sac.beg=sac.t(1);
sac.e=sac.t(end);

