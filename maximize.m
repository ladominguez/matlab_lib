% MAXIMIZE Maximize a figure window to fill the entire screen
%
% Examples
% maximize
% maximize(hfig)
%
% maximizes the current or input figure so that it filles the whole of the
%screen th the figure is currently on.  This function is platform
%independent
% hfig - handle of the figure to maximize. Default{ gcf
function maximize(hFig)
if nargin <1
hFig=gcf;
end
drawnow; % requirement to avoid java errors
jFig=get(handle(hFig),'Javaframe');
jFig.setMaximized(true);
