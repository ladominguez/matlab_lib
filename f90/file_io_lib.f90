function inputCount(unit) result(linesOfInput)
!-----------------------------------------------------------------
! takes a file number, counts the number of lines in that
! file, and returns the number of lines.
!	By Akin 2003
!-----------------------------------------------------------------
  integer, intent(in)   :: unit         ! file unit number
  integer		:: linesOfInput ! result
  integer ioResult    ! system I/O action error code
  character temp      ! place to hold the character read

   rewind (unit)              ! go to the front of the file
   linesOfInput = 0           ! initially, there are 0 lines

   do  ! Until iostat says we've hit the end_of_file, count lines.
     read (unit,'(A)', iostat = ioResult) temp    ! one char

     if ( ioResult == 0 ) then          ! there were no errors
        linesOfInput = linesOfInput + 1 ! increment number of lines
     else if ( ioResult < 0 ) then      ! we've hit end-of-file
        exit                            ! so exit this loop.
     else   ! ioResult is positive, which is a user error
       write (*,*) 'inputCount: no data at unit =', unit
       stop 'user read error'
    end if
  end do
  rewind(unit)               ! go to the front of the file
end function inputCount

subroutine readData (inFile, lines, x)
! ------------------------------------------------------
!   Take a file number, the number of lines to be read,
!      and put the data into the arrays x and y
!	By Akin 2003
! ------------------------------------------------------
! inFile     is unit number to be read
! lines      is number of lines in the file
! x          is independent data
! y          is dependent data  
	integer, intent(in)  :: inFile,   lines  
	real,    intent(out) :: x(lines)  
	integer              :: j  
	rewind (inFile)			! go to front of the file  
	do j = 1, lines			! for the entire file    
	   read (inFile, *) x(j)	! get the x and y values                                 
	end do 				! over all lines
end subroutine readData

