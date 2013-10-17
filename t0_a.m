function t0_a()
%
% This is a provisional function to correct mis burradas.
%
% Luis Dominguez Oct 11, 2008

[files subdir]=ValidateComponent('all');

N=length(files);
for i=1:N
    full_name=fullfile(pwd,subdir,files(i).name);
    s=rsac(full_name);
    s.a=s.picks(1);
    %s.picks(1)=-12345;
    disp(['Writing ' full_name '...'])
    wsac(s,full_name);
end

