function h=draw_vert(pos,color,width)
% draw_vert(pos,color,width) - Plots a vertical line.
% 
%   pos   - y axis position
%   color - default 'black'
%   width - Line width deafult = 1.0
% By Luis Dominguez - ladominguez@ucla.edu

if nargin==1
    color='k';    
    width=1.0;
elseif nargin==2
    width=1.0;
end

xlim=get(gca,'XLim');
if ~ishold
    hold on
end

if nargout==0
    plot(xlim,[pos pos],'Color',color,'LineWidth',width);
else
    h=plot(xlim,[pos pos],'Color',color,'LineWidth',width);
end
hold off
