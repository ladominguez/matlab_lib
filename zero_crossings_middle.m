function tout=zero_crossings_middle(t,s)
% Returns the middle value of a function
sg=sign(s);
szc=find(sg(1:end-1)~=sg(2:end));

for k=1:numel(szc)
	if szc(k)==1
		tout(k)=t(1);
	elseif szc(k)==numel(t)
		tout(k)=t(end)
	else
		tout(k)=(t(szc(k))+t(szc(k)+1))/2;
	end


	
end
