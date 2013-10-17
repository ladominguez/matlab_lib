function elev_plot(Component)

if nargin==0
    Component='Z';
end

[files subdir]=ValidateComponent(Component);
Numfiles=length(files);

for i=1:Numfiles
   full_name=fullfile(subdir,files(i).name);
   s=rsac(full_name);   
   M(i,:)=[s.gcarc s.stel];   
  
end

Yl=get(gca,'Ylim');

Ya=abs(Yl(2)-Yl(1));

M=sortrows(M);
M(:,2)=-0.1*Ya*M(:,2)./max(M(:,2))+Yl(2);
hold on
%plot(M(:,1),M(:,2),'k','LineWidth',2)
patch(M(:,1),M(:,2),[0.5 0.5 0.5])