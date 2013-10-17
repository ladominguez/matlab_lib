function v=ak135_Vp(depth)

load ak135.mat

[dep m]=unique(ak135(:,1),'first'); % intep1 has problem with repeated values
vel=ak135(m,2);
v=interp1(dep,vel,depth,'nearest');