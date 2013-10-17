clear all
close all

N=15;
B0_in = linspace(0,1,N);
Le_in = linspace(0.01, 0.1, N);

[B0_a Le_a ] = meshgrid(B0_in, Le_in);

[B0 Le_i VB0 VLe] = correction_hctm(B0_a, Le_a );

ratio_B0 = B0./B0_a;
ratio_Le = Le_i./Le_a;

quiver( Le_a, B0_a, VLe, VB0)
return
subplot(1, 2, 1)
imagesc(B0_in, Le_in, ratio_B0)
title('B_{0 correct}')
colorbar
axis square

subplot(1,2,2)
imagesc(B0_in, Le_in,ratio_Le)
title('Le^{-1}')
axis square
colorbar
setw
