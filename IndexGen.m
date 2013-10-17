function Index=IndexGen(Component)
%   INDEXGEN: Generates an index of the station sorted by latitude.
%
%	Syntaxis:
%		Index=IndexGen(void)
%
%	IN:	NOT INPUT ARGUMENTS
%
%	OUT: 	Index
%
%	Author:
%		Luis A. Dominguez, April 2007.
%	
if nargin==0
    Component='z';
elseif nargin>=2
    error('Too many input paramenters');    
end

[files NumFiles]=ValidateComponent(Component);

hold on
ix=1;

% This cicle create a index to sort the stations by latitude
	for ii=1:NumFiles
            fullname=fullfile(pwd,files(ii).name);
    		sac=rsac(fullname); %[t y p]-> [time amplitude parameters}
            slatD(ix)=sac.stla; %P(17)-> Latitud
		    ix=ix+1;
	end
[dummy Index]=sort(slatD); % Sorts the stations by latiude

end
