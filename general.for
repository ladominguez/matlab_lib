c
c    different basic seisan subroutines, most routines moved from comp_unix 
c    when gfortran was implemented on pc
c
c    jh december 2010
c
c changes:
c
c jan 31 2011 jh : add get_agency_hyp: get agency code for current station file
c feb 9  2011  jh: rplace \ by char(92)
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine iasp91_filename(name)
c set name of iasp91 files
      implicit none
      logical pc,sun,linux
      character*(*) name
      call computer_type(sun,pc,linux)
c
      if(linux) name='IASP91_linux'
      if(pc) name='IASP91_windows'
      if(sun) name='IASP91_sun'
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine topdir(top_directory)
c
c  path-name for main directory of seisan seismic analysis system
      character*(*)      top_directory
c   change following line if needed, now only on vax, sometimes on pc:
c
c   get top dir from enviromental variable, usually defined in ../COM/.SEISAN
c
      call getenv('SEISAN_TOP',top_directory)
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine get_editor(eev_edit)
c
c   get editor name for eev
c
      implicit none
      logical pc,sun,linux
      character*(*) eev_edit
      integer sei clen

      call computer_type(sun,pc,linux)
c
c  get env variable
c
      call getenv('SEISAN_EDITOR',eev_edit)
c
c   set to default if not set
c
      if(sei clen(eev_edit).eq.0) then
         if(linux.or.sun) eev_edit='vi'
         if(pc) eev_edit='notepad'
      endif
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c get env variable SEISAN_EXTENSION
c
      subroutine get_env_seisan_extension(text)
      implicit none
      character text*(*)
      call getenv('SEISAN_EXTENSION',text)
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c get operator id
c
      subroutine get_env_op(text)
      implicit none
      character*(*) text
      call getenv('SEISAN_OPERATOR',text)
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c    get event name if any
c
      subroutine get_env_event(event)
      implicit none
      character*(*) event
      call getenv('TRANSFER_EVENT',event)
      return
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c   put event in memory
c
      subroutine put_env_event(event)
      implicit none
      character*(*) event
      character*100 text
      write(text,'(a,a)')'TRANSFER_EVENT=',event
      call putenvsun(text)   !c call
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c   put base name in memory
c
      subroutine put_env_base(base)
      implicit none
      character*(*) base
      character*100 text
      write(text,'(a,a)')'TRANSFER_BASE=',base
      call putenvsun(text)   !c call
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine put_env_seistop(path)
      implicit none
      character*(*) path
      character*100 text
      write(text,'(a,a)')'SEISAN_TOP=',path
      call putenvsun(text)   !c call
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine put_env_op(op)
      implicit none
      character*(*) op
      character*100 text
      write(text,'(a,a)')'SEISAN_OPERATOR=',op 
      call putenvsun(text)   !c call
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c    get base  name if any
c
      subroutine get_env_base(base)
      implicit none
      character*(*) base 
      call getenv('TRANSFER_BASE',base)
      return
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c    get alternative cal directory if there 
c
      subroutine get_env_cal(local_cal)
      implicit none
      character*(*) local_cal
      local_cal=' '
      call getenv('LOCAL_CAL',local_cal)
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c get SACAUX
c
      subroutine get_env_sacaux(text)
      implicit none
      character*(*) text
      text=' '
      call getenv('SACAUX',text)
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine get_def_base(def_base)
c
c   get enviromental variable def_base 
c
      character*(*) def_base 
      integer i
      call getenv('DEF_BASE',def_base)
      if (def_base(1:1).ne.' ') then
        do i=2,5
          if (def_base(i:i).eq.' ') def_base(i:i) = '_'
        enddo
      endif
      if(def_base.eq.'   '.or.ichar(def_base).eq.0) def_base='AGA__'
      return
      end
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c    get a general string from any program
c
      subroutine get_env_string(text)
      implicit none
      character*(*) text
      text=' '
      call getenv('ANY_STRING',text)
      return
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c   put a general string  to enviromental variable
c
      subroutine put_env_string(text)
      implicit none
      character*(*) text
      character*100 text1
c      integer seiclen
      text1=' '
      write(text1,'(a,a)')'ANY_STRING=',text
      call putenvsun(text1)   !c call
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine get_agency(agency)
c
c   get agency 
c
      character*(*) agency 
      call getenv('AGENCY',agency)
      return
      end
c
c   get Environment Architecture...
c
      integer function get_arch( chr_arch )
      character    chr_arch *(20)          ! Operating system
      call getenv('SEISARCH',chr_arch)
      chr_arch = chr_arch(:index(chr_arch,' ')-1) //
     &           char(0)                   ! Add a null.
      get_arch = 0                         ! Return a success.
      return
      end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c  send plot to laser
c
      subroutine send_plot(t,ilength)
      character*(*) t
      character*240 text
      integer ilength
      text=t
      call systemc('lpr '//text(1:ilength),ilength+4)
c     call systemc('lp -c '//text(1:ilength),ilength+6)
c     call system('lp -c '//text(1:ilength))
c
c due to problem on Solaris, wait for 5 secs after each plot
c
      call sleep(5)
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine dir_char(dchar)
c   directory separator character
      implicit none
      logical pc,sun,linux
      character*1 dchar
      call computer_type(sun,pc,linux)
      dchar='/'
c     if(pc)dchar='\'
      if(pc)dchar=char(92)
      return
      end
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c   input of arguments using sun calls
c
      subroutine get_arguments(nars,argument)
      implicit none
      integer nars,i,iargc
c      character*80 argument(*)
      character*(*) argument(*)
c
c   get number of arguments
c
      nars=iargc()
c
c   get actual arguments
c
      if(nars.gt.0) then
         do i=1, nars
           argument(i)=' '    ! jh oct 08
           call getarg(i,argument(i))
         enddo
      endif
c
      return
      end
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c  clear underflow on sun to gewt rid of message at end of execution
c
      subroutine clear_underflow
c      j=ieee_flags('clear','exception','all')
c     write(6,*)'clear'
      return
      end
c
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      
      real function sei rand( function )
CSTART**************************************************************************
C                                                                              *
C   Supplier          : BGS/GSRG Applications Programming Unit                 *
C   System            : SEISAN                                                 *
C   Procedure Name    : SEI RAND                                               *
C   Purpose           : To set up a random sequence (seed 1) or return a       *
C                       a random number depending on function                  *
C   Arguments  -input : function (I) function to perform. Values are:          *       
C                                    OPEN$ - seed the generator                *
C                                    READ$ - read a random value               *
C   Note              : For use on SUN                                         *
C                       Function value returns random number (-1.0 -> +1.0)    *
C   Author            : J. A. Bolton                                           *
C   Date              : 4 July 1995                                            *
C   Version           : V01                                                    *
C                                                                              *
CEND****************************************************************************
c
      external     drand                   ! Random # generator (0.0->1.0)
     &            ,sei code                ! Error handler.
      real*8       drand                   ! & function.
c
c    System definitions...
c    =====================
c
      include 'libsei.inc'                 ! Library definitions.               
c
c    Arguments...
c    ============
c
      integer      function                ! Function toperform.
c
c    Local variable...
c    =================
c
      real*8       value                   ! & value.
      logical      b_flag                  ! Dummy operations flag.
c
c    Initialise...
c    =============
c
      if( function .eq. open$ ) then       ! Set up.
c      value = drand(1)                     ! Start the randomiser.
      value = 0.0d0                        ! Re-set returned value.
c            
c    Read a random number...
c    =======================
c
      else if( function .eq. read$ ) then  ! Get a random number.
      value = -1.0d0 + 2.0d0 ! *drand(0)      ! & value.
c
c    Invalid function...
c    ===================
c
      else                                ! Invalid.
      call sei code( stop$, e_init$, 0, b_flag ) ! Abort, bad initialisation.
      end if                              !
c
c     Return to Caller...
c     ===================
c
9999  sei rand = value                    ! Install the number.
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine get_env_psscale(xscale,yscale)
c
c   get scaling parameters 
c
      implicit none
c      character*80 text
      character*5 scale 
      real xscale,yscale
      integer sei clen
c
c  get SEISAN_PSSCALE_X variable
c
      call getenv('SEISAN_PSSCALE_X',scale)
c
c   set to default if not set
c
      if (sei clen(scale).eq.0) then
         xscale=0.55
      else
        read(scale,'(f5.2)') xscale
      endif

c
c  get SEISAN_PSSCALE_Y variable
c
      call getenv('SEISAN_PSSCALE_Y',scale)
c
c   set to default if not set
c
      if (sei clen(scale).eq.0) then
        yscale=1.0
      else
        read(scale,'(f5.2)') yscale
      endif

      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine uncompress_file(file)
c
c check if file is compressed and uncompress
c

      implicit none

      character*(*) file      ! file name
      character*220 text     ! system call
      character*60 top_dir   ! Seisan top directory
      character*1 dchar      ! Directory deliminator
      character*20 compression_format
      integer seiclen
      integer i,j            ! counters

      call topdir(top_dir)
      call dir_char(dchar)

      compression_format = ' '

c
c check which compression format used  
c
      if (file(seiclen(file)-1:seiclen(file)).eq.'gz') then
        compression_format = 'gzip'
      elseif (file(seiclen(file)-2:seiclen(file)).eq.'zip') then
        compression_format = 'zip'
      elseif (file(seiclen(file)-1:seiclen(file)).eq.'.Z') then
        compression_format = 'compress'
      elseif (file(seiclen(file)-2:seiclen(file)).eq.'bz2') then
        compression_format = 'bzip2'
      endif

      if (compression_format.eq.' ') then
        return
      endif

c
c copy file to TMP directory
c
      text = ' '
      text = 'cp -f ' // file(1:seiclen(file)) // ' ' //
     *         top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar

      write(*,*) text(1:seiclen(text))
      call systemc(text,seiclen(text))

c
c set j to last '/'
c
      j=0
      do i=seiclen(file),1,-1
        if (file(i:i).eq.'/'.and.j.eq.0) j=i
      enddo
      j=j+1

c 
c uncompress if gzip
c   
      text = ' '
      if (compression_format.eq.'gzip') then
        text = 'gunzip -f ' // top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file))
        write(*,*) text(1:seiclen(text))
        call systemc(text,seiclen(text))
        file = top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file)-3)

c 
c uncompress if zip 
c   
      elseif (compression_format.eq.'zip') then
        text = 'unzip ' // top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file))
        write(*,*) text(1:seiclen(text))
        call systemc(text,seiclen(text))
        file = top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file)-4)
c 
c uncompress if compress
c   
      elseif (compression_format.eq.'compress') then
        text = 'uncompress ' // top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file))
        write(*,*) text(1:seiclen(text))
        call systemc(text,seiclen(text))
        file = top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file)-2)
c 
c uncompress if bzip2
c   
      elseif (compression_format.eq.'bzip2') then
        text = 'bzip2 -d ' // top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file))
        write(*,*) text(1:seiclen(text))
        call systemc(text,seiclen(text))
        file = top_dir(1:seiclen(top_dir)) // dchar //
     *         'TMP' // dchar //
     *         file(j:seiclen(file)-4)

      endif

      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine add_fps(strike,dip,rake,prog,q)
c
c   adds an 'event' to file fps.out with fps so it can be plotted with foc
c
      implicit none
      real strike,dip,rake
      character*7 prog		! program used for fps
      character*1 q             ! quality
      character*80 text
      
      open(77,file='fps.out',status='unknown')
c
c   read to end
c
 1    continue
      read(77,'(a)',end=2) text
      goto 1
 2    continue
c
c   write solution as an event
c
      text=' '
      text(1:22)=' 2040 0101 0101 00.0 L'
      text(80:80)='1'
      write(77,'(a)') text
      text=' '
      write(text(1:30),'(3f10.1)') strike,dip,rake
      text(71:77)=prog
      text(78:78)=q
      text(79:80)='OF'
      write(77,'(a)') text
      write(77,'(a)') ' '

      close (77)
      return
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine sort_event(data,nhead,nrecord)
c
c  sort an s-file acording to distance
c
        implicit none
        include 'seidim.inc'
        character*80 data(*),data1(max_data)
        character*5 old_dist,old_stat
        real dlt(max_data)           ! distances
        integer nhead,nrecord
        integer isort(max_data),lsort(max_data),ksort(max_data)
        integer hour,min
        real sec
        integer i,k,l,m,j


        do i=nhead+1,nrecord-1
            read(data(i)(71:75),'(f5.0)')dlt(i-nhead)
        end do

        call r4sort(nrecord-1-nhead,dlt,isort)
c
c   now sort so the distance sorted phase lines, for each group of
c   as in the original file
c
        old_dist=data(isort(1)+nhead)(71:75)
        old_stat=data(isort(1)+nhead)(2:6)
        k=0
        l=0
        do i=nhead+1,nrecord-1
           l=l+1
           read(data(isort(l)+nhead),'(18x,2i2,f6.2)') hour,min,sec
           if(data(isort(l)+nhead)(71:75).eq.old_dist.and.
     *     data(isort(l)+nhead)(2:6).eq.old_stat) then
              k=k+1
              lsort(k)=isort(l)
              dlt(k)=sec+min*60+hour*3600
              if(i.ne.nrecord-1) goto 73   ! at the end, always sort what is left
              l=l+1                        ! since this is last value
           endif
c
c   if here, new distance or station or last group
c
           if(k.gt.1) then
               call r4sort(k,dlt,ksort)
               m=1
               do j=l-k,l-1
                  isort(j)=lsort(ksort(m))
                  m=m+1
                                    enddo
           endif
           if(i.eq.nrecord-1) goto 73
           old_dist=data(isort(l)+nhead)(71:75)
           old_stat=data(isort(l)+nhead)(2:6)
           k=1    ! this is the first of the next group
           dlt(k)=sec+min*60+hour*3600
           lsort(k)=isort(l)
 73        continue
         enddo
c
c   save
c

        do i=nhead+1,nrecord-1
           data1(i)=data(isort(i-nhead)+nhead)
        end do

        do i=nhead+1,nrecord-1
           data(i)=data1(i)
        enddo

c
        return
        end

c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c          
      integer function JIAND(i1,i2)
      implicit none
      integer i1,i2
      jiand=iand(i1,i2)
      return
      end 

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine get_agency_hyp(file_ind,agency)                            
c                                                                               
c     Routine to return agency in station file                                                      
c                                                                               
c    modified by jh  from stat_loc written by C. Lindholm May 1990                                            
c
c    updates:
c    mar 23,  92 by j.h. : unix adoption
c    Aug. 20 -93 c.l. topdirectory til charachter*60
c    Jan 95      j.h : ********** version 5.0 *******************
c    Feb 2           : bug
c    sep 16 98 jh    : ----------- version 7.0 check ------------
c    oct               changed for 5 char station
c    feb  2 99 lo    : bug fixed
c    feb 19 99 lo    : elev changed to f4.0
c    oct  16   jh    : posibility of reading coordinates with one more digit
c    oct 22    lo    : return if no station file

      implicit none 
      include 'libsei.inc'
      character*3 agency	
c-- station file indicator x in STATIONx.HYP
      character*1 file_ind
c-- string with data read from station file             
      character*80 text
      integer ntext      ! count blank lines		
c-- station file name
      character*80 stat_file
c-- unit and error code
      integer unit,code

      call get_seisan_def

      stat_file=' '

      stat_file(1:12)='STATION0.HYP'
      if(file_ind.ne.' ') stat_file(8:8)=file_ind ! check if alternative file
c
c  Search  file in current, then in DAT 
c
           call sei get file( open$+ignore$,   ! Check for  file.
     &                        unit,            ! Unit (n/a).
     &                        code,            ! Returned condition.
     &                        'DAT',           ! Alternative search directory.
     &                   stat_file )           ! For this filename.

                                                                                
      if (unit.eq.0) then
        write(*,*) ' station file not found '
        return
      endif
c                                                                               
c---- read until agency line found, just after control line                                            
c
      agency=' '
      ntext=0                                                                               
1     continue
      read(unit,'(a)',end=999) text
      if(text.eq.' ') ntext=ntext+1
      if(ntext.lt.3) goto 1
      read(unit,'(a)') text
      read(unit,'(a3)') agency
                                                                  
c
c   no agency found
c

999   continue

     
 20   continue                                                                
      call sei close(close$,unit,code)
      return
      end
