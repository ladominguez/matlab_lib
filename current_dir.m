function dir=current_dir()

c_path=pwd;
while 1
    [dir remain]=strtok(c_path,'/');
    if isempty(remain)
        break
    else
       c_path=remain;
       [dir remain]=strtok(c_path,'/'); 
    end
end