function slab_only()

fid=fopen('/home/antonio/mat_work/MASE_files/Station_list_before_DF.txt');

if ~isdir('flat_zone')
    evalc('mkdir flat_zone')
end

while 1
    line=fgetl(fid);
    if isnumeric(line)
        break
    end
   
    l=line(2:5);

    
     file=['*' l '*.sac'];
     fname=dir(file);

     for i=1:length(fname) 
         movefile(fname(i).name,'flat_zone')
     end

   
end
