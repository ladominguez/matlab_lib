function sac=vel2disp(Component)

if nargin==0
    Component='ALL';
end

if isstruct(Component)
    sac=Component;
    delta=sac.dt;
    disp=cumsum(sac.d).*delta;
    sac.d=disp;
else
[files subdir]=ValidateComponent(Component); 

N_files=length(files);

for i=1:N_files
    full_name=fullfile(pwd,subdir,files(i).name);
    s=rsac(full_name);
    delta=s.dt;
    disp=cumsum(s.d).*delta;
    s.d=disp;
    wsac(s,['D' files(i).name]);
end

end