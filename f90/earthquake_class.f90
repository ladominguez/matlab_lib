include 'file_io_lib.f90'
module earthquake_class
	implicit none
!	public	:: earthquake
	type earthquake
		real		:: longitud,latitud,depth
		real		:: latlon(2)
	end type earthquake
contains
	function earthquake_ (lat,lon, dep) result(e)
		integer		  	   :: lines,file_number=13
		real, optional,intent(in)  :: lat, lon, dep
		type (earthquake) 	   :: e
		real	          	   :: x(3)
	
		if(present(lon) .and. present(lat) .and. present(dep)) then 
			e%longitud=lon
			e%latitud=lat
			e%depth=dep
			e%latlon=(/lat,lon/)
		else
			open(unit=file_number,file='EarthquakeParams.dat')
			call readData(file_number, 3, x)
			e%longitud=x(1)
			e%latitud=x(2)
			e%depth=x(3)
			e%latlon=x(1:2)
			close(file_number)
		end if
	end function earthquake_

	subroutine print(quake)
		type (earthquake), intent(in)  :: quake
		print *,"Latitud:  ", quake%latitud 
		print *,"Longitud: ", quake%longitud
		print *,"Depth:    ", quake%depth, "km"
	end subroutine print

end module earthquake_class
