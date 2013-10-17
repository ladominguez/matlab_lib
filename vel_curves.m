clear all
close all
incident=20:1:70;
baz=120:2.55:240;

Va=zeros(length(baz),length(incident));

for i=1:length(baz)
    disp(['BackAzimuth ' num2str(baz(i))])
    for j=1:length(incident)
        disp(['i= ' num2str(incident(j))])
        Va(i,j)=slab_ray_tracing(incident(j),baz(i));
    end
end

imagesc(baz,incident,Va')
colormap('hot')
colorbar
title('\alpha = 50\circ','FontSize',20)
set(gca,'FontSize',20)
xlabel('Backazimuth [Degrees]','FontSize',20)
ylabel('Incident Angle [Degrees]','FontSize',20)
set(gcf,'Color','w')