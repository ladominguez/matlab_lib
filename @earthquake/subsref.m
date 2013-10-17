function FieldVal=subsref(e,S)

switch S.type
case '.'
	switch S.subs
	case 'latitud'
		FieldVal=e.latitud;
	case 'longitud'
		FieldVal=e.longitud;
	case 'depth'
		FieldVal=e.depth;
	case 'latlon'
		FieldVal=[e.latitud e.longitud];
    case 'day'
        FieldVal=[e.year '/' e.month '/' e.day];
    case 'time'
        FieldVal=[e.hour ':' e.minute ':' e.second];            
    case 'magnitude'
        FieldVal=e.mag;
	case 'shift'
		FieldVal=e.shift;
	case 'layer'
		FieldVal=Layer(e);
	otherwise
		error('Wrong field.');
	end
case '()'
	disp('I have done this yet.');
case'{}'
	disp('I have done this yet.');
otherwise
	disp('Error-');
end
	
	
