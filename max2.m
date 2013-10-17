function [a b]=max2(T)

[dummy1 max1]=max(T);      % Returns the maximum in every column
[dummy2 b]   =max(dummy1); % b is the column of the absolute maximum
[dumme2 a]   =max(T(:,b)); % a is the row

