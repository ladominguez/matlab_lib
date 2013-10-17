function plot_max_values(Component)

if nargin==0
	Component='Z';
end

[files subdir N]=ValidateComponent(Component);

for i=1:N
	fullname=fullfile(pwd,subdir,files(i).name);
   	sac_file=rsac(fullname);
        dist(i)=sac_file.gcarc;
        depmin(i)=sac_file.depmin;
        depmax(i)=sac_file.depmax;
        absmax(i)=max(abs([depmin(i) depmax(i)]));
end
%figure; 
hold on
plot(dist,depmin,'ko','MarkerFaceColor','b')
plot(dist,depmax,'k^','MarkerFaceColor','r')
plot(dist,absmax,'kd','MarkerFaceColor','g')
legend('Max Minimim','Max Maximum', 'Max Absolute Value')
title(['Component - ' Component])

