function show_time()
a  = clock;
yr = a(1);
mm = a(2);
dd = a(3);

hh = a(4);
mm = a(5);
ss = a(6);

fprintf(1,'Time: %d/%d/%d %d:%d\n',yr, mm, dd, hh, mm)