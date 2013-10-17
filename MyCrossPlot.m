% Func2 moves and Func1 is fixed. They must be row vectors

function Cross=MyCrossPlot(Func1,Func2,t0)
    
    

    L1=length(Func1);
    L2=length(Func2);
    Func1Prime=zeros(L1+L2-1,1);
    Func1Prime(1:L1)=Func1(1:L1);    
    figure;
    t0=t0*100; 
    for i=0:50:L1
        
        Aux=Func1Prime((i+1):(L2+i))'.*Func2;
	subplot(2,1,1)
	plot((1:L1),Func1,((i+1):(L2+i)),Func2,[t0 t0],[min(Func1) max(Func1)])
	Ind=1+i/50;
        Cross(Ind)=sum(Aux);
	t(Ind)=(Ind-1)*50;
	subplot(2,1,2)
	plot((1:L1),zeros(L1,1),t,Cross,[t0 t0],[-2e13 2e13])
	axis([0 L1 -2e13 2e13])
	pause(0.01)
	
    end
end
