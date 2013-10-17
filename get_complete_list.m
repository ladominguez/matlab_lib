function List=get_complete_list()
% List=get_complete_list()
%
% returns the complete list of the MASE network station's names from the 
% /home/uclanet/MASE/SKS/B254_snoplot/new/station_list_all.txt (RISKY).
fidList=fopen('/home/uclanet/MASE/SKS/B254_snoplot/new/station_list_all.txt');

for i=1:100
	name(i,:)=fgetl(fidList);
end

List=name;	

end



