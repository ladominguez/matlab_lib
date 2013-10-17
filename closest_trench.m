function [filename distance_min]=closest_trench()

[files Nf]=ValidateComponent('Z')
filename='';
distance_min=40000; % Arbitary large distance - approximately the diameter of the earth
for k=1:Nf
	sac=rsac(fullfile(pwd,files(k).name));
	distance=distance2trench(sac);
	if distance<distance_min
		distance_min=distance;
        filename=sac.filename;
	end

end
