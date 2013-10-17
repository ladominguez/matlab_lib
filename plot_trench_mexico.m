function [x y]=plot_trench_mexico(handle)
if nargin==0
	handle=gca;
end

load /home/antonio/lib/maps/MEXICO_trench.dat;
plot(MEXICO_trench(:,1),MEXICO_trench(:,2),'k','LineWidth',2);

if nargout==2
	x=MEXICO_trench(:,1);
	y=MEXICO_trench(:,2);
end
