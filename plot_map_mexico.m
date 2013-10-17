 function plot_map_mexico(handle,region)
% Plots the map of Mexico
%	Syntaxis:
%		plot_map_mexico()
%	IN:
%		handle(optional): Handle to the axis where is going to plot the
%		                  data.
%       region:           'MASE' or 'IG'
%	OUT:
%		NOT OUTPUT ARGUMENTS
%
%	Author: Luis A. Dominguez. 08/2008.


if nargin==0
    close all;
    figure;
    handle=gca;
    region='MASE';
elseif nargin==1
    if ischar(handle)
        close all;
        figure;
        region=handle;
        handle=gca;        
    else
        region='MASE';
    end
end
map=shaperead('/home/antonio/lib/maps/MX_STATE.SHP');

if strcmp(upper(region),'MASE')
    latlim=[15 25];
    lonlim=[-106 -96];
else
    latlim=[15 30];
    lonlim=[-118 -85];
end

mapshow(map,'FaceColor',[1 1 1],'DisplayType', 'polygon','Parent',handle)
axis([lonlim latlim])
axis equal
hold on

grid
set(gcf,'color','w')
box on