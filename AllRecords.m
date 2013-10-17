function [Records t tp]=AllRecords(Component)
% [Records time]=AllRecords(Component)
%
% Reads all sac files in the subdirectory DATA and returns a single
% matrix with every record sorted by distance.
% IN
%   Component. 'N', 'E' or 'z'
%
% OUT
%   Records.    MxN matrix. M is the number of station and
%                           N is the length of the time vector
%   time.       Time vector.
%       
% By Luis Dominguez 2007.
%    ladomingueez@ucla.edu
[files NumSta]=ValidateComponent(Component);

full_name=fullfile(pwd,files(1).name);
%[t y p]=readsac(full_name);
s=rsac(full_name);
%num_elem=length(t);
num_elem=s.npts;
t=s.t;
Records=zeros(NumSta,num_elem); % preallocating
Index=IndexGenDst(Component);
%Records(find(Index==1),:)=y;
Records(find(Index==1),:)=s.d;
tp(find(Index==1))=s.a;
for i=2:NumSta
	full_name=fullfile(pwd,files(i).name);
%	[t y p]=readsac(full_name);
	s=rsac(full_name);
	%if length(y)<num_elem  % See note
    if s.npts<num_elem  % See note
        %last=length(y);
        last=s.npts;
	else
		last=num_elem;
    end
    borrar(i)=find(Index==i);
	Records(find(Index==i),1:last)=s.d(1:last);
    
%    tp(find(Index==i))=p(7); % t0 sac header - P arrival
    tp(find(Index==i))=s.a; % a sac header - first arrival
end
disp(['EQ Latitude : ' num2str(s.evla) ])	 
disp(['EQ Longitude: ' num2str(s.evlo) ])	 
disp(['EQ Depth    : ' num2str(s.evdp) ])	 
disp(['Backazimuth : ' num2str(s.baz)  ])
% NOTE. There is a problem, not all the sac files have the same size.
% I assume that the first file has the correct number of elements.
% However, this may cause errors.
