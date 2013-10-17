function [index dst]=IndexTrench(Component)
% distances=index_trench(files)
%
% Generate an index to the trench to read the files dorted in ascending 
% order by distance to the trench. This index can be later use as: (ex)
%
% sorted_index=index_trench('Z')
% for m=1:Number_files
%       sac=rsac(files(sorted_index(m)).name))
%       etc...
% end
%
% It also returns the distances to the trench and the last sac file read.
%
% By Luis Dominguez July 2010
[files N]=ValidateComponent(Component);

for k=1:N
	s=rsac(files(k).name);
	dst(k)=distance2trench(s);
end

[dst index]=sortrows(dst');


