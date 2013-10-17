function xn=normalize(x)
if isstruct(x)
	x.d=x.d./max(abs([x.d]));
	xn=x;
else
	xn=x./max(max(abs(x)));
end
