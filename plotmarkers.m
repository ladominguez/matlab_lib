function tt=plotmarkers(Component,i)

if nargin==0
    Component='Z';
end

[files subdir]=ValidateComponent(Component);

NumFiles=length(files);
hold on

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
h=plot(A(:,1),A(:,2:end),'LineWidth',2.5);

[p n k]=readheader(full_name);
legend(h,k(1:j,:),'Location','SouthWest')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<=1
   full_name=fullfile(subdir,files(1).name);
   s=rsac(full_name); 
   jj=0;
   while s.picks(jj+1)~=-12345
       jj=jj+1;
   end
   if jj==0, error('No picks on header file - DRLA'); end
   i=0:jj-1;
end

for ii=1:NumFiles 
    full_name=fullfile(subdir,files(ii).name);
    s=rsac(full_name);
    
    if (s.picks(1+i(1)))==-12345
        error('No markers available on the sac header')
    else
%   plot(s.gcarc,s.picks(i+1),'r*')
    tt(ii,:)=s.picks(1+i);
    d(ii)=s.gcarc;
                   
    end
end
