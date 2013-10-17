function acel2vel(Component)

if nargin==0
    Component='ALL';
end

[files subdir]=ValidateComponent(Component); 

N_files=length(files);

for i=1:N_files
    full_name=fullfile(pwd,subdir,files(i).name);
    s=rsac(full_name);
    delta=s.dt;
    disp=cumsum(s.d).*delta;
    s.d=disp;
    wsac(s,['V' files(i).name]);
end

