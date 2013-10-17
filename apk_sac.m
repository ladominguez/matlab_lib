close all
clear all
clc

%% Initial Variables
addpath('/home/antonio/CJA_Msac1.1/process/');
LTA_w     = 7.0; % Width in seconds
STA_w     = 0.5; % Width in seconds
Sampling  = 20;
Threshold = 0.3;
Plotting  = 'off';
Saving    = 'on';


[files N] = ValidateComponent('Z');
%N=1;
for k = 1:N
    a         = rsac(files(k).name);
    raw       = a;
     a         = filter_sac(a,0.2,1.0,2);
    %a         = filter_sac(a,0.01,0.5,2);
    % a         = filter_sac(a,0.1,3.0,2);

    %% Envelope
    Env = senvelope(a);

    %% Downsampling
    Env.t  = Env.t(1:Sampling:end);
    Env.d  = Env.d(1:Sampling:end);
    Env.dt = Env.t(2)-Env.t(1);

    %%
    Y     = Env.d;
    Ynpts = numel(Y);
%     err   = mod(Ynpts,2);
% 
%     if err == 0
%         error('Ynpts must be an even number.')
%     end

    LTA_n = floor(LTA_w/Env.dt);
    LTA_n = LTA_n-mod(LTA_n,2) + 1.0;   % Force an even number

    LTA_mat = triu(ones(Ynpts)) - triu(ones(Ynpts),+LTA_n);

    STA_n = floor(STA_w/Env.dt);
    STA_n = STA_n-mod(STA_n,2) + 1.0;   % Force an even number

    STA_mat = tril(ones(Ynpts)) - tril(ones(Ynpts),-STA_n);

    STA_mean = mean(diag(Y)*STA_mat);
    LTA_mean = mean(diag(Y)*LTA_mat);

    ratio    = smooth(taper( STA_mean./LTA_mean)) - Threshold;
    
    ratio_ind = zero_crossings_up(ratio);
    
    time     = Env.t;
     s_arrival = 0.0;
%    p_arrival = time(find(ratio>=Threshold,1,'first'));  
    if isempty(ratio_ind)
        p_arrival = 0.0;
        disp('Impossible to detect.')
    else
        p_arrival = time(ratio_ind(1));
        if raw.a == -12345
            raw.a = p_arrival;
        end
        if numel(ratio_ind) >= 2
            s_arrival    = time(ratio_ind(2));
            if raw.picks(1) == -12345
                raw.picks(1) = s_arrival;
            end
        else
            s_arrival = 0.0;
        end
    end

    if strcmp(Saving,'on')
        wsac(raw,raw.filename);
    end

    if strcmp(Plotting,'on')
        subplot(4,1,1)
        plot(raw.t,raw.d,'k')
        draw_vert(p_arrival);
        draw_vert(s_arrival,'b');
        % hold on
        % plot(Env.t,Env.d,'r')

        subplot(4,1,2)
        plot(a.t,a.d,'k')
        draw_vert(p_arrival)


        subplot(4,1,3)
        plot(time,Y)
        title('Envelope')

        subplot(4,1,4)
        plot(time,ratio )


        if p_arrival~= 0
            draw_horz(0.0)
            draw_vert(p_arrival)
            title(['Threshold - ' num2str(Threshold)])
        end
        
        if s_arrival ~= 0.0
            draw_vert(s_arrival)
        end
        set(gcf,'OuterPosition',[674    65   718   984])
        setw
        pause
        clf
    end
end

close all
%% Plot


%xlim([20 180])
