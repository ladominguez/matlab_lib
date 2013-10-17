function show_percentaje(m,N)

mul =floor(100*m/(5*N));
T1=100*m/N;
T2=100*(m-1)/N;

if T2<=mul*5 && T1>mul*5
    disp(['Progress ' num2str(mul*5) ' %.']);
end

if m==N
    disp(['Progress 100 %. (done) ']);
end