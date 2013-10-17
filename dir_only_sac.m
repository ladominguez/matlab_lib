function [directories Nd]=dir_only_sac()
% Lists dirctories that contint sac files only.
% [directories Nd]=dir_only_sac()
dir_tmp=dir('*');

j=1;
for k=1:length(dir_tmp)
	if dir_tmp(k).isdir & ~strcmp(dir_tmp(k).name,'.') & ...
		~strcmp(dir_tmp(k).name,'..')
		dir_tmp2=dir(fullfile(pwd,dir_tmp(k).name,'*Z.sac'));
		if ~isempty(dir_tmp2)
			directories(j)=dir_tmp(k);
			j=j+1;
		end
	else
		continue;
	end
end

if ~exist('directories')
    directories=[];
    Nd=0;
else
    Nd=numel(directories);
end
   
