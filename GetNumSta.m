function NS=GetNumSta(Component)
% N=GetNumSta(Component)
% 
% Returns the number of sac files available for a given component.
% IN
%   Component. 'N', 'E' or 'Z'
% 
% OUT
%   N   Number of records
%
% By Luis Dominguez 2007.
%
if nargin==0
    Component='Z';
end

files=ValidateComponent(Component);
NS=length(files);
end
