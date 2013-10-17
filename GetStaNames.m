function List=GetStaNames(Component)
% GetStaNames.m
%
% GETSTANAMES: Get the names of the station sorted by latitude.
%
%	Syntaxis
%		List=GetStaNames('Component')
%
%	IN: Compoent ('N', 'E' or 'Z');
%
%	OUT: An array of Nx4 with the name of N stations.
%
%	Author:
%		Luis A. Dominguez. 2007
%
	%if nargin==0
	%	Component='Z';
	%end

[files NumFiles]=ValidateComponent(Component);


Index=IndexGen(Component);
List=char(ones(NumFiles,4));

for ii=1:NumFiles
    FullName=fullfile(pwd,files(ii).name);
    s=rsac(FullName);
    name=s.kstnm;
%    [p name]=readheader(FullName);
	List(find(Index==ii),:)=name(1:4);
end
end
