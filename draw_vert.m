function h=draw_vert(pos,color,width,line_type)
% draw_vert(pos,color,width) - Plots a vertical line.
% 
%   pos   - x axis position
%   color - default 'red'
%   width - Line width deafult = 1.0
% By Luis Dominguez - ladominguez@ucla.edu

if nargin==1
    color='r';    
    width=1.0;
    line_type = '-';
elseif nargin==2
    width=1.0;
    line_type = '-';
elseif nargin==3;
    line_type = '-';
end

ylim=get(gca,'YLim');
if ~ishold
    hold on
end

if nargout==0
    plot([pos pos],ylim,color,'LineWidth',width,'LineStyle',line_type);
else
    h=plot([pos pos],ylim,color,'LineWidth',width,'LineStyle',line_type);
end
hold off