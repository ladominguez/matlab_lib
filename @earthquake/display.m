function display(e)
disp(' ');
disp([inputname(1),' = ']);
disp(' ');
disp(['Latitud=  ' num2str(e.latitud)]);
disp(['Longitud= ' num2str(e.longitud)]);
disp(['Depth=    ' num2str(e.depth)]);
disp([e.year '/' e.month '/' e.day]);
disp([e.hour ':' e.minute ':' e.second]);
disp(['Magnitude: ' num2str(e.mag)])
disp(' ');
