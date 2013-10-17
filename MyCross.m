function Cross=MyCross(Func1,Func2)
% Cross=MyCross(Func1,Func2)
% Func2 moves and Func1 is fixed. They must be row vectors
     L1=length(Func1);
     L2=length(Func2);
     Func1Prime=zeros(L1+L2-1,1);
     Func1Prime(1:L1)=Func1(1:L1);    
     
     for i=1:L1
%         Aux=Func1Prime((i):(L2+i-1))'.*Func2;
            A=Func1Prime((i):(L2+i-1));
          Cross(i)=A'*Func2';
%         Cross(i)=sum(Aux);
     end


    
end
