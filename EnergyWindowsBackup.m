function [E1 E2 E3 E_coda]=EnergyWindows(t,Envelope,s_wave,r,offset,CodaTime,SNR,GE)

if nargin < 5 % This values is needed for Peru
    offset = 0; 
end

Verbose  = 'off';
% SNR    = 5;
% if r <= 80
%     GE = 2.0;
% else
%     GE = 1.8;
% end

GS       = (2^GE)*pi*r^GE;  % Geometrical Spreading
dt       = t(2)-t(1);
min_t    = t(end)*0.025;  % Default taper
min_t    = 0;             % No tapering
width    = 15;            % 15 must be the defaul option

CodaTime = CodaTime + offset;
p_arrival = r/(sqrt(3)*3.7) + 1.0;

% Coda

if CodaTime >= 0
    Coda_ind   = find(t >= CodaTime - 2.5 & t <= CodaTime + 2.5); % - Fixed time
    E_coda     = mean(Envelope(Coda_ind));
else
    E_coda = 1;
end

Energy     = (Envelope/E_coda).^2;

if max(t) < 65
    disp('WARNING - Too short record.')
end
%E_coda     = trapz(Envelope(Coda_ind))*dt;


% Hoshiba
E1_ind=find(t >= s_wave           & t <= s_wave + width   );
E2_ind=find(t >= s_wave + 1*width & t <= s_wave + 2*width );
E3_ind=find(t >= s_wave + 2*width & t <= s_wave + 3*width );

E1=GS*trapz(Energy(E1_ind))*dt;
E2=GS*trapz(Energy(E2_ind))*dt;
E3=GS*trapz(Energy(E3_ind))*dt;

if SNR < 0 
    return
end

if min_t + 5.0 + 1.0 < p_arrival
    Noise_ind    = find(t >= min_t, round(5.0/dt), 'first');
%    disp('Beginning')
else
    Noise_ind    = find(t >= t(end)- min_t - 5.0 - 1.0, round(5/dt), 'first');
%    disp('End')
end

Noise_energy = 3*GS*trapz(Energy(Noise_ind))*dt; % I took a 5s window and multiply by 3

if min([E1 E2 E3])/Noise_energy < SNR
    E1 = NaN;
    E2 = NaN;
    E3 = NaN;
    if strcmp(Verbose,'on')
        disp('Low signal to noise ratio.')
    end
else
    E1 = E1 - Noise_energy;
    E2 = E2 - Noise_energy;
    E3 = E3 - Noise_energy;
end



%% Reserve
%Coda_ind   = find(t >= s_wave + 60 & t <= s_wave + 70);
