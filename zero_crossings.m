function szc=zero_crossings(s)
sg=sign(s);
szc=find(sg(1:end-1)~=sg(2:end));
