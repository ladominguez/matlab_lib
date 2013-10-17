function image=seismoimage(A,x,time,xgrid,tgrid)
% Function image=seismoimage(A,x_grid,t_grid)
% 
[X T]=meshgrid(x,time);
[Xg Tg]=meshgrid(xgrid,tgrid);
disp('Generating seismic image  ...')
tic
image=interp2(X,T,A,Xg,Tg,'linear');
disp(['Elapsed time ' num2str(toc) 's.'])

