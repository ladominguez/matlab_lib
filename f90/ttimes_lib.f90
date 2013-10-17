module ttimes_lib

implicit none

contains
subroutine traveltimes(depth,delta,tt,phcd,n)
! ----------------------------------------------------
! traveltimes(depth,delta,tt,phcd,n)
! Computes the travel times of all the phases using
! iaspei libraries by R. Buland (1980).
! IN.  (depth) and (delta).
! OUT. (phcd) a string array with the names of the phases.
!      (tt)   Travel times vector.
!      (n)    number of phases.
!			By Luis Dominguez 2007
! ----------------------------------------------------
      
      integer,parameter :: max=100
      real,intent(in) 			:: depth,delta
      real,intent(out)  		:: tt(max)
      character (len=8),intent(out) 	:: phcd(max)
      integer,intent(out)		:: n	
      integer		:: i,in, mn(max)
      logical		:: prnt(3)
      character (len=8) :: phlst(10)
      character (len=20):: modnam
      real		:: dtdd(max),dtdh(max),dddp(max),ts(max),usrc(2)

      data in/1/,modnam/'iasp91'/,phlst(1)/'all'/
      data prnt/.false., .false., .false./ 
      ! if prnt(3) is .true., it prints the phase summary

      call tabin(in,modnam)	! set the model
      call brnset(1,phlst,prnt)	! set the phases ('all')
      call depset(depth,usrc)	! set depth
      call trtm(delta,max,n,tt,dtdd,dtdh,dddp,phcd)

end subroutine traveltimes

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

end module ttimes_lib
