
       SUBROUTINE plot_foc(str,dp,rak,ix,iy,r)
c
c   plot fault plane solution
c
c  22 02 2011 jh: reset color to color_def after plotting
c
c      str,dp,rak: strike,dip and rake
c      ix,iy,r: center and radius
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      implicit none
      include 'seiplot.inc'
c
c    Libsei details...
c    =================
c
      include 'libsei.inc'                 ! Library definitions & data defns.
      external sei code                    ! Error condition handler.
      integer  code                        ! Condition.
      logical  b_flag                      ! Flag!!

      real IX, IY, R, x(1000),XBTP(2)
C ---
      CHARACTER  CBTP(3)*1                  ! symbols for t and p

      REAL ANBTP(6),ANGS(3),ANGS2(3),PTTP(4),DIP(100),STRIKE(100),
     1     RAKE(100),str,dp,rak
      REAL*8 xo, yo, xp, yp, fi, delta, ox, alfa, az, ax, btp(2),
     1       zo, alfa2, fi2
C ---
      REAL*4 MOMTEN(6)
      LOGICAL AN, PT, RIGHT, MT
      real xf(5000),yf(5000)              ! fault planes coordinates     
      integer if                          ! number of points in ----------
      real pi,z,x1,y1,rr,d
      integer ii,j,i,jj,k,icolor,l,kk


      DATA CBTP /'B','T','P'/

c
c    Initialise...
c    =============

c
C ---
      PI = 4.*atan(1.)
C ---
      RIGHT=.TRUE.
c
      call xset_color(color_frame)


      CALL FCIRCL(R, IX,IY)

C --- P and T axes


           dip(1)=dp
           strike(1)=str
           rake(1)=rak

           ANGS(1)=DIP(1)
           ANGS(2)=STRIKE(1)
           ANGS(3)=RAKE(1)

C ------- Calculate auxiliary planes

           mt=.false.
           CALL FMREPS(ANBTP,ANGS,PTTP,ANGS2,AN,PT,RIGHT,MT,MOMTEN,
     &        0,0)
           DIP(2)=ANGS2(1)
           STRIKE(2)=ANGS2(2)
           RAKE(2)=ANGS2(3)
c
C ------- Plot B,T 
c
              do 30 jj = 2, 3    ! from 2 since B no longer plotted
                 if ( jj .eq. 2 ) then
C --------- T axis
                    btp(1)=pttp(3)
                    btp(2)=pttp(4)
                 elseif ( jj .eq. 3 ) then
C --------- P axis
                    btp(1)=pttp(1)
                    btp(2)=pttp(2)
                 endif
C -------- plunge -----------------------------------------------------                 
                 btp(2)= btp(2)*pi/180.0
C -------  trend
                 az    = btp(1)*pi/180.0

C ------- calculate sterographic projection of a line
                 ax= r*dtan(pi/4.0- btp(2)/2.0)
                 xbtp(1) = ax*dsin(az) + ix
                 xbtp(2) = ax*dcos(az) + iy
c
c  plot p and t
c
                 if(cbtp(jj).eq.'P') call xset_color(color_foc_p)
                 if(cbtp(jj).eq.'T') call xset_color(color_foc_t)               

                 call xchars(cbtp(jj),1,xbtp(1)-2.0,xbtp(2)-4.0)

30         continue

C ---------------------------------------------------------------------



         call xset_color(color_foc_plane)
c         call xset_color(6) 
c
C ------- Plot mechanisms, that is fault lines
c
       if=1  ! points in fp's counter
       do 1000 j = 1 , 2   ! icount is twice the number of mechanisms

         delta  = dip(j)*pi/180.
         fi = strike(j)*pi/180.
         ii=1

         do 100 i = 1, 181
           alfa=(i-1)*pi/181. -pi/2.

C ------- calculate sterographic projection of plane

C ------- coordinate transformation to the x,y,z (E,N,Z) coordinates.
C ------- The xp, yp are the coordinates in the plane of the fault.
C ------- xp direction of dip and yp direction of strike.
            xp=dcos(alfa)
            yp=dsin(alfa)
            zo=xp*dsin(delta)
            xo=( yp*(dsin(fi)) + xp*(dcos(delta)*dcos(fi)) )
            yo=( yp*(dcos(fi)) - xp*(dcos(delta)*dsin(fi)) )
            fi2 = datan(zo/dsqrt(xo*xo + yo*yo))
            if ( xo .gt. 0 .and. yo .gt. 0 ) then
               alfa2 = datan(xo/yo)
            elseif ( xo .gt. 0 .and. yo .lt. 0 ) then
               alfa2 = datan(dabs(yo)/dabs(xo)) + pi/2.
            elseif ( xo .lt. 0 .and. yo .lt. 0 ) then
               alfa2 = datan(dabs(xo)/dabs(yo)) + pi
            elseif ( xo .lt. 0 .and. yo .gt. 0 ) then
               alfa2 = datan(dabs(yo)/dabs(xo)) + 3.*pi/2. 
            endif
            ox=dtan(pi/4.-fi2/2.)
            xo= real(ix) + real(r)*ox*dsin(alfa2)
            yo= real(iy) + real(r)*ox*dcos(alfa2)
            x(ii)   = xo
            xf(if)=xo
            x(ii+1) = yo
            yf(if)=yo
            if=if+1
c ------------- Plot focal mechanism
            if (i .eq. 1) then
               call xmovabs(x(ii),x(ii+1))
            else
               call xdrwabs(x(ii),x(ii+1))
            endif
            ii=ii+2
100      continue

c  make a stroke
c
          call xout(10.0,10.0)

1000  continue
         if=if-1
c
c    plot circles for c and d
c
c         call xset_color(6) 
c
c      rr=r/2.0
c      call xmovabs(ix+rr,iy)
c      k=1800	
c      kk=1
c      icolor=6 
c      z=6.28/k
c      do i=1,k
c         x1=rr*cos(i*z)+ix
c         y1=rr*sin(i*z)+iy 
c  
c   check color to use by distance to fault plane
c
   
c         do l=1,if
c           d=sqrt((x1-xf(l))**2+(y1-yf(l))**2)        
c           if(d.lt.5) write(27,*) d,kk,icolor
c           if(d.lt.2.and.kk.gt.0) then  ! last change must be at least 3 points aw
c               icolor=icolor+1
c               if(icolor.gt.6) icolor=5
c               call xset_color(icolor)
c
c               kk=0                     ! start countiung since last change
c           endif
c           if(d.gt.2.0) kk=1
c         enddo
c         x1=rr*cos(i*z)+ix
c         y1=rr*sin(i*z)+iy  
c         call xdrwabs(x1,y1)
c      enddo   
c

c


      call xset_color(color_def)
      RETURN
      END


c-----------------------------------------------------------------
      SUBROUTINE FCIRCL(R,X,Y)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  INPUT R - RADIUS
C        X - CENTER OF CIRCLE
C        Y - CENTER OF CIRCLE
C PURPOSE PLOTS A FILLED CIRCLE 
C
C R.N. Arvidsson 1990-05-04
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
c      implicit integer*2 (v,j-n)
      real  r, x, y, pi
      real ix(722), istat, idevh, ibc, istey, istex, ye(8)
      COMMON /BLCK7/ ISTAT, IDEVH, IBC, ISTEY, ISTEX, YE
      pi = 4.d0*asin(1.d0/(sqrt(2.d0)))
      ii=1
      do 100 i = 1, 361
c        ix(ii)  = x + r*dcos(i*pi/180.)
         ix(ii)  = x + r*cos(i*pi/180.)
c        ix(ii+1)= y + r*dsin(i*pi/180.)
         ix(ii+1)= y + r*sin(i*pi/180.)
c ---------- Plot circe
         if (ii .eq. 1) then
            call xmovabs(ix(ii),ix(ii+1))
         else
            call xdrwabs(ix(ii),ix(ii+1))
         endif
         ii=ii+2
100   continue
      return
      end




      subroutine draw_circle(x,y,r)
c
c  draws a circle with center x,y and radius r
c
      implicit none
      real x,y,x1,y1,r,z
      integer k,i

      call xmovabs(x+r,y)
	  k=100	 
	  z=6.28/k
      do i=1,k
         x1=r*cos(i*z)+x
         y1=r*sin(i*z)+y
         call xdrwabs(x1,y1)
      enddo
      return
      end

      subroutine draw_triangle(x,y,r)
c
c draw triangle inside circle of radius r
c lot 16.01.2002
c
      implicit none
      real x,y,r
      call xmovabs(x,y)
      call xdrwabs(x,y+r)
      call xdrwabs(x-r*sin(3.14/3.),y-r*cos(3.14/3.))
      call xdrwabs(x+r*sin(3.14/3.),y-r*cos(3.14/3.))
      call xdrwabs(x,y+r)

      return
      end





