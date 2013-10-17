function latlons=GenLatLons(Component)
% latlons=GenLatLons(Component)
% Returns the latitud and longitud of every sac file in the
% DATA subdirectory. For a given component.
% IN
%   Component.  'N', 'E' or 'Z'
% OUT
%   latlons.    Nx2 matrix
%
%   By Luis Dominguez 2007.

if nargin==0
    Component='Z';
end
Component=upper(Component);

% if strcmp(Component,'ALL')
%     if strcmp(getenv('OS'),'Windows_NT')
%         load C:\MATLAB7\work\MASE_files\latlon_all.txt % Stations must be ordered by latitude
%     else
%         load /home/antonio/mat_work/MASE_files/latlon_all.txt
%     end
%     latlons=latlon_all;
%     return % I changed this so only works for 'all'
% end


[files N]=ValidateComponent(Component); % Modified 04/21/09


NFiles=length(files);
latlons=zeros(NFiles,2);

for ii=1:NFiles
    fullname=fullfile(pwd,files(ii).name);
    %    p=readheader(fullname);
    a=rsac(fullname);
    latlons(ii,:)=[a.stla a.stlo];
end












