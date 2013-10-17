function yp=derivative(y,dt)
% yp=derivative(y,dt)
% yp(end+1) is set to yp(end).
% By ladominguez@ucla.edu

yp=diff(y)./dt;
yp(end+1)=yp(end);
end
