function max_v=get_maximums(s)

% function max_v=get_maximums(s) 

sp=diff(s); % First derivative
sg=sign(sp);
szc=find(sg(1:end-1)~=sg(2:end));

spp=diff(sp); % Second derivative
test=spp(szc);
sgt=-sign(test);
mm=sgt.*szc;
max_i=find(mm>0);
% szm=find(sg(1:end-1)~=sg(2:end) && );

max_v=szc(max_i)+1;

