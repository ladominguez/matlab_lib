function envelope=get_envelope(f)
% envelope=get_envelope(sac)
% Luis Dominguez 

envelope=abs(hilbert(abs(f)));
