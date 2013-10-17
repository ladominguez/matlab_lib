function [month day]=jul2greg(jul,year)

% By Luis Dominguez

if mod(year,4)  % Normal year february  has 28 days
     m=[0 31 59 90 120 151 181 212 243 273 304 334 365];
else    % Olympic year frebruary has 29 days
     m=[0 31 60 91 121 152 182 213 244 274 305 335 366];	
end

if jul>m(end)
    error('jul2greg.m - invalind julian date.')
end

month=find(m<jul,1,'last');

day=jul-m(month);
