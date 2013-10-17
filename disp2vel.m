function disp2vel(Component)

if nargin==0
    Component='ALL';
end

[files N_files]=ValidateComponent(Component); 

for i=1:N_files
    full_name=fullfile(pwd,files(i).name);
    s=rsac(full_name);
    delta=s.dt;
    vel=derivative(s.d,delta);
    s.d=vel;
    wsac(s,['V' files(i).name]);
end

