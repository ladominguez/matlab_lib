function ShowStatics(Component)

Component=upper(Component);
if exist('Title.dat','file')
    fidTitle=fopen('Title.dat');
    Title=fgetl(fidTitle);
else
    Title='';
end

[filesN N]=ValidateComponent(Component);

[stat,mess]=fileattrib([pwd '/*H' Component '.sac']);   
%[stat,messE]=fileattrib('DATA/*HHE*');   
%[stat,messZ]=fileattrib('DATA/*HHZ*');   

DD    = GenDeltas(Component);
DDmin = min(DD);
DDmax = max(DD);

latlons = GenLatLons(Component);
LatMin  = min(latlons(:,1));
LatMax  = max(latlons(:,1));

LonMin  = min(latlons(:,2));
LonMax  = max(latlons(:,2));

disp(' ');
disp(Title)
%disp(' ')
%disp(['Epicenter latitud: ' num2str(e.latitud)]);
%disp(['Epicenter longitud: ' num2str(e.longitud)]);
%disp(['Depth: ' num2str(e.depth)]);
%disp(' ');
disp(['Number of records in the ' Component ' component: ' num2str(length(mess))]);
%disp(['Number of records in N: ' num2str(length(messN))]);
%disp(['Number of records in E: ' num2str(length(messE))]);
disp(' ');
%disp(['Minimum latitud: ' num2str(LatMin)]);
%disp(['Maximum latitud: ' num2str(LatMax)]);
%disp(['Minimum longitud: ' num2str(LonMin)]);
%disp(['Maximum longitud: ' num2str(LonMax)]);
%disp(' ');
disp(['Minimum delta: ' num2str(DDmin) ' -> ' ...
	num2str(111.1*DDmin) 'km']);
disp(['Maximum delta: ' num2str(DDmax) ' -> ' ...
	 num2str(111.1*DDmax) 'km']);
%rmin = sqrt(num2str(111.1*DDmin));
disp(['Minimum Hypocentral distance ' ]);
%disp();
disp(' ');
end

