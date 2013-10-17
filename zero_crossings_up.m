function szc=zero_crossings_up(s)
% Finds zero crossings when the signal goes from negative to positive
% values (positive gradient).
%
sg=sign(s);
szc=find(sg(1:end-1)~=sg(2:end) & sg(2:end) > sg(1:end-1));
