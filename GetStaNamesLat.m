function List=GetStaNamesLat()


    if strcmp(getenv('OS'),'Windows_NT')
        fid=fopen('C:\MATLAB7\work\MASE_files\stations_name_lat.txt'); % Stations must be ordered by latitude
    else
        fid=fopen('/home/antonio/mat_work/MASE_files/stations_name_lat.txt');
    end
    List=char(32.*ones(100,4));
    
    for i=1:100
        List(i,:)=fgetl(fid);

    end

    fclose(fid)
    return % I changed this so only works for 'all'