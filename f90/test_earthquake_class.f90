include 'earthquake_class.f90'
program test
	use earthquake_class
	implicit none
	type (earthquake):: e1,e2
	e1=earthquake_()
	call print(e1)
	e2=earthquake_(2.0,3.0,4.0)
	call print(e2)
        print *,e1%latitud	
end program test
