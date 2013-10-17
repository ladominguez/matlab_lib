function movnoisy(name,component)
if nargin == 1
        component='Z';
end
component=upper(component);

file=dir(['*' name '*' component '.sac']);
movefile(file(1).name,'./Noisy')
disp([file(1).name ' was moved to Noisy.'])
