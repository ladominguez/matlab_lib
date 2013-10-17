function [a b]=weighted_linearleast_squares(x,y)

sx=sum(x);
sy=sum(y);

sxoss=mean(x);

t=x-sxoss;
st2=sum(t.^2);

b=sum(t.*y);

b=b/st2;
ss=length(x)
a=(sy-sx*b)/ss;

siga=sqrt((1+sx^2/(ss*st2))/ss);
sigb=sqrt(1/st2);



