function [Index Distances]=IndexGenDst(Component)
%INDEXGEN: Generates an index of the station sorted by distance.
%
%	Syntaxis:
%		Index=IndexGen(Component)
%
%	IN:	Componen - 'Z', 'N' or 'E'.
%
%	OUT: 	Index
%
%	Author:
%		Luis A. Dominguez, April 2007.
%	

if nargin==0
    Component='Z';
end
Component
[files N]=ValidateComponent(Component)

% This cicle create a index to sort the stations by distance
for k=1:N
    fullname=fullfile(pwd,files(k).name);        
    a=rsac(fullname);        
    dist(k)=a.gcarc;    
end

[Distances Index]=sort(dist);

end
