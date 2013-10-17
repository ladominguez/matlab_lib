function snoplot1s(name,component)
if nargin == 1
	component='Z';
end
component=upper(component);

file=dir(['*' name '*' component '.sac']);

sac=rsac(file(1).name);
figure
plot(sac.t,sac.d)
setw
