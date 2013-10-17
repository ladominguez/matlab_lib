clear_everything;
sac_f=rsac('bbfk.sac');
NS=100;
NC=20;
k0=0.015;
offset=k0/20;
k_interval=0.0025:0.0025:0.015;
k=linspace(-k0,k0,NS);
[X_or,Y_or]=meshgrid(k,k);
data=reshape(sac_f.d,NS,NS)';
data=normalize(data);
contourf(k,k,data,NC)
c=colormap(gray); % Reverses colormap
c=flipud(c);
colormap(c)
%colorbar
setw
%figure
r=linspace(0,k0,NS);
th=linspace(0,2*pi,NS);
[th_grid r_grid]=meshgrid(th,r);
[Xg Yg]=pol2cart(th_grid,r_grid);
ZI=interp2(X_or,Y_or,data,Xg,Yg);
h=polargeo([0 2*pi],[0 k0]);
delete(h);
hold on
contourf(Xg,Yg,ZI,NC)
axis equal
%colormap 
fontsize(14)
setw
for m=1:length(k_interval);
    tmp=linspace(0,2*pi,365);
    hl=polargeo(tmp,k_interval(m)*ones(1,length(tmp)));
    set(hl,'Color','k')
    set(hl,'LineWidth',2)
    R=k_interval(m)+offset;
    text(R*cosd(81),R*sind(81),num2str(k_interval(m)),...
        'FontSize',12,'Color','k','FontWeight','bold','BackgroundColor','w')
end
SetTitle('Z',sac)