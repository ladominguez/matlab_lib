function v=graph_vel()
baz=133;    % Backazimuth
ar=16;      % Array strike
a=ginput(2);
hold on
plot(a(:,1),a(:,2),'g','LineWidth',3);

dist=(a(2,1)-a(1,1))%*111.1;
dt=(a(2,2)-a(1,2))

if baz>ar & baz<=(180-ar) % The wave is coming from the east
    alpha=(baz-90)-ar
else
    alpha=ar+(360-(baz+90))
end

v=dist/dt;
disp(['Apparent vel: ' num2str(v) ' km/s'])
%v=v/sind(alpha);
disp(['Corrected apparent vel: ' num2str(v) ' km/s'])

text(a(1,1),a(1,2),[num2str(v,'%10.2f') ' km/s'],...
    'Color','w','BackgroundColor','k','HorizontalAlignment',...
    'Right','VerticalAlignment','Bottom')