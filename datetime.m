function dt = datetime()
A = clock;
dt=[num2str(A(1)) num2str(A(2),'%.2d') num2str(A(3),'%.2d') num2str(A(4),'%.2d') num2str(A(5),'%.2d') ];
