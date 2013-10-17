function to_delete = clear_except_all(whos_var,varargin)


N    = numel(varargin);
M    = numel(whos_var);
k    = 0;
flag = 1;

to_delete.name = '';

for r = 1:M
    for s = 1:N
        if strcmp(varargin(s),whos_var(r).name)
           flag = 0; 
        end
    end
    if flag
       k                 = k+1;
       to_delete(k).name = whos_var(r).name; 
    end
    flag = 1;
end

