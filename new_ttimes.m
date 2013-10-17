function [times phases]=new_ttimes(Wave)
% [phases times]=NewTTimes(Wave)
% Returns the travel times for a specific wave. 
% IN
%	Wave. 	Phase name ('P', 'S', 'SKS', etc.)
% OUT
%	phase.  Phases name.
%	times. 	travel times.
%
% By Minoo Kosarian and Luis Dominguez 2008.
phases=evalc(['!./new_ttimes.fex | cut -b 1-7']);
times=evalc([['!./new_ttimes.fex | grep ''\<' Wave '\>''| cut -b 10-1040']]);

times=str2num(times);

