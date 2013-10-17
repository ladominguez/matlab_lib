function A=plotmarkers_horiz(Component,i)

if nargin==0
    Component='Z';
end

[files subdir]=ValidateComponent(Component);

NumFiles=length(files);
hold on

% if nargin<=1
%    full_name=fullfile(subdir,files(1).name);
%    s=rsac(full_name); 
%    j=0;
%    while s.picks(j+1)~=-12345
%        j=j+1;
%        if j==10
%            break
%        end
%    end
%    if j==0, error('No picks on header file - DRLA'); end
%    i=0:j-1;
% end

for ii=1:NumFiles 
    full_name=fullfile(subdir,files(ii).name);
    s=rsac(full_name);
    d(ii)=s.gcarc;
%   if (s.picks(1+i(1)))==-12345
    for i=1:10
        if s.picks(i)==-12345
            disp(['No markers for ' s.kstnm ' t' num2str(i-1)])
            tt(ii,i)=NaN;
        else
            tt(ii,i)=s.picks(i);                           
        end
    end
    
end

A=sortrows([d' tt]);
Color=['y' 'm' 'c' 'r' 'g' 'b']';
for ii=2:size(A,2)
     h(ii)=plot(A(:,ii),A(:,1),'LineWidth',2.5,'Color',Color(1));
     Color=circshift(Color,1);
end


[p n k]=readheader(full_name);
%for ii=1:10
    legend(k(:,:),'Location','SouthWest')
%end

