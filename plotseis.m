%plots seis
function plotseis(seis,gain1,dt)
clf
hold on
seisar=0;
[m n]=size(seis);
%%% use transpose if wrong structure)
if n>m; seis=seis'; 
    [m n]=size(seis); 
end

num    = n;
ik     = 0;
nstart = 1;
nend=m;
T=[nstart:1:nend]*dt;
%seis=seis-mean(seis);

for i=1:1:num,
    ik   = ik+1;
    gain = gain1/(max(abs(seis(nstart:nend,i))));
    seisar(nstart:nend,i)=(gain*seis(nstart:nend,i)+i);
end
plot(T,seisar,'k')
hold off
setw