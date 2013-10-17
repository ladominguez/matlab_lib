c
c    DISLIN routines to simulate X calls used in linux
c
c    jens havskov december 2010
c
c    changes
c
c dec 31 2010 jh: add xopen_window, set size with wsize when opening
c jan 21 2011 jh: fix scaling
c feb 10 2011 jh: yellow was missing
c feb 22 2011 jh: more scaling, position plot
c apr 21 2011 jh: add polar plot 

      subroutine xopen(wsize,color_type,cursortype,fontname)
c
c     wsize: window size in %
c
c   open screen and set fonts etc
c
      implicit none
      integer wsize
      integer ixpos,iypos         ! initial window position in screen coord.
      integer color_type          ! color or bw screen, not implemented
      integer cursortype          ! cursor type, cros or crosheir, not implemented
      character*(*) fontname      ! name of font, only used  in x

c
c  
c
c   set window size and position
c 
      ixpos=30
      iypos=30
c
      call xwindow_size(wsize,ixpos,iypos)    
c
      CALL METAFL ('XWIN') ! output on screen 



c      call sclmod("FULL")  ! scale to hardware size

      CALL DISINI        ! initialize plot

      CALL PAGERA        ! border around page

c
c  change of font might require change of posiiton or font, see xtext
c
c      call simplx        ! simple fonts
c      call bmpfnt('SIMPLEX')
c     call winfnt('Arial') ! set font
      call winfnt('Courier New') ! set font
      CALL FIXSPC (0.70)  ! equaliy spaced font size 0.75 of max
      CALL HEIGHT (24)   ! height in plot coordintes
      call wintit('Seisan 9.0') ! title on frame

      call pagfll(255)   ! white background
c
c  turn errror and dislin output off
c
      call errmod("WARNINGS","OFF")  
      call errmod("PROTOCOL","OFF")
c
c   get the size of the current window, can be used  
c   to scale window if user changes window 
c
c      CALL GETWIN (NNX, NNY, NW, NH)

c       write(6,*) 'nnx,nny,w,h', nnx,nny,nw,nh

      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine xopen_window(id)
c
c  opens a new window with window id id
c
      implicit none
      integer id

      call opnwin(id)  
      call winfnt('Courier New') ! set font
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc     

      subroutine xclose_window(id)
c
c close window with id id
c
      implicit none
      integer id
      call clswin(id)
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
      subroutine xwindow_title(text)
c
c   put frame text in window
c
      implicit none
      character*80 text

      call wintit(text)
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


      subroutine xwindow_size(size,ixpos,iypos)
c
c  set the window size as size % of full screen
c  ixpos,iypos is the initial position of the window
c              in screen coorrdinates
c
      implicit none
      integer size
      integer nx,ny             ! screen size in pixels
      integer ixpos,iypos
      real xratio,yratio        ! scaling factors
c
c     size should be 1-100
c
c      write(6,*) 'sub wsize',size
      if(size.gt.100.or.size.le.1) size=100
c
c   get size of window in pixels
c
       call xget_screen_size_pc(nx,ny)         ! dummy on linux
       call xget_screen_size_unix(nx,ny)       ! dummy on pc
c      write(6,*) 'nx,ny',nx,ny    
c
c   find scaling considering that a dislin page is 2969 in x and 2099 in y
c   and new window must have ratio 2099 to 2969 in pixels
c
      xratio=2969.0/float(nx)
      yratio=2099.0/float(ny)

c
c   pixels to get 100 %
c
      if(xratio.gt.yratio) then
          ny=nx*(2099.0/2969.0)       ! narrow screen
      else
          nx=ny*(2969.0/2099.0)       ! wide screen
      endif
c
c   reduce pixels to desired size   
c
      nx=nx*size/100.0
      ny=ny*size/100.0
c
c   set window size and position
c
c     call winsiz(nx,ny)
      CALL WINDOW (ixpos,iypos, nx, ny)
      

      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
      subroutine xtext(text,it,ix,iy)
c
c  plot a text string text at ix,iy, string length is it
c
      implicit none
      integer it 
      character*90 text,text_org
      integer nt,ix,iy,i
      real x,y
      text_org=text  ! save text, deleted on return
      iy=iy+13       ! move text up, font dependent
      x=ix*2.902
      y=(780.0-iy)*2.691
      ix=x
      iy=y

      call messag(text(1:it),ix,iy)
c
c  put text back
c
      text=text_org
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine xtextwin(text,it,ix,iy)
c
c  plot a text string text at ix,iy, string length is it
c  same for now as xtext, used in X to draw without waiting
c
      implicit none
      integer it 
      character*90 text,text_org
      integer nt,ix,iy,i

      call xtext(text,it,ix,iy)

      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine xlineto(xold,yold,x,y)
c
c   draw line to x,y
c
      implicit none
      real xold,yold   ! dummy used in X
      real x,y         ! draw line to
      real x1,y1
      x1=x*2.902
      y1=(780.0-y)*2.691
      call xdraw(x1,y1)
      return
      end

      subroutine xmoveto(x,y)
c
c  move to x,y
c
      implicit none
      real x,y
      real x1,y1
      x1=x*2.902
      y1=(780.0-y)*2.691
      call xmove(x1,y1)
      return
      end



      subroutine xcursr(ich,x,y)
c
c  return current position x,y and key ich pressed
c
      implicit none
      integer nx,ny,ich
      integer x,y
      call csrmod("READ","POS")
      CALL CSRPOS (NX, NY, ich)
c      write(6,*) 'pos',nx,ny
      x=nx/2.902
      y=780.0-ny/2.691
      if(ich.eq.5) ich=32 ! muse click and space return the same
      return
      end


      subroutine xclose
c
c   clear screen to text
c
      implicit none
      call winmod('NOHOLD') 
      CALL DISFIN
      return
      end




	
	subroutine fillbox(x1,y1,x2,y2)
c
c  fill a box with current color
c
	implicit none
	real x,y,x1,y1,x2,y2
	integer ix1,iy1,ix2,iy2
        integer cur_col,color

        common /current_color/cur_col  ! current color

	if (cur_col .eq. 5) color=255 
	if (cur_col .eq. 3) color=200   ! red  to be fixed
	if (cur_col .eq. 2) color=100   !green   
	if (cur_col .eq. 1) color=50    ! blue
        if (cur_col .eq. 6) color=0

        x=x1*2.902
        ix1=x
        y=(780.0-y1)*2.691
        iy1=y
        x=x2*2.902
        ix2=x
        y=(780.0-y2)*2.691
        iy2=y
        call recfll(ix1,iy2,ix2-ix1,iy1-iy2,color)      
        return
        end

	subroutine drawbox(x1,y1,x2,y2)
c
c   draw a box current color
c
	implicit none
	integer x1,y1,x2,y2
        real x,y

        x=x1*2.902
        x1=x
        y=(780.0-y1)*2.691
        y1=y
        x=x2*2.902
        x2=x
        y=(780.0-y2)*2.691
        y2=y
        CALL RECTAN (x1,y2,x2-x1,y1-y2)
        return
        end

	subroutine clearwindow(x1,y1,x2,y2)
c
c  clear a rectange window to white
c
	implicit none
	integer x1,y1,x2,y2
        real x,y
        x=x1*2.902
        x1=x
        y=(780.0-y1)*2.691
        y1=y
        x=x2*2.902
        x2=x
        y=(780.0-y2)*2.691
        y2=y

        call recfll(x1,y2,x2-x1,y1-y2,255)

        return
        end

	subroutine xclear
c
c   clear screen
c
        implicit none
        call erase
        call pagfll(255)
        return
        end


  
	subroutine setcolorx(col)
c
c   set color for next operation
c
        implicit none
	integer col,cur_col
	character*6 colo

        common /current_color/cur_col
        cur_col=col
	
        
	if (col .eq. 5) colo(1:5)='WHITE ' 
	if (col .eq. 4) colo(1:5)='YELLOW'
	if (col .eq. 3) colo(1:5)='RED   '  
	if (col .eq. 2) colo(1:5)='GREEN '
	if (col .eq. 1) colo(1:5)='BLUE  '
        if (col.eq.  6) colo(1:5)='BLACK '

	call color(colo)
        return
        end

        subroutine polar_plot_dis(n,pnumber,tnumber,azimuth,nbin) 
c
c   makes a polar plot
c
c      n: number of bins
c      pnumber: number of p values in each bin
c      tnumber: ---------t------------------
c      azimuth: azimuth values for each bin
c      nbin: bin size in degrees      

c
c   all coordinates inside this routine are in dislin coordiante
c   system
c   

      IMPLICIT NONE
      integer i,n
      real step,maxt,maxp
      real pnumber(*),tnumber(*),azimuth(*)
      real xpi
      integer nbin
      real xbin

      xbin=nbin


      XPI=3.1415927
c
c  
c   convert to radians and find maximum number 
c
       maxp=0
       maxt=0
       do i=1,N
         azimuth(i)=azimuth(i)*xpi/180.0
         if(pnumber(i).gt.maxp) maxp=Pnumber(i)
         if(tnumber(i).gt.maxt) maxt=tnumber(i)
       enddo
c
c   number of digits in segment lables
c 
      CALL LABDIG(-1,'X')
c
c  lable position
c
      CALL LABTYP('VERT','Y')
c
c   modify where az starts
c
      CALL POLMOD ('TOP','CLOCKWISE')
c
c   sixe of plot
c
      call axslen(1000,1000)
c
c   size of bars
c
      CALL BARWTH(-xbin)
c
c  plot filled bars
c
      CALL POLCRV('FBARS')
c
ccccccccccccccccc plot p ccccccccccccccccccccccccccccccccc
c
c   origin of axis
c
      CALL AXSORG(2150,1250)
c
c  start counting at 0, step step, az start
c  at 0, step 30
      
      step=maxp/5.0

      CALL grafp(maxp,0.,step,0.,30.)

c
c   plot the points
c
      CALL CURVE(pnumber,azimuth,n)

c
c   title
c
      call messag('P',2140,500)

      CALL ENDGRF
c
cccccccccccccccccccccccccccccccccc plot t ccccccccccccccccccccccccccccccc
c
      CALL AXSORG(850,1250)
c
c  start counting x at 10, start countin at 0, steps 2, az start
c  at 0, step 30
      
      step=maxt/5.0

      CALL grafp(maxt,0.,step,0.,30.)
c
c  plot filled bars
c
      CALL POLCRV('FBARS')
c
c   plot the points
c
      CALL CURVE(tnumber,azimuth,n)
     
c
c   title
c
      call messag('T',840,500)        
   
      return

      end

c-----------------------------------------------------------------------
c   following are x calls, dummy for dislin
c-----------------------------------------------------------------------

 
        subroutine set_back_pc(color)  !dummy for PC
     
	return
	end

	
	subroutine finitt(k,j)  !dummy for PC
	integer k,j
	return
	end
c
        subroutine updatewindowsize()
        return
        end



	subroutine ancho(i)  !dummy for PC
	return
	end

	subroutine scursr(i,j,k) !dummy for PC
	return
	end

      subroutine circle(x,y,r)
      integer x,y,r
      return
      end

      subroutine fillcircle(x,y,r)
      integer x,y,r
      return
      end

      subroutine anstr(it,k)  !dummy for PC
      return
      end





      subroutine xgetabsposition()
      return
      end

      subroutine xmovetoalpha()
      return
      end

      subroutine xmovetographics()
      return
      end

      subroutine setbackx(color)
      integer color
      return
      end


