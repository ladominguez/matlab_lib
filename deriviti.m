%PROGRAM deriviti
% sets up derivitive matrix for lsq inversion
mmm=length(a);nnn=length(y);
dela=a/100000;
for j=1:mmm,
a(j)=a(j)+dela(j);
func;ff2=f;
a(j)=a(j)-2*dela(j);
func;ff1=f;
a(j)=a(j)+dela(j);
am(1:nnn,j)=[(ff2 - ff1)/(2*dela(j))]';
end

