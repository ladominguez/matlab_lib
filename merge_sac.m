% This code merges sac files from the RAS array.
% 
% The progrma reads 10 minutes files from a given day must be located in the same folder. The program
% fills with zeros gaps between adjacent files.
%
% Luis Dominguez ladominguez@geofisica.unam.mx  ® 2013

clear all
close all
clc

Component = 'Z';
fs        = 50;
fs_out    = 50;
dt        = 1/fs;
dt_out    = 1/fs_out;
T_all     = 24*3600;          % Total time in seconds
segment   = 3600;             %
output    = zeros(1,T_all*fs+1);
overlap   = zeros(1,T_all*fs+1);
[files N] = ValidateComponent(Component);
time      = 0:dt:T_all;
writeout  = 1;    % 1 writes out put to file.

if N == 0
    disp(current_dir)
    return
end

for k = 1:N
    sac    = rsac(files(k).name);
    tbegin = sac.nz(3)*3600 + sac.nz(4)*60 + sac.nz(5) + sac.nz(6)/1000;
    ibegin = floor(tbegin/dt)+1;
    output(ibegin:ibegin+sac.npts -1)  = output(ibegin:ibegin+sac.npts -1)  + sac.d';
    overlap(ibegin:ibegin+sac.npts -1) = overlap(ibegin:ibegin+sac.npts -1) + 1;
    if k == 1   % Keep first record for header
        sac0 = sac;
    end
end

subplot(2,1,2)
stairs(time./(3600),overlap-1,'k')
ylim([-1.5 1.5])
xlim([time(1) time(end)]./3600)
middle_point = 0.8*sum(get(gca,'xlim'))/2;
text(middle_point,  1.2, 'Overlaps', 'FontSize', 12);
text(middle_point, -1.2, 'Gaps',     'FontSize', 12);
fontsize(12)
xlabel('Time [h]','FontSize',14)
set(gca,'yticklabel',[])

NoOverlaps  = numel(find(overlap >= 2));
Gaps        = numel(find(overlap == 0));
FilledData  = numel(find(overlap == 1));


suptitle(current_dir)
counter = 1;
for k = 1:numel(overlap) - 1
    if overlap(k) == 0 && overlap(k+1) == 0
        counter = counter + 1;
    elseif overlap(k) == 0 && overlap(k+1) == 1
        gap_sample_counter(k) = counter/fs; %#ok<AGROW>
    else
        counter = 1;
    end
end

overlap(overlap == 0) = 1;  % Avoids dividing by zero caused by gaps in the data
output                = output./overlap;

%  Downsampling
time_d   = 0:dt_out:T_all;
output_d = interp1(time,output,time_d,'nearest');

subplot(2,1,1)
plot(time_d./3600,output_d,'k')
xlim([time_d(1) time_d(end)]./3600)
ylabel('accel [nm/s].','FontSize',14)
setwin([205 438 1530 496])
setw

disp(['Filled data : ' num2str(FilledData*100/(T_all*fs+1)) '%'])
disp(['Gaps        : ' num2str(Gaps*100/(T_all*fs+1)) '%'])
disp(['Overlap     : ' num2str(NoOverlaps*100/(T_all*fs+1)) '%'])
disp(['Max gap     : ' num2str(max(gap_sample_counter)) 's.'])
disp('')

k=0;
if writeout == 1
    
    t_aux      = linspace(0,segment,segment/dt_out+1);
    while (k+1)*segment <= time_d(end)
        sac_out    = sac0;
        index      = find(time_d >= k*segment & time_d <= (k+1)*segment);
        [month day]= jul2greg(sac_out.nz(2),sac_out.nz(1));
        year       = sac_out.nz(1);
        hour       = floor(k*segment/3600);
        minute     = floor(mod(k*segment,3600));
        k          = k + 1;
        sac_out.t  = time_d(index);
        sac_out.d  = output_d(index);
        sac_out.dt = dt_out;
        sac_out.nz(3) = hour;
        sac_out.nz(4) = minute;
        sac_out.e  = time_d(index(end));
        sac_out.npts   = numel(index);
        sac_out.depmin = min(sac_out.d);
        sac_out.depmax = max(sac_out.d);
        gaps           = numel(sac_out.d(sac_out.d == 0))*100/sac_out.npts;
        filename = [current_dir() '.' num2str(year) num2str(month,'%.2d') num2str(day,'%.2d') ...
                     num2str(sac_out.nz(3),'%.2d') num2str(sac_out.nz(4),'%.2d') '.' Component '.sac']; %#ok<AGROW>
        disp(['Writting sac ' filename ' ' num2str(year) '/'  num2str(month,'%.2d') '/' num2str(day,'%.2d') ' ' ...
               num2str(sac_out.nz(3),'%.2d') ':' num2str(sac_out.nz(4),'%.2d') ' Gap = ' num2str(gaps,'%.2f') '%'])
        
        wsac(sac_out,filename);
    
    end
end
