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
      implicit none
      
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
	implicit none  
	integer, intent(in)  :: inFile,   lines  
	real,    intent(out) :: x(lines)  
	integer              :: j  
	rewind (inFile)			! go to front of the file  
	do j = 1, lines			! for the entire file    
	   read (inFile, *) x(j)	! get the x and y values                                 
	end do 				! over all lines
end subroutine readData
 
