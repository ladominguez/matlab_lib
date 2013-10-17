function [pol xn yn index]=remove_outliers(x,y)
% [pol xn yn]=remove_outliers(x,y)
%
% This function removes outliers from vectors x and y. A linear fit is assumed 
% points at a distance 3*std are eliminated.
%
%    pol - Linear fit m=p(1), b=p(2)
%
% Luis Dominguez - ladominguez@ucla.edu
%
plotting='off';
yaux=y;
xaux=x;
factor=1.0;
m=1;
if strcmp(plotting,'on') close all;figure; end
while 1
	if strcmp(plotting,'on') clf; end
	N=length(y);
    flag=0;
	pol=polyfit(x,y,1);
    yf=polyval(pol,x);
    if strcmp(plotting,'on')
    	subplot(1,2,1)
    	plot(x,y,'+')
    	hold on
        plot(x,yf,'r','LineWidth',2)
    end
	ym=y-yf;
    mean_y = mean(ym);
	std_y  = std (ym);        
    [outlier ind]=max(abs(ym));
    if strcmp(plotting,'on')
    	subplot(1,2,2)
        plot(x,ym,'+')	
    	draw_horz( mean_y,'k',2)
    	draw_horz( mean_y + factor*std_y, 'r' )
    	draw_horz( mean_y - factor*std_y, 'r' )
    	setw
        hold on
        plot(x(ind),ym(ind),'ro')
    end    
    
    index(m)=find(yaux == y(ind),1,'first'); m=m+1;
	x(ind)=[];    
	y(ind)=[];
    
    chi2=sum(ym.^2)/std_y^2;
    [h p stat]=chi2gof(ym);
    test=stat.chi2stat/((N-1)-2);
    if strcmp(plotting,'on')
        disp(['p = ' num2str(p)])
        disp(['X = ' num2str(stat.chi2stat)])	
        disp(['Xv = ' num2str(test)])
        disp(' ')
        pause
    end
	if ~h
        if strcmp(plotting,'on')
    		figure
        	plot(x,y,'+')
        end
        [pol S]=polyfit(x,y,1);
		zc=-pol(2)/pol(1);
        [yf delta]=polyval(pol,[zc x'],S);
        xn=x;
        yn=y;
        if strcmp(plotting,'on')
    		hold on
            plot([zc x'],yf,'r','LineWidth',2);
            %errorbar(-pol(2)/pol(1),0,delta,'o')
    		setw
        end
        break 
	end
end


