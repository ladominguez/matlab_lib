function [x0 y0 indices] = remove_outliers_markov(x, y, threshold)

if nargin < 3
    threshold = 0.5;
end

aux_right  = y(3:end);
aux_left   = y(1:end-2);
aux_center = y(2:end-1);


y_mean = (aux_right + aux_left)/2;
test   = abs(aux_center - y_mean);
ind    = find(test > threshold);

x0 = x;
y0 = y;

x0(ind + 1) = [];
y0(ind + 1) = [];
indices     = ind + 1;