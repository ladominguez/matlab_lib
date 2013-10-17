program new_ttimes
     use ttimes_lib

     implicit none
     integer,parameter  :: max=100
     integer		:: i,n,counter
     real		:: depth
     real, allocatable	:: deltas(:)
     real		:: tt(max),tt_all(max,max)
     character (len=8)  :: phases(max)	
     real 		:: params(3)
     integer		:: file_number_params=11,file_number_deltas=12
     integer		:: OpenStatus

     open(unit=file_number_params,file='EarthquakeParams.dat',iostat=OpenStatus)
     open(unit=file_number_deltas,file='deltas.dat')
     counter=inputCount(file_number_params)
     call readData(file_number_params,counter,params)
     depth=params(3)
     counter=inputCount(file_number_deltas)
     allocate(deltas(counter))
     call readData(file_number_deltas,counter,deltas)	     
     do i=1,counter,1
	     call traveltimes(depth,deltas(i),tt,phases,n)
	     tt_all(:,i)=tt
     end do

     do i=1,n,1
	print '(A,100F10.2)', phases(i), tt_all(i,1:counter)
     end do

     deallocate(deltas)
     close(file_number_params)
     close(file_number_deltas)

end program new_ttimes
