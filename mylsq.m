% Subroutines needed are deriviti.m errors.m
% put function in func.m  unknowns in vector a
% data in vector y , and in function output in vector f
% all vectors should be row vectors.
% set the least squares damping factor to be fact=1e-11;
% however for unstavbel problems fact=1e-4 may damp them down
% sets up derivitive matrix for lsq inversion

% close all

func
fact=1e-11;
clear am;
nnn=length(y);mmm=length(a);
for k=1:1,
deriviti;
del=y-f;
%damping
vect=[1:1:mmm];vect=vect./vect;damp=fact*diag(vect,0);
% Find changes to a to improve fit
da=inv(am'*am+damp)*am'*del';
% update a
a=a+da'; 
% Evaluate function at new a values
func,yfit=f;del=y-f;
ssq=sum(del.*del);
%pause
end

a;
%plot(taun,y,'b*',taun,yfit,'r.')
% grid
