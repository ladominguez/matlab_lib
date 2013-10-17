function h=plot_line(m,b)

xl=xlim();
y=m.*xl+b;

h=plot(xl,y);
