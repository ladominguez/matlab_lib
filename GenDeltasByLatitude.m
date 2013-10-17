function Deltas=GenDeltasByLatitude(Component)

% if nargin==2
% 	if isa(quake,'earthquake')
% 		e=quake;
% 	else
% 		error('The second input must be a class (earthquake) - GenDeltas.m');
% 	end
% elseif nargin==1
% 	e=earthquake();
% elseif nargin==0
%     e=earthquake();
%     Component='Z';
% else
% 	error('Too many input arguments - GenDeltas.m');
% end


if nargin==0
    Component='Z';
end

Component=upper(Component);

if strcmp(Component,'ALL')
    if strcmp(getenv('OS'),'Windows_NT')
        load C:\MATLAB7\work\MASE_files\latlon_all.txt % Stations must be ordered by latitude
    else
        load /home/antonio/mat_work/MASE_files/latlon_all.txt
    end
    %%%  I haven't finish this DRLA 02/2009
else
    ValidateComponent(Component);
    latlons=GenLatLons(Component);
    latlons=sortrows(latlons);
    %                             || I need this on Windows
    %                             \/
    Deltas=distance(latlons,ones(length(latlons),1)*latlons(1,:));
    %    Deltas=sortrows(Deltas);
end
end
