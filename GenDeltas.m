function [Deltas I]=GenDeltas(Component)

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

if strcmp(Component,'all')
        if strcmp(getenv('OS'),'Windows_NT')
            load C:\MATLAB7\work\MASE_files\latlon_all.txt % Stations must be ordered by latitude
        else
            load /home/antonio/mat_work/MASE_files/latlon_all.txt
        end
        [files N]=ValidateComponent(); % I assume I have at least one file in the Z component, to obtian the EQ position
        FullName=fullfile(pwd,files(1).name);
        s=rsac(FullName);
        e=[s.evla s.evlo];
        Deltas=distance(latlon_all,ones(length(latlon_all),1)*e);
        [Deltas I]=sortrows(Deltas); 
        return
end


if exist('./EarthquakeParams.dat','file')
    e=earthquake();
    ValidateComponent(Component);
    latlons=GenLatLons(Component);
    %                             || I need this on Windows
    %                             \/
    Deltas=distance(latlons,ones(length(latlons),1)*e.latlon);
    Deltas=sortrows(Deltas);
else
    [files subdir]=ValidateComponent(Component);
    NumFiles=length(files);
    for ii=1:NumFiles
        fullname=fullfile(pwd,files(ii).name);
        s=rsac(fullname);             
        Deltas(ii,1)=distance([s.evla s.evlo],[s.stla s.stlo]);
    end
    [Deltas I]=sortrows(Deltas);
end

end
