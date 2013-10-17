clear_everything;
figure
a=zeros(501,501);
a(120:400,206:306)=1;
%a=phantom(501);
x=-250:250;
y=-250:250;

subplot(2,2,1)
subimage(x,y,a)
title('Input Image')

axis image
set(gcf,'Color','w')

theta=0:0.5:179.5;
[R,xp]=radon(a,theta);
Rn=normalize(R');
subplot(2,2,2)
subimage(xp,theta,Rn)
axis xy square
colormap('gray')
title('Radon Transform')
xlabel('\rho')
ylabel('\theta')

a_r=iradon(R,theta,'linear','none');
subplot(2,2,3) 
imagesc(x,y,a_r)
colormap(gray)
axis square
title('Unfiltered Signal')

a_filt=iradon(R,theta);
subplot(2,2,4)
imagesc(x,y,a_filt)
colormap(gray)
axis square
title('Filtered Signal')