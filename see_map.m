function see_map(file)

if nargin == 0
    file=dir('*.EVT');
    A = load(file.name);
else
    A = load(file);
end
    

%A = load(file.name)

latitude  = A(:,2);
longitude = A(:,1);

plot_map_mexico()

plot(longitude,latitude,'ko');

