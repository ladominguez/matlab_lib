function yaxis_in_minutes()

YLim=get(gca,'YLim');

minc=ceil(YLim(1)/60);
maxc=floor(YLim(2)/60);

thick_y=(minc:maxc)';
for i=1:length(thick_y)
    label(i,:)=[num2str(thick_y(i)) ':00'];
end
set(gca,'YTick',thick_y*60)
set(gca,'YtickLabel',label)