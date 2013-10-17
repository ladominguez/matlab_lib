
% This function goes into every subdirectory, looks for the file *.evnt and
% set the parameter into the sac header. 
clc
dirs=dir_only_sac();

catalog = 'SSN'; % 'usgs' or 'shearer', 'SSN'
inicio=37;

for ii=inicio:length(dirs)
    if dirs(ii).isdir && ~strcmp(dirs(ii).name,'.') && ~strcmp(dirs(ii).name,'..')
        
        evnt=dir([dirs(ii).name '/event.info']);
        disp(dirs(ii).name)
        if ~isempty(evnt)
            fullname=fullfile(pwd,dirs(ii).name,evnt.name );
            fid  = fopen(fullname);
            line = fgetl(fid);
            if strcmp(catalog,'usgs')
                latitude  = str2double(line(23:28));
                longitude = str2double(line(30:38));
                depth     = str2double(line(39:42))*1000;
                magnitude = str2double(line(43:45));
            elseif strcmp(catalog,'stp')
                latitude  = str2double(line(35:42));
                longitude = str2double(line(45:54));
                depth     = str2double(line(56:61))*1000;
                magnitude = str2double(line(62:67));
            elseif strcmp(catalog,'shearer')               
                latitude  = str2double(line(35:44));        
                longitude = str2double(line(45:56));        
                depth     = str2double(line(57:61))*1000;                  
                magnitude = str2double(line(63:67));
            elseif strcmp(catalog,'SSN')
                latitude  = str2double(line(54:62));
                longitude = str2double(line(64:72));
                depth     = str2double(line(73:75))*1e3;
                magnitude = str2double(line(76:79));
            else                
                error('Invalid Catalog.')
            end            
                      
            fclose(fid);
%            disp([num2str(ii) ' ' dirs(ii).name line])
            disp([num2str([latitude longitude depth magnitude],'%4.3f ')])
            
%              sac_files=dir(fullfile(pwd,dirs(ii).name,'*.sac'));
%              for j=1:length(sac_files)
%                 sac=rsac(fullfile(pwd,dirs(ii).name,sac_files(j).name)); 
%                 sac.evla=latitude;
%                 sac.evlo=longitude;
%                 sac.evdp=depth;
%                 sac.mag=magnitude;
%                 sac.gcarc=distance([sac.stla sac.stlo],[sac.evla sac.evlo]);
%                 sac.dist=sac.gcarc*6371/rad2deg(1);
%                 sac.az=azimuth([sac.evla sac.evlo],[sac.stla sac.stlo]);
%                 sac.baz=azimuth([sac.stla sac.stlo],[sac.evla sac.evlo]);
%                 disp(['Writing ' sac.filename])
%                 wsac(sac,sac.filename);
%              end
            
        end
    end
end
