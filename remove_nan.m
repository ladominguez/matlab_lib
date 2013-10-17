function [x ind]=remove_nan(x)
ind_a = isfinite(x);
x     = x(ind_a);
ind   = find(ind_a==1);
