function post=get_station_position(name)
% post=get_station_position(name)
%
% Returns the complete list of the MASE network station's names from the 
% /home/uclanet/MASE/SKS/B254_snoplot/new/station_list_all.txt'. (RISKY)
fidList=fopen(...
    '/home/uclanet/MASE/SKS/B254_snoplot/new/station_list_all.txt');
for i=1:100
	name_aux=fgetl(fidList);
	if strcmp(name_aux,name)
		post=i;
	        fclose(fidList);			
		return
	end
	

end



