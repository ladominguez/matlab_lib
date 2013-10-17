function sac=correct_amplitude(sac,Band)

load /home/antonio/lib/Correction_factors.mat

switch Band
	case 'raw'
		load correction_raw_stations.dat 
		corr=correction_raw_stations;
	case '0-1' % First Column
		corr=Corrections(:,1);
	case '1-3' 
		corr=Corrections(:,2);
	case '3-5'
		corr=Corrections(:,3);
	case '5-7'
		corr=Corrections(:,4);
	case '7-10'
		corr=Corrections(:,5);
	case '10-13'
		corr=Corrections(:,6);
	case '13-17'
		corr=Corrections(:,7);
	case '17-21' % Last Column
		corr=Corrections(:,8);		
end

ID=station_id(sac.kstnm(1:4));
Amp=corr(ID);

sac.d=sac.d./Amp;


