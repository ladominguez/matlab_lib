cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c seed.for
c Routines for reading SEED files and writung miniseed files
c 
c Author: Rodrigo Canabrava
c E-mail: rlpcfr@yahoo.com.br
c Universitetet i Bergen - Department of Earth Sciences
c
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c   This routine writes big endian miniseed by default on all platforms,
c   if litte endian is desired, change variable force_len to true
c


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Summarizes the contents of the file
c The summary is put on the common /file_summary/
c
c
c   changes
c
c june 16 2005 jh: Too many cases of wrong integrity constat. This caused
c                  may files to not be read and also wrong time gap calculation.
c                   The reading routine is now allowed to
c                  continue. Not sure if a real problem. 
c                  Commnt, look for jh 050615
c nov   3 2005 jh : when writing miniseed, header times were wrong by 1
c                   sample
c nov 9   2005 jh: add variable seed_blk_read
c dec 21       jh: fix pc writing, check for platform so reading in nanometrics
c                  way happens directly (is really just pc writing)
c                  which means consistent little endian way
c mar 22 2006  jh: fix so it is possibel to write little or big endian on
c                  all platforms, look for variable force_len
c oct 6  2006  jh: add seed_network
c nove16 2006  jh: convert fracsec to real in one case forgotten
c october 2007 Jh: make reading of network work
c november 10 07 : add time gap to calculation of number of smaples
c                  for one channel
c june 19 08   jh: check also for location code when checking for a 
c                  multiplexed file
c sep 4 08     jh: check first 5 blocks for being multiplexed
c oct 31. 08   jh: check firdt 10 -------------------------
c  dec 16 08   lo: don't read channel with negative time gap of more than
c                   60 as new channel
c  mar 11 10   jh: throw out channels with zero sample rate and zero number
c                  of channels, one more check if max samples have been exceeded
c  xxx xx 10   xx: xxx changes made, see xxx
c  dec 27 10   jh: several logical*1 replaced by logical for gfortran on pc
c  fen 24 11   jh: repace all logical*1 with logical f77

c Parameters:
c - filename: file name
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_contents(filename)

        IMPLICIT NONE
        INCLUDE 'seed.inc.f'
        INCLUDE 'seed_internal.inc.f'

        integer*4 blk_count     ! block counter
        character*80 filename   ! name of file

        logical is_seed_data_record ! auxiliary function
        logical seed_read_block ! auxiliary function
        logical is_seed       ! auxiliary function
        integer*4 get_seed_blk_size ! auxiliary function
        integer*4 read_seed_headers ! auxiliary function
        integer*4 i,j 

        time_tag_flag=.false.     ! xxx inserted  

        BLK_SIZE = 256
        nb_channels = 0

c     open file
        OPEN(STDIN, file = filename, RECL=BLK_SIZE, 
     &       ACCESS='DIRECT', STATUS='OLD')

c     check block size
        IF (is_seed(STDIN)) THEN
           BLK_SIZE = get_seed_blk_size(STDIN)
           IF (BLK_SIZE .GT. MAX_BLK_SIZE) THEN
              WRITE(error_msg,*) 'Blocksize (', BLK_SIZE,') too big!'
              WRITE(*,*) error_msg
              CLOSE(STDIN)
              RETURN
           ENDIF
        ENDIF

c     reopen file, with aproppriate BLK_SIZE
        CLOSE (STDIN)
        OPEN(STDIN, file = filename, RECL=BLK_SIZE,
     &       ACCESS='DIRECT', STATUS='OLD')

c     read SEED headers
        blk_count = read_seed_headers(STDIN)

c     check if block size of data part is the same as in the
c     header part
        IF (seed_read_block(STDIN, blk_count) 
     &       .AND. is_seed_data_record()) THEN
           IF (2**rec_length .NE. BLK_SIZE) THEN
              blk_count = ((blk_count-1)*BLK_SIZE)/(2**rec_length)+1
              BLK_SIZE = 2**rec_length
              CLOSE(STDIN)
              OPEN(STDIN, file = filename, RECL=BLK_SIZE,
     &             ACCESS='DIRECT', STATUS='OLD')
           ENDIF
        ENDIF

        CALL seed_summarize(STDIN, blk_count)

        CLOSE(STDIN)
c
c throw out channels with zero samples and zero sample rate
c
        j=0
        do i=1,nb_channels
           j=j+1
           if(seed_nsamp(i).eq.0.or.seed_rate(i).eq.0.0) then
              j=j-1
              goto 99
           endif
           seed_station(j) =seed_station(i)
           seed_comp(j)=seed_comp(i) 
           seed_location(j)=seed_location(i)
           seed_begin(j)=seed_begin(i)
           seed_end(j)=seed_end(i)
           seed_nsamp(j)= seed_nsamp(i)
           seed_rate(j)=seed_rate(i)
           seed_year(j)=seed_year(i)
           seed_month(j)=seed_month(i)
           seed_day(j)= seed_day(i)
           seed_hour(j)=seed_hour(i)
           seed_minute(j)=seed_minute(i)
           seed_second(j)= seed_second(i)
           seed_bad_time_tag(j)=seed_bad_time_tag(i)
           seed_network(j)=seed_network(i)
           seed_blk_time(j)=seed_blk_time(i)
           seed_chan_time(j)=seed_chan_time(i)
           seed_blk_index(j)= seed_blk_index(i)
c
           chn_name(j) =chn_name(i)
           stn_name(j) =stn_name(i) 
           chn_location(j)= chn_location(i)
           chn_network(j)= chn_network(i)
           chn_begin(j)= chn_begin(i)
           chn_end(j)= chn_end(i) 
           chn_samples(j)=  chn_samples(i) 
           chn_sample_rate(j)= chn_sample_rate(i)
           chn_year(j)= chn_year(i)
           chn_day(j)= chn_day(i)
           chn_hour(j)=  chn_hour(i) 
           chn_minute(j)=chn_minute(i)
           chn_second(j)= chn_second(i) 
           chn_fracsec(j)=  chn_fracsec(i)
           chn_questionable_time_tag(j)=  chn_questionable_time_tag(i)
           nb_channels=j
   
  99       continue
         enddo
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Finds the block that "contains" the given time.
c It starts looking at the block given by "start_point". This means the 
c function can be used sequentially to chop the file, using the
c return value of one run as the "start_point" value to the next run.
c
c Start point is the number of the block in the file, where the search will 
c start.  The parameter can be used if some prior knowledge is availabel
c of where the start block might be. If no knowlwde, use  1. Wrong usage 
c of this parameter migh result in the time start block not being found 
c despite it being in the file. If start point is previous the first 
c block of the channel,  start searching from first block of channel.
c
c Parameters:
c - filename:    file name
c - n:           name of the channel
c - time:        time you want to look for (in seconds from year 1900)
c - start_point: block number where the function should start the search
c - block:       (output) number of block (according to description below)
c
c Return conditions are:
c
c If time is found:
c     return 0      block = block with time
c If time is previous then the beginning of the channel
c     return 1      block = first block of the channel
c If time is after the end of the channel
c     return 2      block = end of the channel
c If start_point is after the end of the channel
c     return 3      block = end of the channel
c If time is before the start point
c     return 4      block = start point
c If time is in a time gap
c     return 5      block = first block after the gap
c
c After calling the routine, the common block /section_summary/ is set
c to hold the information of that block (start time, sample rate, etc.).
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      INTEGER*2 FUNCTION chop_chn(filename, n, time, start_point, block)

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         character*80 filename  ! name of input file
         integer*4 n            ! channel index
         real*8 time            ! time in seconds from year 1900
         integer*4 start_point  ! start point of search
         integer*4 block        ! (output) the block where "time" is

         integer*2 day, month   ! day and month
         real*8 btime           ! start time of block in seconds from 1900
         real*8 endtime         ! end time of block

         real*8    time_to_sec  ! auxiliary function
         logical seed_read_block ! auxiliary function
         logical is_seed_data_record ! auxiliary function
         integer*4 i            ! loop counter

         OPEN(STDIN, file = filename, RECL=BLK_SIZE, 
     &        ACCESS='DIRECT', STATUS='OLD')

c     If time is previous than channel begin, return 1
         CALL get_day_month(day, month, chn_day(n), chn_year(n))
         btime = time_to_sec(chn_year(n), month, day, chn_hour(n),
     &        chn_minute(n), chn_second(n)) + real(chn_fracsec(n))/10000
         IF (time .LT. btime) THEN
            block = chn_begin(n)
            chop_chn = 1
            CALL update_section_summary(STDIN, n, block)
            CLOSE(STDIN)
            RETURN
         ENDIF

c     If start point is previous than beginning of channel, we start
c     in the end of the channel.
         i = start_point
         IF (start_point .LT. chn_begin(n)) THEN
            i = chn_begin(n)
         ENDIF

c     If start point is after the end of the channel, return 3
         IF (start_point .GT. chn_end(n)) THEN
            block = chn_end(n)
            chop_chn = 3
            CALL update_section_summary(STDIN, n, block)
            CLOSE(STDIN)
            RETURN
         ENDIF

c     If time is previous than start point, we return 4:
         IF (seed_read_block(STDIN, i)
     &        .AND. is_seed_data_record()
     &        .AND. (station .EQ. stn_name(n))
     &        .AND. (channel .EQ. chn_name(n))
     &        .AND. (location .EQ. chn_location(n))) THEN
            CALL get_day_month(day, month, day_of_year, year)
            btime = time_to_sec(year,month,day,hour,minute,second)
            btime = btime + real(fracsec)/10000
            IF (time .LT. btime) THEN
               block = start_point
               chop_chn = 4
               CALL update_section_summary(STDIN, n, block)
               CLOSE(STDIN)
               RETURN
            ENDIF            
         ENDIF

         DO WHILE (i .LE. chn_end(n))
            IF (seed_read_block(STDIN,i) 
     &           .AND. is_seed_data_record()
     &           .AND. (station .EQ. stn_name(n)) 
     &           .AND. (channel .EQ. chn_name(n))
     &           .AND. (location .EQ. chn_location(n))) THEN
               CALL get_day_month(day, month, day_of_year, year)
               btime = time_to_sec(year,month,day,hour,minute,second)
               btime = btime + real(fracsec)/10000
               endtime = btime + (n_samples + 1)/chn_sample_rate(n)
c               WRITE(*,*) time, btime, endtime
               IF ((btime .LT. time) .AND. (time .LT. endtime)) THEN
                  block = i
                  chop_chn = 0
                  CALL update_section_summary(STDIN, n, block)
                  CLOSE(STDIN)
                  RETURN
c     if time is in a gap, it was not found before, but we passed it.
c     Then we return 5
               ELSEIF (time .LT. btime) THEN
                  block = i
                  chop_chn = 5
                  CALL update_section_summary(STDIN, n, block)
                  CLOSE(STDIN)
                  RETURN
               ENDIF
            ENDIF
            i = i + 1
         ENDDO

c     if it got here, than the requested time is after the end of the channel
c     so we return 2 
         block = chn_end(n)
         chop_chn = 2
         CALL update_section_summary(STDIN, n, block)
         CLOSE(STDIN)
         RETURN
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Gets the data of the specified channel.
c It uses the information on /file_summary/ in order to locate the channel.
c The channel is specified by its index number on the /file_summary/.
c The function returns the number of samples actually read.
c Information about the section, like start time, sample rate, etc. is
c
c The parameters "first" and "last" are used in order to extract just a
c section of the channel. They are the number of blocks in the file.
c
c If "first" happens before the beginning of the channel, the function
c starts from the beginning of the channel.
c
c If "last" is greater then the end of the channel, or equal to zero, the
c function reads until the end of the channel.
c
c Parameters:
c - fname: file name
c - n:     number of the channel
c - buf:   (output) buffer where samples should be placed
c - first: first block to be read
c - last:  last block to be read
c
c Return: number of samples read in the request
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION seed_read_chn(fname, n, buf, first, last)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
         INCLUDE 'seed.inc.f'

         character*80 fname     ! input file name
         integer*4 n            ! number of the channel

         integer*4 buf(*)    ! place to put samples
         integer*4 input(32768/4) ! input to decompression routines
         character*32768 c_input ! temporary for casting 
         integer*4 end_buf      ! pointer to next empty position in buf
         logical nanometrics  ! checks if file is nanometrics style
         logical is_first_blk ! .TRUE. if it's the first requested block
         integer*4 first, first_ ! first block that is to be read
         integer*4 last, last_  ! last block that is to be read
         integer*4 blk_count    ! number of blocks read in file
         integer*2 day, month   ! day and month
         equivalence(c_input, input)

         logical seed_read_block ! auxiliary function
         logical is_seed_data_record ! auxiliary function
         logical read_steim1  ! auxiliary function
         integer*4 read_chn_nanometrics ! auxiliary function
         real*8    time_to_sec  ! auxiliary function
         integer*4 i            ! loop counter
         integer*2 get_doy
         logical computer_word_order  ! function

c
c jh   find which platform
c
         seed_pc=.true.       ! default is pc-linux
         if (computer_word_order()) seed_pc=.false.               

        OPEN(STDIN, file = fname, RECL=BLK_SIZE, 
     &       ACCESS='DIRECT', STATUS='OLD')

         end_buf = 1
         blk_count = 1
         nanometrics = .FALSE.

         first_ = first
         last_ = last

         IF (first_ .LT. chn_begin(n)) THEN
            first_ = chn_begin(n)
         ENDIF
         IF ((last_ .EQ. 0)) last_ = chn_end(n)
         IF (last_ .GT. chn_end(n)) last_ = chn_end(n)

         is_first_blk = .TRUE.
c        decompresses one block at a time
         DO i = first_, last_
           IF (seed_read_block(STDIN,i) 
     &           .AND. is_seed_data_record()
     &           .AND. (station .EQ. stn_name(n)) 
     &           .AND. (channel .EQ. chn_name(n))
     &           .AND. (location .EQ. chn_location(n))
     &           .AND. (end_buf + n_samples .LE. MAX_SAMP)
     &           .AND. (.NOT. nanometrics)) THEN

              CALL get_day_month(day, month, day_of_year, year)
              seed_blk_time(blk_count) = time_to_sec(year, month, day,
     &             hour, minute, second) + real(fracsec)/10000
              seed_blk_index(blk_count) = end_buf
              blk_count = blk_count + 1

              IF (is_first_blk) THEN
                 CALL update_section_summary(STDIN, n, i)
                 is_first_blk = .FALSE.
              ELSE
                 seed_end(n) = i
              ENDIF
              IF (questionable_time_tag) seed_bad_time_tag(n) = .TRUE.

              c_input = seed_record(data_p+1:BLK_SIZE)
              IF (is_swapped) THEN
                 CALL swap_buffer(input, (BLK_SIZE - data_p)/4 )
              ENDIF
c
c   if data written on pc platform it will probably be on nanometrics order
c   only working for steim1     cjh
c
              if((seed_pc.and.encoding.eq.steim_1.and..not.is_swapped).
     *        or.(.not.seed_pc.and.encoding.eq.steim_1.and.is_swapped))
     *        then
                nanometrics=.true.
                goto 1000
              endif

c             call the correct reading function
              IF (encoding .EQ. STEIM_1) THEN    
c     On the first trial, the reader tries to read the program as a
c     standard Steim1. If, in any attempt, it fails (read_steim1 returns
c     false), it gives up standard steim1, resets the reading, and from 
c     that moment on it tries to read the blocks as a Nanometrics "Steim1"
c     style.
                 nanometrics = .NOT. read_steim1(input, 
     &                buf(end_buf), n_samples)
              ELSEIF (encoding .EQ. STEIM_2) THEN
                 CALL read_steim2(input, buf(end_buf), n_samples)
              ELSEIF (encoding .EQ. INT_32BIT) THEN
                 CALL read_32bit(input, buf(end_buf), n_samples)
              ELSE
                 WRITE(error_msg, *) 'ERROR - Unknown encoding format!'
                 WRITE(STDOUT,*) error_msg
                 seed_read_chn = 0
                 RETURN
              ENDIF

              end_buf = end_buf + n_samples
           ENDIF
c
c  check for samples, jh mar 10
c
           if(end_buf + n_samples .ge. MAX_SAMP) then
              write(6,*)' Too many samples in seed read'
              stop
           endif
        ENDDO

c
cjh   
c
 1000    continue
         IF (nanometrics) THEN
            seed_nsamp(n) = read_chn_nanometrics(STDIN, n, buf)
            seed_read_chn = seed_nsamp(n)
            CLOSE(STDIN)
            RETURN
         ENDIF

c     reports error message if the buf is not big enough
        IF ((end_buf + n_samples) .GT. MAX_SAMP) THEN
           WRITE(error_msg,*) 'Number of samples (',end_buf + n_samples,
     &          ') not supported. Number of samples read: ', end_buf - 1
           WRITE(STDOUT,*) error_msg
        ENDIF

        seed_nsamp(n) = end_buf - 1
        seed_read_chn = end_buf - 1

        CLOSE(STDIN)
c

        seed_blk_read=blk_count-1
        RETURN

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Updates the section summary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE update_section_summary(file, n, blk_number)

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file number
         integer*4 n            ! number of channel
         integer*4 blk_number   ! number of a block
         integer*2 day          ! day of start of section
         integer*2 month        ! month of start of section

         logical is_seed_data_record ! auxiliary function
         logical seed_read_block ! auxiliary function

         IF (seed_read_block(STDIN, blk_number)
     &        .AND. is_seed_data_record()) THEN
            seed_station(n) = station
            seed_comp(n) = channel
            seed_location(n) = location
            seed_network(n) = network
c           write(6,*)'seed net',network
            seed_year(n) = year
            CALL get_day_month(day, month, day_of_year, year)
            seed_month(n) = month
            seed_day(n) = day
            seed_hour(n) = hour
            seed_minute(n) = minute
            seed_second(n) = second + real(fracsec)/10000.0
            seed_rate(n) = sample_rate
            seed_bad_time_tag(n) = questionable_time_tag
            seed_nsamp(n) = n_samples
            seed_begin(n) = blk_number
            seed_end(n) = blk_number
         ENDIF
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Checks if the file is multiplexed or not, and calls the 
c appropriate function to summarize the file.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_summarize(file, blk_count)

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! file number
         integer*4 blk_count    ! block counter

         logical miniseed_is_multiplexed ! auxiliary function

         IF (miniseed_is_multiplexed(file, blk_count)) THEN
            WRITE(*,*) 'multiplexed'
            CALL summarize_multiplexed(file, blk_count)
         ELSE
            CALL summarize_sequential(file, blk_count)
         ENDIF
         
         CALL reset_section_summary()

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Summarizes the file as if it contains sequential channels
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE summarize_sequential(file, blk_count)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
         INCLUDE 'seed.inc.f'

         integer*4 file         ! input file
         integer*4 blk_count    ! block counter
         real*8 seed_this_chan_time  ! abs time of current channel
         real*8 time_gap         ! time gap two blocks
         integer*4 nsample_in_time_gap ! time gap in samples
         real sample_rate_this_block
         integer*2 day, month   ! day and month
         real*8    time_to_sec  ! auxiliary function
         real*4    calculate_sample_rate ! auxiliary function

         logical is_seed_data_record ! auxiliary function
         logical seed_read_block ! auxiliary function

         DO WHILE (seed_read_block(file, blk_count))
            IF (is_seed_data_record()) THEN
c moved here 16/12/2008 lot
c
c   calculate abs time for block start time in following block 
c   and store for this channes
c   first get abs time of thsi block
c
              CALL get_day_month(day, month, day_of_year, year)
              seed_this_chan_time = time_to_sec(year, month, day,
     &             hour, minute, second) + real(fracsec)/10000
               
c     if it's not the same channel as the previous one,
c     then it's a new channel
               IF (nb_channels .NE. 0) THEN 
                  IF ((station .NE. stn_name(nb_channels))
     &                 .OR.(channel .NE. chn_name(nb_channels))
     &                 .OR. (location .NE. chn_location(nb_channels))
     & .OR. seed_this_chan_time-seed_chan_time(nb_channels).lt.-60.) 
     &                 THEN
                     CALL seed_add_chn(blk_count)
                  ELSE
c     if it is the same channel, update values
                     chn_end(nb_channels) = blk_count
c
c   calculating sample rate
c
                     sample_rate_this_block = 
     *               calculate_sample_rate(sample_rate_factor,
     &               sample_rate_multiplier)
c
c  check for a time gap
c
                    time_gap=seed_this_chan_time-
     *              seed_chan_time(nb_channels)
c
c   calculate time of next block this channel and store 
c
                     seed_chan_time(nb_channels)=n_samples/
     *               sample_rate_this_block+seed_this_chan_time
c
c                    write(17,'(3(1x,i5),1x,f5.1,2f13.1,1x,f6.2)') 
c    *               blk_count,nb_channels,n_samples,
c    *               sample_rate_this_block,
c    *               seed_this_chan_time, 
c    *               seed_chan_time(nb_channels),
c    *               time_gap 
c
c   calculate how many samples in time gap,if less than one sample
c   it is rounded off to 0
c
                     nsample_in_time_gap=
     *               time_gap*sample_rate_this_block
                     chn_samples(nb_channels) = 
     &                    chn_samples(nb_channels) + n_samples
c
c   add the time gap smaples to toal number of samples if positive
c   and 'reasonable', less than 100 000
c
                     if(nsample_in_time_gap.gt.0.and.
     *                  nsample_in_time_gap.lt.100000) 
     *               then
                       write(6,*)
     *                 ' Time gap', nsample_in_time_gap
                       chn_samples(nb_channels)=
     *                 chn_samples(nb_channels)
     *                 + nsample_in_time_gap
                     endif
c
c   stop if too big time gap
c
                     if(nsample_in_time_gap.gt.100000) then
                       write(6,*) 'Time gap in samples',
     *                 nsample_in_time_gap
                       write(6,*)'Unrealistic, will stop'
                     endif

c
c   if time gap is negative, only a warning that data is unrelaible
c
                     if(nsample_in_time_gap.lt.0) then
                        write(6,*)
     *                  ' Negative time gap, data unreliable'
                     endif
                     IF (questionable_time_tag) THEN
                        chn_questionable_time_tag(nb_channels) = .TRUE.
                     ENDIF
                  ENDIF
               ELSE
                  CALL seed_add_chn(blk_count)
               ENDIF
            ENDIF 
            blk_count = blk_count + 1
         ENDDO
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Resets the /section_summary/, so it will be identical as the 
c /file_summary/
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE reset_section_summary()

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'

         integer*4 i            ! loop counter
         integer*2 day, month   ! day and month

         DO i = 1, nb_channels
            seed_station(i) = stn_name(i)
            seed_comp(i) = chn_name(i)
            seed_location(i) = chn_location(i)
            seed_network(i) = chn_network(i)
            seed_begin(i) = chn_begin(i)
            seed_end(i) = chn_end(i)
            seed_nsamp(i) = chn_samples(i)
            seed_bad_time_tag(i) = chn_questionable_time_tag(i)
            seed_rate(i) = chn_sample_rate(i)
            seed_second(i) = chn_second(i) + real(chn_fracsec(i))/10000
            seed_minute(i) = chn_minute(i)
            seed_hour(i) = chn_hour(i)
            CALL get_day_month(day, month, chn_day(i), chn_year(i))
            seed_day(i) = day
            seed_month(i) = month
            seed_year(i) = chn_year(i)

         ENDDO
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Summarizes the file as if it has intercalated (multiplexed) channels
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE summarize_multiplexed(file, blk_count)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
         INCLUDE 'seed.inc.f'

         integer*4 file         ! input file
         integer*4 blk_count    ! block counter
         integer*4 index        ! index number of channel

         logical is_seed_data_record ! auxiliary function
         logical seed_read_block ! auxiliary function
         integer*4 get_channel_index ! auxiliary function

         DO WHILE (seed_read_block(file, blk_count))
            IF (is_seed_data_record()) THEN
               index = get_channel_index(station, channel, location)
c     if it does not have an index, it's a new channel
               IF (index .EQ. 0) THEN
                  CALL seed_add_chn(blk_count)
               ELSE
c     if it already has a summary, update values
                  chn_end(index) = blk_count
                  chn_samples(index) = chn_samples(index) + n_samples
                  IF (questionable_time_tag) THEN
                     chn_questionable_time_tag(index) = .TRUE.
                  ENDIF
               ENDIF
            ENDIF
            blk_count = blk_count + 1
         ENDDO

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Checks if the records order is multiplexed or grouped by channel
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION miniseed_is_multiplexed(file, start)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4   file     ! input file
         integer*4   start    ! beginning of data records section
         character*5 station1 ! station of first block
         character*3 channel1 ! channel of first block
         character*5 station2 ! station of second block
         character*3 channel2 ! channel of second block
         character*2 location1 ! loication code of first block
         character*2 location2 ! location coode of second block
         integer i

         logical seed_read_block ! auxiliary function

         miniseed_is_multiplexed = .FALSE.
         IF (seed_read_block(file, start)) THEN
            station1 = station
            channel1 = channel
            location1 = location      ! jh june 2008
         ELSE
            RETURN
         ENDIF
c
c   first 10 blocks must tbe idendical, if not multiplexed
c
         do i=1,9
         IF (seed_read_block(file, start + i)) THEN
            station2 = station
            channel2 = channel
            location2 =location
            if(station2.ne.station1.or.location2.ne.location1.or.
     *      channel2.ne.channel1) then
               miniseed_is_multiplexed = .TRUE.
               return
            endif
         ELSE
            RETURN
         ENDIF
         enddo
         ! if there are 2 channels in the first 2 blocks then
         ! the file is multiplexed
c         IF ((station1 .EQ. station2) 
c     &      .AND. 
c     *   (channel1 .NE. channel2.or.location1.ne.location2))  
c     *   THEN
c            miniseed_is_multiplexed = .TRUE.
c         ENDIF
         RETURN 

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Gives the index in the table for this station|channel.
c Returns zero if the pair station|channel is not found.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION get_channel_index(station, channel, location)
      
         IMPLICIT NONE
         INCLUDE 'seed.inc.f'

         character*5 station ! station name
         character*3 channel ! channel id
         character*2 location ! location id

         integer i ! loop counter

         get_channel_index = 0
         DO i = 1, nb_channels
            IF ((station .EQ. stn_name(i)) 
     &           .AND. (channel .EQ. chn_name(i))
     &           .AND. (location .EQ. chn_location(i))) THEN
               get_channel_index = i
               RETURN
            ENDIF
         ENDDO
         RETURN
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Adds an entry for the channel in the file summary.
c The summary is on the common /file_summary/
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_add_chn(blk_count)
         
         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
         INCLUDE 'seed.inc.f'
         
         integer*2 day, month   ! day and month
         real*8    time_to_sec  ! auxiliary function
         
         integer*4 blk_count ! the number of current block (in the file)

         nb_channels = nb_channels + 1
         chn_name(nb_channels) = channel
         stn_name(nb_channels) = station
         chn_location(nb_channels) = location
         chn_network(nb_channels) = network
c        write(6,*)'seed 2. net',network
         chn_begin(nb_channels) = blk_count
         chn_end(nb_channels) = blk_count
         chn_samples(nb_channels) = n_samples
         chn_year(nb_channels) = year
         chn_day(nb_channels) = day_of_year
         chn_hour(nb_channels) = hour
         chn_minute(nb_channels) = minute
         chn_second(nb_channels) = second
         chn_fracsec(nb_channels) = fracsec
         chn_sample_rate(nb_channels) = sample_rate
c
c  abs time for time gap checking
c
         CALL get_day_month(day, month, day_of_year, year)
         seed_chan_time(nb_channels) = time_to_sec(year, month, day,
     &   hour, minute, second) + real(fracsec)/10000
c
c   calculate time of next block this channel and store 
c
          seed_chan_time(nb_channels)=n_samples/
     *    sample_rate+seed_chan_time(nb_channels)
c
         IF (questionable_time_tag) THEN
            chn_questionable_time_tag(nb_channels) = .TRUE.
         ELSE
            chn_questionable_time_tag(nb_channels) = .FALSE.
         ENDIF
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads channels from a nonometrics file.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION read_chn_nanometrics(file, n, buf)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
         INCLUDE 'seed.inc.f'

         integer*4 file         ! file number
         integer*4 n            ! channel number
         integer*4 buf(*)    ! buffer for decompressed samples
         integer*4 input(32768/4) ! input to decompression routines
         character*32768 c_input ! temporary for casting 
         integer*4 end_buf      ! pointer to next empty position in buf
         logical is_first_blk ! true if it is the first block

         equivalence(c_input, input)

         logical seed_read_block ! auxiliary function
         logical is_seed_data_record ! auxiliary function

         integer*4 i            ! counter

         end_buf = 1
         is_first_blk = .TRUE.

         DO i = chn_begin(n), chn_end(n)
           IF (seed_read_block(file,i) 
     &           .AND. is_seed_data_record()
     &           .AND. (station .EQ. stn_name(n)) 
     &           .AND. (channel .EQ. chn_name(n))
     &           .AND. (location .EQ. chn_location(n))
     &           .AND. (end_buf + n_samples .LE. MAX_SAMP)) THEN

              IF (is_first_blk) THEN
                 CALL update_section_summary(file, n, i)
                 is_first_blk = .FALSE.
              ELSE
                 seed_end(n) = i
              ENDIF
              IF (questionable_time_tag) seed_bad_time_tag(n) = .TRUE.


              c_input = seed_record(data_p+1:BLK_SIZE)
              CALL read_nanometrics(input, buf(end_buf), n_samples, 
     &             is_swapped )
              end_buf = end_buf + n_samples
           ENDIF
        ENDDO
        
        read_chn_nanometrics = end_buf -1

        IF ((end_buf + n_samples) .GT. MAX_SAMP) THEN
           WRITE(error_msg,*) 'Number of samples (',end_buf + n_samples,
     &          ') not supported. Number of samples read: ', end_buf - 1
           WRITE(STDOUT,*) error_msg
        ENDIF

        RETURN

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read a block from a file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION seed_read_block(file, n)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
         INCLUDE 'seed.inc.f'

         integer*4 file         ! input file
         integer*4 n            ! number of block

         integer*4 ios          ! io status

         READ(file, REC=n, IOSTAT=ios) seed_record(1:BLK_SIZE)
         IF (ios .NE. 0) THEN
            seed_read_block = .FALSE.
            RETURN
         ENDIF
         
         seed_read_block = .TRUE.
         RETURN

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Tests if the file is SEED.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION is_seed(file)

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file

         logical seed_read_block ! auxiliary function

         IF (seed_read_block(file, 1)) THEN
            IF (seed_record(1:8) .EQ. '000001V ') THEN
               is_seed = .TRUE.
               RETURN
            ENDIF       
         ENDIF

         is_seed = .FALSE.
         RETURN

      END

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Checks if the block is a data record.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION is_seed_data_record()

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         logical seed_is_swapped ! auxiliary function
         integer*2 toint        ! auxiliary function
         real*4    calculate_sample_rate ! auxiliary function

c         WRITE(*,*) seed_record(1:8)
         IF ( (header_type .EQ. 'D')
     &        .OR. (header_type .EQ. 'R')
     &        .OR. (header_type .EQ. 'Q')) THEN
            
c     converting 1-byte fields
            hour = toint(hour_)
            minute = toint(minute_)
            second = toint(second_)

c        checking if file has different byte order
            is_swapped = seed_is_swapped()
            IF (is_swapped) THEN
               CALL seed_swap_header()
            ENDIF

c        calculating sample rate
            sample_rate = calculate_sample_rate(sample_rate_factor,
     &           sample_rate_multiplier)

            CALL miniseed_read_blockettes()
            CALL seed_treat_flags()

c            WRITE (*,*) seq_number, year, day_of_year, hour, minute, 
c     &           second, fracsec, ',    ', real(n_samples)/sample_rate,
c     &           encoding

            is_seed_data_record = .TRUE.
            RETURN
         ENDIF       

         is_seed_data_record = .FALSE.
         RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads a block of Volume Control Header
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION read_seed_volume_header(file, n)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file
         integer*4 n            ! number of block

         logical seed_read_block ! auxiliary function

         IF (seed_read_block(file, n)) THEN
            IF (header_type .EQ. 'V') THEN
               read_seed_volume_header = .TRUE.
               RETURN
            ENDIF       
         ENDIF

         read_seed_volume_header = .FALSE.
         RETURN
         
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads a block of Abbreviation Control Header
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION read_seed_abbrv_header(file, n)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file
         integer*4 n            ! number of block

         logical seed_read_block ! auxiliary function

         IF (seed_read_block(file, n)) THEN
            IF (header_type .EQ. 'A') THEN
               read_seed_abbrv_header = .TRUE.
               RETURN
            ENDIF       
         ENDIF

         read_seed_abbrv_header = .FALSE.
         RETURN
         
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads a block of Station Control Header
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION read_seed_station_header(file, n)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file
         integer*4 n            ! number of block

         logical seed_read_block ! auxiliary function

         IF (seed_read_block(file, n)) THEN
            IF (header_type .EQ. 'S') THEN
               read_seed_station_header = .TRUE.
               RETURN
            ENDIF       
         ENDIF

         read_seed_station_header = .FALSE.
         RETURN
         
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads a block of Time Span Control Header
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION read_seed_time_header(file, n)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file
         integer*4 n            ! number of block

         logical seed_read_block ! auxiliary function

         IF (seed_read_block(file, n)) THEN
            IF (header_type .EQ. 'T') THEN
               read_seed_time_header = .TRUE.
               RETURN
            ENDIF       
         ENDIF

         read_seed_time_header = .FALSE.
         RETURN
         
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Defines the block size of the SEED file.
c It checks the Volume control headers from the blockette 5, 8 or 10.
c The first blockette of the file must be one of those.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION get_seed_blk_size(file)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4   file     ! input file
         character*3 blk_type ! type of blockette

         logical read_seed_volume_header ! auxiliary function

         IF (read_seed_volume_header(file, 1)) THEN

            blk_type = seed_record(9:11)

            IF ((blk_type .EQ. '005')
     &           .OR. (blk_type .EQ. '008')
     &           .OR. (blk_type .EQ. '010')) THEN

               READ(seed_record(20:21), *) rec_length
               get_seed_blk_size = 2**rec_length
               RETURN

            ENDIF

         ENDIF


c     wrong file
         get_seed_blk_size = 0
         RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads the SEED headers.
c Returns the number of the block where the data records start.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION read_seed_headers(file)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4 file         ! input file
         integer*4 nb           ! number of blocks on header section

         logical read_seed_volume_header  ! auxiliary function
         logical read_seed_abbrv_header   ! auxiliary function
         logical read_seed_station_header ! auxiliary function
         logical read_seed_time_header    ! auxiliary function

         nb = 1

c     Volume Control Headers
         DO WHILE (read_seed_volume_header(file, nb))
c            WRITE (*,*) seed_record(1:50)
            nb = nb + 1
         ENDDO

c     Abbreviation Dictionary Control Headers
         DO WHILE (read_seed_abbrv_header(file, nb))
c            WRITE (*,*) seed_record(1:8)
            CALL interp_abbr_hdr()
            nb = nb + 1
         ENDDO

c     Station Control Headers
         DO WHILE (read_seed_station_header(file, nb))
c            WRITE (*,*) seed_record(1:8)
            CALL interp_stn_hdr()
            nb = nb + 1
         ENDDO

c     Time Span Control Headers
         DO WHILE (read_seed_time_header(file, nb))
c            WRITE (*,*) seed_record(1:8)
            nb = nb + 1
         ENDDO

         read_seed_headers = nb
         RETURN         

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Interprets the information on the abbreviation header block
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE interp_abbr_hdr()

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         integer*4   p          ! pointer to position in seed_record
         character*3 blk_type   ! blockette type
         integer*4   size       ! size of blockette

         logical is_valid_abbr_blk ! auxiliary function

         SAVE p, blk_type, size

         IF (continuation .NE. '*') THEN
            p = 9
         ELSE
            p = p - BLK_SIZE + 8
         ENDIF

         DO WHILE ((p .LE. BLK_SIZE)
     &        .AND. is_valid_abbr_blk(seed_record(p:p+2)))

            blk_type = seed_record(p:p+2)

            IF (blk_type .EQ. '030') THEN
               CALL parse_30(p)
            ENDIF

            READ(seed_record(p+3:p+6),*) size

            p = p + size

         ENDDO

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Interprets the information on the station header block
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE interp_stn_hdr()

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         integer*4   p          ! pointer to position in seed_record
         character*3 blk_type   ! blockette type
         integer*4   size       ! size of blockette
         character*5 stn        ! station name

         logical is_valid_stn_blk ! auxiliary function

         SAVE p, blk_type, size, stn

         IF (continuation .NE. '*') THEN
            p = 9
         ELSE
            p = p - BLK_SIZE + 8
         ENDIF


         DO WHILE ((p .LE. BLK_SIZE) 
     &        .AND. is_valid_stn_blk(seed_record(p:p+2)))

            blk_type = seed_record(p:p+2)

            IF (blk_type .EQ. '050') THEN
c               stn = seed_record(p+7:p+11)

            ELSEIF (blk_type .EQ. '052') THEN
c               nb_channels = nb_channels + 1
c               stn_name(nb_channels) = stn
c               chn_name(nb_channels) = seed_record(p+9:p+11)
c               WRITE(*,*) stn
               CALL parse_52(p)
            ENDIF

            READ(seed_record(p+3:p+6),*) size

            p = p + size

         ENDDO

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Detects if blockette type is valid in Abbreviation Control Headers
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION is_valid_abbr_blk(type)

         IMPLICIT NONE
         
         integer*4   i          ! loop counter
         character*3 type       ! type to test
         character*3 types(14)  ! types of blockette
         data types / '030','031','032','033','034','035','041','042',
     &              '043','044','045','046','047','048'  /

         DO i = 1, 14
            IF (type .EQ. types(i)) THEN
               is_valid_abbr_blk = .TRUE.
               RETURN
            ENDIF
         ENDDO

         is_valid_abbr_blk = .FALSE.
         RETURN

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Detects if blockette type is valid in Station Control Headers
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION is_valid_stn_blk(type)

         IMPLICIT NONE
         
         integer*4   i          ! loop counter
         character*3 type       ! type to test
         character*3 types(13)  ! types of blockette
         data types / '050','051','052','053','054','055','056','057',
     &              '058','059','060','061','062'  /

         DO i = 1, 13
            IF (type .EQ. types(i)) THEN
               is_valid_stn_blk = .TRUE.
               RETURN
            ENDIF
         ENDDO

         is_valid_stn_blk = .FALSE.
         RETURN

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Parses blockette 30
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE parse_30(p)

         IMPLICIT NONE
         INCLUDE 'seed.inc.f'
         INCLUDE 'seed_internal.inc.f'

         integer*4    p, q      ! pointer to beginning of blockette
         integer*4    tilde     ! position of tilde in variable length fields
         character*3  blk_type  ! blockette type
         integer*4    size      ! size of blockette
         character*50 description ! description of encoding format
         character*4  format_code ! format identifier code
         character*3  family_type ! data family type
         character*2  n_keys    ! number of decoder keys
         character*5  keys(50)  ! decoder keys

         

         blk_type = seed_record(p:p+2)
         READ(seed_record(p+3:p+6),*) size

c     next (short descriptive name) field is variable length.
c     So, we have to look for the tilde, in order to know where it ends.
c     And the following fields will have their position determined by
c     an offset from this tilde.
         tilde = INDEX(seed_record(p+7:p+56), '~')
         q = p+7+tilde
         description = seed_record(p+7:q-1)

c         WRITE(*,*) blk_type, description

c     If the description has any of the following: steim2, Steim2,
c     STEIM2, steim 2, steim-2, steim_2, steim level 2, etc.,
c     than the encoding format is Steim 2. 
c     If description has: steim, Steim 1, Steim-1, etc, than the
c     encoding is Steim 1.
         CALL upper_s(description)
         IF (INDEX(description, S_STEIM) .NE. 0) THEN
            IF (INDEX(description, '2') .NE. 0) THEN
               encoding = STEIM_2
            ELSE
               encoding = STEIM_1
            ENDIF
         ENDIF

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Parses blockette 52.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE parse_52(p)

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*4    p,q       ! pointer to beginning of blockette
         integer*4    tilde     ! position of tilde in variable length fields
         character*3  blk_type  ! blockette type
         integer*4    size      ! size of blockette
         character*2  loc       ! location identifier
         character*3  chn       ! channel name
         character*4  subchn    ! subchannel id
         character*3  instrument ! instrument id
         character*30 comment   ! optional variable length comment
         character*3  sig_unit  ! units of signal response
         character*3  cal_unit  ! units of calibration input
         real*4       latitude  ! latitude
         real*4       longitude ! longitude
         real*4       elevation ! elevation
         real*4       depth     ! local depth
         real*4       azimuth   ! azimuth (degrees)
         real*4       dip       ! dip
         character*4  encode_id ! format identifier code
         real*4       s_rate    ! sample rate
         real*4       clk_drift ! max clock drift
         character*4  n_comments ! number of comments
         character*26 chn_flags ! channel flags
         character*22 start_date ! start date
         character*22 end_date  ! end date

         blk_type = seed_record(p:p+2)
         READ(seed_record(p+3:p+6),*) size
         loc = seed_record(p+7:p+8)
         chn = seed_record(p+9:p+11)
         subchn = seed_record(p+12:p+15)
         instrument = seed_record(p+16:p+18)
c     next field is variable length
         tilde = INDEX(seed_record(p+19:p+48), '~')
         q = p+19+tilde
         comment = seed_record(p+19:q-1)
         sig_unit = seed_record(q:q+2)
         cal_unit = seed_record(q+3:q+5)
c         READ(seed_record(q+6:q+15),*) latitude
c         READ(seed_record(q+16:q+26),*) longitude
c         READ(seed_record(q+27:q+33),*) elevation
c         READ(seed_record(q+34:q+38),*) depth
c         READ(seed_record(q+39:q+43),*) azimuth
c         READ(seed_record(q+44:q+48),*) dip
         encode_id = seed_record(q+49:q+52)
c         READ(seed_record(q+53:q+54),*) rec_length
c         READ(seed_record(q+55:q+64),*) s_rate
c         READ(seed_record(q+65:q+74),*) clk_drift
         n_comments = seed_record(q+75:q+78)
c     other variable length fields:
         tilde = INDEX(seed_record(q+79:q+104), '~')
         chn_flags = seed_record(q+79:q+79+tilde-1)
         q = q+79+tilde
         tilde = INDEX(seed_record(q:q+21), '~')
         start_date = seed_record(q:q+tilde-1)
         q = q+tilde
         tilde = INDEX(seed_record(q:q+21), '~')
         end_date = seed_record(q:q+tilde-1)
         

c         WRITE(*,*) blk_type, size
c         WRITE(*,*) loc, ' ', chn, ' ', subchn, ' ', instrument
c         WRITE(*,*) rec_length, s_rate, ' ',seed_record(q+55:q+64)
c         WRITE(*,*) chn_flags
c         WRITE(*,*) start_date
c         WRITE(*,*) end_date
         

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Searches for blockettes, and extract the information wanted from each one.
c So far only checks blockettes 100 and 1000
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE miniseed_read_blockettes()

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*2 swap_2byte, toint ! auxiliary functions
         integer*4 swap_4byte        ! auxiliary function

c Nasty trick in order to convert from char to an integer
         integer*2   next          ! offset to next blockette
         character*2 c_next        ! temp in order to make casting
         equivalence(next, c_next)

         integer*2   type       ! type of blockette
         character*2 c_type     ! temp in order to make casting
         equivalence(type, c_type)

         character*4 c_sample   ! sample rate in blockette 100
         integer*4 sample_i     ! auxiliary variable
         real*4    sample_r     ! auxiliary variable
         equivalence(c_sample, sample_rate)
         equivalence(sample_i, sample_r)


c         equivalence(sample, sample_rate)

c        Gets first block
         next = first_blk

         DO WHILE (next .NE. 0)

c           Gets blocks type
            c_type = seed_record(next+1: next+2)       
            IF (is_swapped) THEN
               type = swap_2byte(type)
            ENDIF
c            WRITE(*,*) 'Blockette ', type, next

c           Gets the information wanted in the current blockette
            IF (type .EQ. 100) THEN
c     First, we cast from character*4 to real*4.
               c_sample = seed_record(next+5:next+8)
c     But if we have to swap it, we have to cast to integer.
               sample_r = sample_rate
               IF (is_swapped) THEN
                  sample_i = swap_4byte(sample_i)
                  sample_rate = sample_r
               ENDIF
            ELSEIF (type .EQ. 1000) THEN
               encoding = toint(seed_record(next+5:next+5))
               rec_length = toint(seed_record(next+7: next+7))
c               WRITE (*,*) encoding, rec_length, 
c     &              toint(seed_record(next+6:next+6))
            ELSEIF (type .EQ. 1001) THEN
               timing_quality = toint(seed_record(next+5:next+5))
               usec = toint(seed_record(next+6:next+6))
               n_frames = toint(seed_record(next+8:next+8))
c               WRITE(*,*) timing_quality, usec, n_frames
            ENDIF

c           Go to next blockette
            c_next = seed_record(next+3:next+4)
            IF (is_swapped) THEN
               next = swap_2byte(next)
            ENDIF

         END DO

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Treat some flags
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_treat_flags()
      
         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'
      
         integer*2 toint ! auxiliary function
         integer*2 seed_qual_missing_data         ! mask
         integer*2 seed_qual_questionable_timetag ! mask
         integer*2 seed_act_begin_event           ! mask
         data seed_qual_missing_data /z'0010'/
         data seed_qual_questionable_timetag /z'0080'/
         data seed_act_begin_event /z'0004'/

         questionable_time_tag = .FALSE.
         IF (IAND(toint(activity_flags), 
     &      seed_act_begin_event) .NE. 0) THEN
            WRITE (*,*) 'WARNING - beginning of event in record ',
     &           seq_number
         ENDIF

         IF (IAND(toint(quality_flags), 
     &      seed_qual_missing_data) .NE. 0) THEN
            WRITE (*,*) 'WARNING - data missing in record ',
     &           seq_number
         ENDIF
         IF (IAND(toint(quality_flags), 
     &      seed_qual_questionable_timetag) .NE. 0) THEN
            questionable_time_tag = .TRUE.
            if (.not.time_tag_flag) then              ! xxx inserted  
            WRITE (*,*) 'WARNING - questionable time tag in ',
     &           'record ', seq_number
              time_tag_flag=.true.                    ! xxx inserted 
            endif                      
         ENDIF

      END 


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Tests if data must be swapped.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION seed_is_swapped()
         
         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         IF ((day_of_year .GT. 366) .OR. (day_of_year .LT. 0)
     &        .OR. (fracsec .GT. 9999) .OR. (fracsec .LT. 0)
     &        .OR. (year .GT. 2056) .OR. (year .LT. 1950)) THEN
            seed_is_swapped = .TRUE.
c            WRITE(*,*) 'SWAPPED!!!'
         ELSE
            seed_is_swapped = .FALSE.
c            WRITE(*,*) 'NOT SWAPPED!!!'
         ENDIF

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Swaps fields in header
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_swap_header()

         IMPLICIT NONE
         INCLUDE 'seed_internal.inc.f'

         integer*2 swap_2byte ! auxiliary function
         integer*4 swap_4byte ! auxiliary function

         year = swap_2byte(year)
         day_of_year = swap_2byte(day_of_year)
         fracsec = swap_2byte(fracsec)
         n_samples = swap_2byte(n_samples)
         sample_rate_factor = swap_2byte(sample_rate_factor)
         sample_rate_multiplier = swap_2byte(sample_rate_multiplier)
         time_correction = swap_4byte(time_correction)
         data_p = swap_2byte(data_p)
         first_blk = swap_2byte(first_blk)

      END



cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Swaps fields in output header 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_swap_output_header()

         IMPLICIT NONE
c        INCLUDE 'seed_internal.inc.f'
         include 'write_mseed_internal.inc.f'

         integer*2 swap_2byte ! auxiliary function
         integer*4 swap_4byte ! auxiliary function

         year_ = swap_2byte(year_)
         day_of_year_ = swap_2byte(day_of_year_)
         fracsec_ = swap_2byte(fracsec_)
         n_samples = swap_2byte(n_samples)
         sample_rate_factor = swap_2byte(sample_rate_factor)
         sample_rate_multiplier = swap_2byte(sample_rate_multiplier)
         time_correction = swap_4byte(time_correction)
         data_p = swap_2byte(data_p)
         first_blk = swap_2byte(first_blk)
         blk_type_1000=swap_2byte(blk_type_1000)
         next_1000=swap_2byte(next_1000)

      END

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Returns the integer value inside the character variable
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*2 FUNCTION toint(input)

         IMPLICIT NONE
         character*1 input            ! input
         character*2 char             ! a temporary
         integer*2 out                ! output
         equivalence(out, char)
         logical computer_word_order  ! function

         out = 0
         IF (computer_word_order()) THEN
            char(2:2) = input
         ELSE
            char(1:1) = input
         ENDIF
         toint = out
         RETURN
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Returns the integer value as a 4-byte integer.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION toint4(input)

         IMPLICIT NONE
         character*1 input
         character*4 char
         integer*4 out
         equivalence(out, char)
         logical computer_word_order ! function

         out = 0
         IF (computer_word_order()) THEN
            char(4:4) = input
         ELSE
            char(1:1) = input
         ENDIF
         toint4 = out
         RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     swaps a word of 2 bytes
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*2 FUNCTION swap_2byte(i2j)

           integer*2 i2j,i2
           character*1 i1(2),k
           equivalence (i1(1),i2)

           i2 = i2j
           k = i1(1)
           i1(1) = i1(2)
           i1(2) = k
           swap_2byte = i2
           RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     swaps a word of 4 bytes
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION swap_4byte(i2j)

           integer*4 i2j,i4
           character*1 i1(4),k,l
           equivalence (i1(1),i4)

           i4 = i2j
           k = i1(1)
           l = i1(2)
           i1(1) = i1(4)
           i1(2) = i1(3)
           i1(3) = l
           i1(4) = k
           swap_4byte = i4
           RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     defines the byte order of the computer
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      logical FUNCTION computer_word_order()

         LOGICAL LITTLE_ENDIAN, BIG_ENDIAN
         PARAMETER(LITTLE_ENDIAN = .FALSE.)
         PARAMETER(BIG_ENDIAN = .TRUE.)
         integer*4 int     ! an integer to test the byte order
         character*4 char  ! an equivalence to allow putting bytes into "int"
         equivalence(int, char)

         integer*4 pillar  ! the value "int" will have in a big endian
         data pillar /Z'31323334'/

         char(1:1) = '1'
         char(2:2) = '2'
         char(3:3) = '3'
         char(4:4) = '4'

         IF (int .EQ. pillar) THEN
            computer_word_order = BIG_ENDIAN
         ELSE
            computer_word_order = LITTLE_ENDIAN
         ENDIF

         RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculates sample rate from data record
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      REAL*4 FUNCTION calculate_sample_rate(factor, multiplier)

         IMPLICIT NONE
         integer*2 factor, multiplier ! inputs
         REAL*4 rate ! output

c         WRITE(*,*) factor, multiplier

         IF (factor .LT. 0) THEN 
            rate = -1.00/factor
         ELSE
            rate = 1.00*factor
         ENDIF
         IF (multiplier .LT. 0) THEN
            rate = - rate / multiplier
         ELSE
            rate = rate * multiplier
         ENDIF

         calculate_sample_rate = rate
         RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads numbers from input as 32 bit integers, and puts them in output.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE read_32bit(input, output, nsamp)

         IMPLICIT NONE

         integer*4 input(*)   ! input data
         integer*4 output(*)  ! output data
         integer*2 nsamp      ! number of samples

         integer*2 i ! loop counter

         DO i = 1, nsamp
            output(i) = input(i)
         ENDDO

      END



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads the input that is compressed with steim 1, and put the 
c decompressed samples in "output".
c
c The size of "output" is set on the calling routine. But it must be big
c enough to hold "nsamp" samples.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION read_steim1 (input, output, nsamp)

         IMPLICIT NONE

         integer*4 FRAME_SIZE
         PARAMETER (FRAME_SIZE = 16)

         integer*4 input(*)     ! input (compressed) samples
         integer*2 nsamp        ! # of samples informed in header
         integer*4 output(*)    ! output (decompressed) samples

         integer*4 i, j         ! loop counters
         integer*4 ic8, ic16    ! auxiliary functions

         integer*4 n            ! # of samples decompressed
         integer*4 integr       ! integrity check
         integer*4 rev_integr   ! reverse integrity check
         integer*4 w0           ! first word of frame, with the nibles
         integer*4 nible        ! nible referencing current word

         integer*4 word         ! current word

         integr = input(2)
         rev_integr = input(3)
c         WRITE (*,*) 'INTEGR: ', integr, rev_integr, nsamp

         n = 1
         output(1) = integr

c        for each frame of 16 words
         i = 0
         DO WHILE ((n .LT. nsamp))

c           w0 holds all the nibles of the frame
            w0 = input(i*FRAME_SIZE + 1)
            j = 1

c           for each word in the frame
            DO WHILE ((n .LT. nsamp) .AND. (j .LE. FRAME_SIZE))
c               WRITE(*,"('Frame Header ', Z8, I3, I3)") w0, i, j
c              get the corresponding nible
               nible = ibits(w0, 2*(FRAME_SIZE - j), 2)
               word = input(i*FRAME_SIZE + j)
c               WRITE(*,"(I3, ' ', Z8)") nible, word

c              4 samples in the word
               IF (nible .EQ. 1) THEN

c                 This ignores the very first difference of the record
c                 because it is taken in reference to the last sample
c                 of the previous one, and different Mini-SEED
c                 generators disagree in the interpretation of this
c                 value when the record is the first one
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                     output(n+1) = output(n)+ ic8(ibits(word, 24, 8))
                     n = n + 1
                  ENDIF
                  output(n+1) = output(n) + ic8(ibits(word, 16, 8))
                  output(n+2) = output(n+1) + ic8(ibits(word, 8, 8))
                  output(n+3) = output(n+2) + ic8(ibits(word, 0, 8))
                  n = n+3

c              2 samples in the word
               ELSEIF (nible .EQ. 2) THEN

c                 Ignoring the very first difference of the record
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                     output(n+1) = output(n) + ic16(ibits(word, 16, 16))
                     n = n+1
                  ENDIF
                  output(n+1) = output(n) + ic16(ibits(word, 0, 16))
                  n = n+1

c              1 sample in the word
               ELSEIF (nible .EQ. 3) THEN
                     IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                        output(n+1) = output(n) + word 
                        n = n+1
                     ENDIF
               ENDIF

               j = j + 1
            ENDDO
            i = i + 1
         ENDDO

c         WRITE(*,*) output(n-1), output(n)
c        checking the integrity constants
         read_steim1 = .TRUE.
         IF (n .NE. nsamp) THEN
            WRITE (*,*) 'Number of samples (',n,') does not ',
     &           'agree with header (',nsamp,').' 
         ENDIF
         IF (output(1) .NE. integr) THEN
            WRITE(*,
     &    "('first sample ',i9, ' does not agree with '
     &    'integrity constant ',i9)") output(1), integr
         ENDIF
         IF (output(n) .NE. rev_integr) THEN
            WRITE(*,
     &    "('last sample ',i9, ' does not agree with reverse'
     &    ' integrity constant ',i9)") output(n), rev_integr
            read_steim1 = .FALSE.
         ENDIF
         RETURN
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Decompress Nanometrics Steim1 file
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE read_nanometrics (input, output, nsamp, is_swapped)

         IMPLICIT NONE

         integer*4 FRAME_SIZE
         PARAMETER (FRAME_SIZE = 16)

         integer*4 input(*)     ! input (compressed) samples
         integer*2 nsamp        ! # of samples informed in header
         integer*4 output(*)    ! output (decompressed) samples
         logical is_swapped   ! if the file is swapped

         integer*4 i, j         ! loop counters
         integer*4 ic8          ! auxiliary functions
         integer*4 toint4       ! auxiliary function
         integer*2 swap_2byte   ! auxiliary function
         integer*4 swap_4byte   ! auxiliary function

         integer*4 n            ! # of samples decompressed
         integer*4 integr       ! integrity check
         integer*4 rev_integr   ! reverse integrity check
         integer*4 w0           ! first word of frame, with the nibles
         integer*4 nible        ! nible referencing current word
         
         integer*4 word, word1  ! current word
         character*1 c_word(4)  ! auxiliary variable
         integer*2   h_word(2)  ! auxiliary variable
         equivalence(word1, h_word)
         equivalence(word, c_word)

         integr = input(2)
         rev_integr = input(3)

         IF (is_swapped) THEN
            integr = swap_4byte(integr)
            rev_integr = swap_4byte(rev_integr)
         ENDIF

c         WRITE (*,*) 'INTEGR: ', integr, rev_integr, nsamp

         n = 1
         output(1) = integr

c        for each frame of 16 words
         i = 0
         DO WHILE ((n .LT. nsamp))

c           w0 holds all the nibles of the frame
            w0 = input(i*FRAME_SIZE + 1)

            IF (is_swapped) THEN
               w0 = swap_4byte(w0)
            ENDIF
            j = 1

c           for each word in the frame
            DO WHILE ((n .LT. nsamp) .AND. (j .LE. FRAME_SIZE))
c               WRITE(*,"('Frame Header ', Z8, I3, I3)") w0, i, j
c              get the corresponding nible
               nible = ibits(w0, 2*(FRAME_SIZE - j), 2)
               word = input(i*FRAME_SIZE + j)
c               WRITE(*,"(I3, ' ', Z8)") nible, word

c              4 samples in the word
               IF (nible .EQ. 1) THEN

c                 This ignores the very first difference of the record
c                 because it is taken in reference to the last sample
c                 of the previous one, and different Mini-SEED
c                 generators disagree in the interpretation of this
c                 value when the record is the first one
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                     output(n+1) = output(n)+ ic8(toint4(c_word(1)))
                     n = n + 1
                  ENDIF
                  output(n+1) = output(n) + ic8(toint4(c_word(2)))
                  output(n+2) = output(n+1) + ic8(toint4(c_word(3)))
                  output(n+3) = output(n+2) + ic8(toint4(c_word(4)))
                  n = n+3

c              2 samples in the word
               ELSEIF (nible .EQ. 2) THEN
c     "word" was already equivalenced to something else, so, in order
c     to get the half words and swap them, we had to copy it to word1.
                  word1 = word
                  IF (is_swapped) THEN
                     h_word(1) = swap_2byte(h_word(1))
                     h_word(2) = swap_2byte(h_word(2))
                  ENDIF
c                 Ignoring the very first difference of the record
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                     output(n+1) = output(n) + h_word(1)
                     n = n+1
                  ENDIF
                  output(n+1) = output(n) + h_word(2)
                  n = n+1

c              1 sample in the word
               ELSEIF (nible .EQ. 3) THEN
                  IF (is_swapped) THEN
                     word = swap_4byte(word)
                  ENDIF
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                     output(n+1) = output(n) + word 
                     n = n+1
                  ENDIF
               ENDIF

               j = j + 1
            ENDDO
            i = i + 1
         ENDDO

c         WRITE(*,*) output(n-1), output(n)
c        checking the integrity constants
         IF (n .NE. nsamp) THEN
            WRITE (*,*) 'Number of samples (',n,') does not ',
     &           'agree with header (',nsamp,').' 
         ENDIF
         IF (output(1) .NE. integr) THEN
            WRITE(*,
     &    "('first sample ',i9, ' does not agree with '
     &    'integrity constant ',i9)") output(1), integr
         ENDIF
         IF (output(n) .NE. rev_integr) THEN
            WRITE(*,
     &    "('last sample ',i5, ' does not agree with reverse'
     &    ' integrity constant ',i5)") output(n), rev_integr
         ENDIF

      END



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Reads the input that is compressed with steim 2, and put the 
c decompressed samples in "output".
c
c The size of "output" is set on the calling routine. But it must be big
c enough to hold "nsamp" samples.
c
c This algorithom is very similar to the Steim 1, so repeated comments
c will be ommited.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE read_steim2 (input, output, nsamp)

         IMPLICIT NONE

         integer*4 FRAME_SIZE
         PARAMETER (FRAME_SIZE = 16)

         integer*4 input(*)! where compressed samples are
         integer*2 nsamp   ! # of samples on input
         integer*4 output(*) ! where decompressed samples should be put

         integer*4 integr     ! integrity check
         integer*4 rev_integr ! reverse integrity check

         integer*4 i, j ! loop counters
         integer*4 ic8  ! auxiliary functions

         integer*4 n     ! number of decompressed samples
         integer*4 w0    ! first word of the frame (the nibles)
         integer*4 word  ! current word being decompressed
         integer*4 nible ! nible referencing current word

         integr = input(2)
         rev_integr = input(3)
c         WRITE(*,*) integr, rev_integr, nsamp

         n = 1
         output(1) = integr

         i = 0
         DO WHILE ((n .LT. nsamp))
            
            w0 = input(i*FRAME_SIZE + 1)
c            WRITE(*,*) ' '
c            WRITE(*,'(Z8)') w0
            j = 1
            
            DO WHILE ((n .LT. nsamp) .AND. (j .LE. FRAME_SIZE))

               nible = ibits(w0, 2*(FRAME_SIZE - j), 2)
               word = input(i*FRAME_SIZE + j)
c               WRITE(*,'(Z8, Z10)') nible, word

c              exactly like in Steim 1
               IF (nible .EQ. 1) THEN
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                     output(n+1) = output(n)+ ic8(ibits(word, 24, 8))
                     n = n + 1
                  ENDIF
                  output(n+1) = output(n) + ic8(ibits(word, 16, 8))
                  output(n+2) = output(n+1) + ic8(ibits(word, 8, 8))
                  output(n+3) = output(n+2) + ic8(ibits(word, 0, 8))
                  n = n+3

c              1, 2 or 3 samples
               ELSEIF (nible .EQ. 2) THEN
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                    CALL decode_steim2_nible2(word, output, n, .TRUE.)
                  ELSE
                    CALL decode_steim2_nible2(word, output, n, .FALSE.)
                  ENDIF
                  
c              5, 6 or 7 samples
               ELSEIF (nible .EQ. 3) THEN
                  IF ((i .NE. 0) .OR. (j .NE. 4)) THEN
                    CALL decode_steim2_nible3(word, output, n, .TRUE.)
                  ELSE
                    CALL decode_steim2_nible3(word, output, n, .FALSE.)
                  ENDIF

               ENDIF

               j = j + 1
            ENDDO
            i = i + 1
         ENDDO
c        checking the integrity constants
         IF (n .NE. nsamp) THEN
            WRITE (*,*) 'Number of samples (',n,') does not ',
     &           'agree with header (',nsamp,').' 
         ENDIF
         IF (output(1) .NE. integr) THEN
            WRITE(*,
     &    "('first sample ',i9, ' does not agree with '
     &    'integrity constant ',i9)") output(1), integr
         ENDIF
         IF (output(n) .NE. rev_integr) THEN
            WRITE(*,
     &    "('last sample ',i9, ' does not agree with reverse'
     &    ' integrity constant ',i9)") output(n), rev_integr
         ENDIF
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c decodes word steim2 compressed, when nible is 2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE decode_steim2_nible2(word, output, n, isNotFirst)

         IMPLICIT NONE

         integer*4 word     ! current word
         integer*4 output(*)! place where decompressed samples should be placed
         integer*4 n        ! last position of the output that has a value
         logical isNotFirst ! is first word of the record
         integer*4 dnib ! extra nible in steim 2 (last 2 bytes of each word)

         integer*4 ic30, ic15, ic10 ! auxiliary functions

         dnib = ibits(word, 30, 2)
                  
c        1 sample
         IF (dnib .EQ. 1) THEN
            IF (isNotFirst) THEN
               output(n+1) = output(n) + ic30(ibits(word, 0, 30))
               n = n + 1
            ENDIF

c        2 samples
         ELSEIF (dnib .EQ. 2) THEN
            IF (isNotFirst) THEN
               output(n+1) = output(n) + ic15(ibits(word, 15, 15))
               n = n + 1
            ENDIF
            output(n+1) = output(n) + ic15(ibits(word, 0, 15))
            n = n + 1

c        3 samples
         ELSEIF (dnib .EQ. 3) THEN
            IF (isNotFirst) THEN
               output(n+1) = output(n) + ic10(ibits(word, 20, 10))
               n = n + 1
            ENDIF
            output(n+1) = output(n) + ic10(ibits(word, 10, 10))
            output(n+2) = output(n+1) + ic10(ibits(word, 0, 10))
            n = n + 2

         ELSE
            WRITE (*,*) 'ERROR decompressing Steim2!'
            STOP
         ENDIF
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c decompresses word steim2 compressed, when nible is equal to 3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE decode_steim2_nible3(word, output, n, isNotFirst)

         IMPLICIT NONE

         integer*4 word     ! current word
         integer*4 output(*)! place where decompressed samples should be placed
         integer*4 n        ! last position of the output that has a value
         logical isNotFirst ! check if is not first word of the record
         integer*4 dnib ! extra nible in steim 2 (last 2 bytes of each word)

         integer*4 ic6, ic5, ic4 ! auxiliary functions
         integer*4 i ! loop counter

         dnib = ibits(word, 30, 2)

c        5 samples
         IF (dnib .EQ. 0) THEN
            IF (isNotFirst) THEN
               output(n+1) = output(n) + ic6(ibits(word, 24, 6))
               n = n + 1
            ENDIF
            DO i = 1, 4
               output(n+1) = output(n) + ic6(ibits(word, 6*(4-i), 6))
               n = n + 1
            ENDDO 

c        6 samples
         ELSEIF (dnib .EQ. 1) THEN
            IF (isNotFirst) THEN
               output(n+1) = output(n) + ic5(ibits(word, 25, 5))
               n = n + 1
            ENDIF
            DO i = 1, 5
               output(n+1) = output(n) + ic5(ibits(word, 5*(5-i), 5))
               n = n + 1
            ENDDO

c        7 samples
         ELSEIF (dnib .EQ. 2) THEN
            IF (isNotFirst) THEN
               output(n+1) = output(n) + ic4(ibits(word, 24, 4))
               n = n + 1
            ENDIF
            DO i = 1, 6
               output(n+1) = output(n) + ic4(ibits(word, 4*(6-i),4))
               n = n + 1
            ENDDO

         ELSE
            WRITE(*,*) 'ERROR decompressing Steim2!'
            STOP
         ENDIF

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Swaps bytes of all integers in input
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE swap_buffer(input, size)
         
        IMPLICIT NONE
        integer*4 input(*)   ! array of integers
        integer size         ! number of elements in input
        integer i            ! loop counter
        integer*4 swap_4byte ! function

        DO i = 1, size
          input(i) = swap_4byte(input(i))
        ENDDO
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 4th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic4(iarg)
         data mask/z'fffffff0'/
         ic4=iarg
         if(btest(iarg,3))ic4=or(iarg,mask)
         return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 5th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic5(iarg)
         data mask/z'ffffffe0'/
         ic5=iarg
         if(btest(iarg,4))ic5=or(iarg,mask)
         return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 6th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic6(iarg)
         data mask/z'ffffffc0'/
         ic6=iarg
         if(btest(iarg,5))ic6=or(iarg,mask)
         return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 8th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic8(iarg)
         data mask/z'ffffff00'/
         ic8=iarg
         if(btest(iarg,7))ic8=or(iarg,mask)
         return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 10th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic10(iarg)

         data mask/z'fffffc00'/
         ic10=iarg
         if(btest(iarg,9))ic10=or(iarg,mask)
         return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 15th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic15(iarg)

         data mask/z'ffff8000'/
         ic15=iarg
         if(btest(iarg,14))ic15=or(iarg,mask)
         return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 16th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic16(iarg)
c
c     pads with 1's word "ic16" if its rightmost 2-byte half
c     has a 1 as most significant bit (this because
c     bytes 0,1 have to be interpreted as a signed number)
c
      data mask/z'ffff0000'/
      ic16=iarg
      if(btest(iarg,15))ic16=or(iarg,mask)
      return
      end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c If 30th bit of iarg is "1", pads with 1 more significant bits.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      integer*4 FUNCTION ic30(iarg)

         data mask/z'c0000000'/
         ic30=iarg
         if(btest(iarg,29))ic30=or(iarg,mask)
         return
      end



cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Converts a string to uppercase
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE upper_s(str)

         IMPLICIT NONE

         character*50 str      ! string to be converted
         character*1 uppercase ! auxiliary function
         integer*4   i         ! loop counter
         
         DO i = 1, LEN(str)
            str(i:i) = uppercase(str(i:i))
         ENDDO

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c convert lower case single char to upper case - machine independent
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      CHARACTER*1 FUNCTION uppercase(a)

         character*1 chr(26),ucchr(26),a
         data chr/'a','b','c','d','e','f','g','h','i','j','k','l','m',
     &     'n','o','p','q','r','s','t','u','v','w','x','y','z'/
         data ucchr/'A','B','C','D','E','F','G','H','I','J','K','L','M',
     &     'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'/
         do i=1,26
            if(a.eq.chr(i))then
              uppercase=ucchr(i)
              return
            endif
         end do 
         uppercase=a
         return
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Routine to convert from date to day-of-year
c j. havskov 1992 and Leif Kvamme 12-1-85
c corrected leap year definition 15/12/04
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       INTEGER*2 FUNCTION get_doy (DAY,MON,YR)
  
          implicit none
          integer*4 DAY,MON,YR,MTH(12),J
          logical*1 isleap

          integer*2 year

          year = YR

          DO J = 1,7,2
             MTH(j) = 31
          ENDDO
          DO J = 8,12,2
             MTH(J) = 31
          ENDDO
          MTH(2) = 28
          MTH(4) = 30
          MTH(6) = 30
          MTH(9) = 30
          MTH(11)= 30
          IF (isleap(year)) MTH(2) = 29
          
          get_doy=0
          DO j=1,mon-1
             get_doy=get_doy+mth(j)
          ENDDO
          get_doy=get_doy+day
          
          RETURN
       END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Converts day of year to day, month
c j. havskov 1992 and Leif Kvamme 12-1-85  
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       SUBROUTINE get_day_month (DAY,MON,DOY,YR)
                   
       implicit none
       integer*2 DOY,DAY,MON,YR,MTH(12),J,M,N

       do 1 J = 1,7,2
           MTH(J) = 31
    1  continue

       do 2 J = 8,12,2
           MTH(J) = 31
    2  continue

       MTH(2) = 28
       MTH(4) = 30
       MTH(6) = 30
       MTH(9) = 30
       MTH(11)= 30
       if (mod(YR,4) .eq. 0) MTH(2) = 29
       M = 0
       do 3 J = 1,12
       M = M + MTH(J)
       N = DOY - M
       if (N .le. 0) then
           MON = J
           DAY = N + MTH(J)
           goto 4
       endif
    3  continue
    4  return
       end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Routine to convert from time to seconds after 1.1 1900, 00:00:00.00
c                                                  Leif Kvamme 9-4-87
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       REAL*8 FUNCTION time_to_sec (YEAR,MTH,DAY,HR,MIN,SECS)

          implicit none
c--   Total seconds to be returned   
          double precision MSECS ! REAL*8                 
c--                                                  
c--   Input date                     
          integer*2 YR,YEAR,MTH,DAY,HR,MIN,SECS      
c--   Flag for leap-year             
          integer          DYR                    
c--   Number of leap-years since 1900
          integer          IYR                    
c--   Number of days in current year 
          integer          YDY                    
*                                    
          yr=year                                           
          if (YEAR .ge. 1900) YR = YEAR - 1900
          DYR = 0
          if (mod(YR,4) .eq. 0) DYR = 1
          IYR = YR/4 - DYR
c--   Seconds to beginning of     
          MSECS = real(IYR*366) + real((YR-IYR)*365)
c--   current year
          MSECS = MSECS*86400.0
c--   January
          if (MTH .eq. 1) YDY = DAY
c--   February
          if (MTH .eq. 2) YDY = DAY + 31             
c--   ....
          if (MTH .eq. 3) YDY = DAY + DYR + 59
          if (MTH .eq. 4) YDY = DAY + DYR + 90
          if (MTH .eq. 5) YDY = DAY + DYR + 120                 
          if (MTH .eq. 6) YDY = DAY + DYR + 151                  
          if (MTH .eq. 7) YDY = DAY + DYR + 181                  
          if (MTH .eq. 8) YDY = DAY + DYR + 212
          if (MTH .eq. 9) YDY = DAY + DYR + 243
          if (MTH .eq.10) YDY = DAY + DYR + 273
          if (MTH .eq.11) YDY = DAY + DYR + 304
          if (MTH .eq.12) YDY = DAY + DYR + 334
          MSECS = MSECS + real(YDY*86400 + HR*3600 + MIN*60) + SECS
          time_to_sec = MSECS
          RETURN
       END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Opens the file, with the desirable block size.
c It checks if the block size is valid, and returns .TRUE. only if
c the file is open.
c
c Parameters:
c - filenumber: file number
c - filename:   file name
c - length:     (the exponent in the power of 2) of the block length
c
c Return: .TRUE. in case of success
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION open_file(filenumber, filename, length)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 filenumber   ! file number
         character*80 filename  ! name of the file
         integer length       ! length as a power of 2

         open_file = .FALSE.
         BLK_SIZE = 2**length
         IF (BLK_SIZE .LT. 256) RETURN
         IF (BLK_SIZE .GT. MAX_BLK_SIZE) RETURN
         OPEN(filenumber, file = filename, RECL=BLK_SIZE, 
     &        ACCESS='DIRECT', STATUS='UNKNOWN')
         length_ = length
         open_file = .TRUE.
         RETURN
        
      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Writes buffer related to channel (in common block) to file.
c
c Parameters:
c - file: file number
c - buf:  buffer with the samples
c - n_blocks: (input/output) number of the (start) block in the file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE seed_write_chn(file, buf, n_blocks)

         IMPLICIT NONE
         INCLUDE 'write_mseed.inc.f'
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 file         ! output file
         integer*4 buf(*)       ! buffer with input data
         integer*4 n_blocks     ! counter of blocks on file

         integer*4 comp         ! number of samples already compressed
         integer*4 seq          ! sequence number for current channel
         integer*2 factor, multiplier ! sample rate components
         integer*4 last         ! last sample of decompressed sample

         logical*1 calc_rate  ! auxiliary function
         integer*2 get_doy
         logical computer_word_order  ! function

c
c jh   find which platform
c
         seed_pc=.true.       ! default is pc-linux
         if (computer_word_order()) seed_pc=.false.         
c
c jh   set if writing little endian or big endian
c
         force_len=.false.     ! write big endian

         seq = 1
         comp = 0
         last = 0
c         BLK_SIZE = 4096

         year = mseed_year
         doy = get_doy(mseed_day, mseed_month, mseed_year)
         hour = mseed_hour
         minute = mseed_minute
         second = mseed_second
         fracsec = (mseed_second - second)*10000
         encoding = mseed_encoding

         DO WHILE (comp .LT. mseed_total_samples)
            CALL clean_seed_record
            WRITE(seq_number,'(i6.6)') seq
            CALL fill_header
c
c     trying to set sample rate parameters. If there is lost in precision
c     then use blockette 100
c
            IF (.NOT. calc_rate(factor, multiplier, mseed_sample_rate)) 
     &           THEN
               CALL make_blk_100()
            ENDIF
            sample_rate_factor = factor
            sample_rate_multiplier = multiplier
c            WRITE(*,*) 'debug'
            CALL encode(buf(comp+1), mseed_total_samples - comp, last)
            comp = comp + n_samples
c            WRITE(*,*) 'Number of samples', comp, n_samples
c
c   swap if desired, that is writing litte endian on sun or
c   big endian on pc
c
            if((.not.seed_pc.and.force_len).or.
     *         (seed_pc.and..not.force_len)) 
     *         call seed_swap_output_header()
c 
            WRITE(file, REC=n_blocks) seed_record(1:BLK_SIZE)
c
c   swap back since some variables might be used again
c
            if((.not.seed_pc.and.force_len).or.
     *         (seed_pc.and..not.force_len)) 
     *         call seed_swap_output_header()
c 

            n_blocks = n_blocks + 1

            seq = seq + 1

            CALL update_time(n_samples)

        ENDDO
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Encodes data.
c Updates encoding_ field (in blockette 1000).
c Sets n_samples field (in fixed header).
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE encode(buf, n_rem, last)

         IMPLICIT NONE
         INCLUDE 'write_mseed.inc.f'
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 buf(*)       ! input (uncompressed) data
         integer*4 n_rem        ! number of remaining data
         integer*4 last         ! last sample of previous data record
         integer*2 n_frames     ! number of frames

         integer*4 write_steim1 ! auxiliary function
         integer*4 write_32bit  ! auxiliary function
         character*1 tochar     ! auxiliary function
         integer*4      output(1024)
         character*4096 c_output
         equivalence (output, c_output)

         CALL clean_array(output, BLK_SIZE/4)

         n_frames = (BLK_SIZE - data_p) / (FRAMESIZE*4)
c         WRITE(*,*) 'debug encode'
         IF (encoding .EQ. INT_32BIT) THEN
            n_samples = write_32bit(output, n_frames*FRAMESIZE, 
     &           buf, n_rem)
         ELSEIF (encoding .EQ. STEIM1) THEN
            n_samples = write_steim1(output, n_frames, 
     &           buf, n_rem, last)
         ELSE
            WRITE(*,*) 'ERROR - unknown format code, so using Steim1.'
            encoding = STEIM1
            n_samples = write_steim1(output, n_frames,
     &           buf, n_rem, last)
         ENDIF
c
         if((.not.seed_pc.and.force_len).or.
     *      (seed_pc.and..not.force_len)) then 
           call swap_buffer(output,blk_size/4)
         endif
c
         encoding_ = tochar(encoding)
         seed_record(data_p+1:BLK_SIZE) = c_output(1:BLK_SIZE - data_p)
c         WRITE(*,'(Z8, Z8, Z8)') output(1), output(2), output(3)

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Writes data as 32-bit integers
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION write_32bit(output, limit, input, n_samp)

         IMPLICIT NONE

         integer*4 output(*)    ! output buffer
         integer*4 input(*)     ! input buffer
         integer*4 limit        ! max number of samples in the block
         integer*4 n_samp       ! number of samples in input

         integer*4 i            ! loop counter

         i = 1
         DO WHILE ((i .LE. limit) .AND. i .LE. n_samp)
            output(i) = input(i)
            i = i + 1
         ENDDO
         write_32bit = i - 1
         RETURN
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Compresses data from input with steim1 algorithm and puts it in output.
c Returns the number of samples actually compressed.
c
c It works as a DFA. The input is the difference between 2 samples. Depending
c on whether this difference needs 1, 2 or 4 bytes to be represented, we
c choose the next state.
c
c The buffer "diff" holds differences that have been calculated, but it still
c has not been decided how they will be compressed (4 1-byte, 2 2-byte or
c 1 4-byte).
c
c Each state has a particular condition of the "diff" buffer. State 0 is the
c start state. It has no samples. States 4, 22 and 1111 are final. This means
c they will compress the data and put it on output.
c State 4 writes 1 4-byte difference. State 22 writes 2 2-bytes differences.
c State 1111 writes 4 1-byte differences.
c
c State 999 checks if the frame is full. So it follows the final states.
c
c     state      diff    # bytes  next_state    add
c               buffer  of input                  n
c         0          0         1          10     +1
c         0          0         2          20     +1
c         0          0         4           4     +1
c        10   1 1-byte         1         110     +1
c        10   1 1-byte         2          22     +1
c        10   1 1-byte         4           4      0
c        20  1 2-bytes         2          22     +1
c        20  1 2-bytes         4           4      0
c       110   2 1-byte         1        1110     +1
c       110   2 1-byte         4          22      0
c      1110   3 1-byte         1        1111     +1
c      1110   3 1-byte         4          22     -1
c         4   1 4-byte         -         999      0
c        22  2 2-bytes         -         999      0
c      1111  4 1-bytes         -         999      0
c       999          0         -           0      0

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION write_steim1(output,n_frames,input,n_samp,last)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 output(*)    ! compressed data
         integer*4 input(*)     ! uncompressed data
         integer*2 n_frames     ! max number of frames that fit
         integer*4 n_samp       ! number of uncompressed samples
         integer*4 last         ! value of last sample put on output


         f_count = 0
         f_pos = 4      ! 1st frame starts on 4th. The others start on 2nd.
         w0 = 0
         state = 0
         n = 0
         output(2) = input(1)   ! integrity constant
c         WRITE(*,*) 'debug steim1'

         DO WHILE ((f_count .LT. n_frames) .AND. (n .LT. n_samp))

            IF (state .EQ. 0) THEN
               CALL state_0(output, input(n+1)-last)

            ELSEIF (state .EQ. 10) THEN
               CALL state_10(output, input(n+1) - input(n))

            ELSEIF (state .EQ. 20) THEN
               CALL state_20(output, input(n+1) - input(n))

            ELSEIF (state .EQ. 110) THEN
               CALL state_110(output, input(n+1) - input(n))

            ELSEIF (state .EQ. 1110) THEN
               CALL state_1110(output, input(n+1) - input(n))

            ELSE
               WRITE(*,*) 'ERROR in algorithm! DFA is wrong!'
            ENDIF
            last = input(n)
         ENDDO

c     If the previous loop ended for the condition (n < n_samp)
c     than we might have samples that were put on the limbo,
c     but were not yet been put on output, because no final
c     stage was reached for them. In these cases, we have to
c     do the following:

c     if there is one sample left...
c     We can treat it as one 4-byte difference
         IF ((state .EQ. 10) .OR. (state .EQ. 20)) THEN
            CALL state_4(output)

c     if there are 2 samples left
c     We can treat them as 2 2-bytes differences.
         ELSEIF (state .EQ. 110) THEN
            CALL state_22(output)

c     if there are 3 samples left...
c     In this case, we have space for 2, putting them as 2-byte differences.
c     But it is not garanteed that there is space for one more word, so
c     we have to check that...
         ELSEIF (state .EQ. 1110) THEN
            CALL state_22(output)
c     if we have space for the last sample, we put it as a 4-byte difference,
c     but if not, we undo it, and tell the calling function that it will
c     need to write another data record...
            IF ((f_pos .LE. FRAMESIZE) 
     &           .OR. (f_count .LT. n_frames)) THEN
               diff(1) = diff(3)
               CALL state_4(output)
            ELSE
               n = n - 1
            ENDIF
         ENDIF

         IF (f_count .LT. n_frames) THEN
            w0 = ISHFT(w0, 2*(16-f_pos+1))
c            WRITE(*,"('W0', Z8)") w0
            output(f_count*FRAMESIZE+1) = w0
         ENDIF
            

         last = input(n)
         output(3) = input(n)  ! reversal integrity constant
         write_steim1 = n      
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 0 of DFA.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_0(output, next_diff)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 next_diff    ! next difference
         integer*4 output(*)    ! place where to put next output

         logical*1 is_1byte, is_2byte ! auxiliary functions

         n = n+1
         diff(1) = next_diff
c         WRITE(*,*) 'debug state 0', diff(1)
         IF (is_1byte(diff(1))) THEN
c            WRITE(*,*) 'debug go to state 10'
            state = 10
         ELSEIF (is_2byte(diff(1))) THEN
c            WRITE(*,*) 'debug go to state 20'
            state = 20
         ELSE
c            WRITE(*,*) 'debug go to state 4'
            CALL state_4(output)
         ENDIF

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 4 of DFA. It is a final state.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_4 (output)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 output(*)    ! place to put next output

c         WRITE(*,*) 'debug state 4', diff(1)
         output(f_count*FRAMESIZE + f_pos) = diff(1)
         w0 = ISHFT(w0, 2) + 3
         CALL state_999(output)

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 22 of DFA. It is a final state.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_22 (output)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 output(*)    ! place to put the output
         integer*4 combine2     ! auxiliary function

c         WRITE(*,*) 'debug state 22', diff(1), diff(2)
c
cjh change, could have been done in combine2 routine instead
c
          if(force_len) then
            output(f_count*FRAMESIZE + f_pos) = 
     *      combine2(diff(2), diff(1))
          else
            output(f_count*FRAMESIZE + f_pos) = 
     *      combine2(diff(1), diff(2))
          endif
         w0 = ISHFT(w0, 2) + 2
         CALL state_999(output)
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 10 of DFA.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_10(output, next_diff)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 next_diff    ! next difference to queue
         integer*4 output(*)

         logical*1 is_1byte, is_2byte ! auxliary functions

         n = n + 1
         diff(2) = next_diff
c         WRITE(*,*) 'debug state 10', diff(2)
         IF (is_1byte(diff(2))) THEN
c            WRITE(*,*) 'debug go to state 110'
            state = 110
         ELSEIF (is_2byte(diff(2))) THEN
c            WRITE(*,*) 'debug go to state 22'
            CALL state_22(output)
         ELSE
c            WRITE(*,*) 'debug go to state 4'
            n = n - 1
            CALL state_4(output)
         ENDIF

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 20 of DFA
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_20(output, next_diff)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 next_diff    ! next difference to queue
         integer*4 output(*)    ! place to put next output

         logical*1 is_2byte     ! auxiliary function

c         WRITE(*,*) 'debug state 20'
         diff(2) = next_diff
         n = n + 1
         IF (is_2byte(diff(2))) THEN
c            WRITE(*,*) 'debug go to state 22'
            CALL state_22(output)
         ELSE
c            WRITE(*,*) 'debug go to state 4'
            n = n - 1
            CALL state_4(output)
         ENDIF
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 110 of DFA
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_110(output, next_diff)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 next_diff    ! next difference to queue
         integer*4 output(*)    ! place to put next output

         logical*1 is_1byte     ! auxiliary function

         diff(3) = next_diff
         n = n + 1
c         WRITE(*,*) 'debug state 110', diff(3)
         IF (is_1byte(diff(3))) THEN
c            WRITE(*,*) 'debug go to state 1110'
            state = 1110
         ELSE
            n = n - 1
            CALL state_22(output)
         ENDIF
      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 1110 of DFA
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_1110(output, next_diff)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 next_diff    ! next difference to queue
         integer*4 output(*)    ! place to put next output

         logical*1 is_1byte     ! auxiliary function

         diff(4) = next_diff
         n = n + 1
c         WRITE(*,*) 'debug state 1110', diff(4)
         IF (is_1byte(diff(4))) THEN
c            WRITE(*,*) 'debug go to state 1111'
            CALL state_1111(output)
         ELSE
            n = n - 2
            CALL state_22(output)
         ENDIF
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c State 1111 of DFA. It is a final state.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_1111(output)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 output(*)       ! place to put the next output
         integer*4 combine4     ! auxiliary function

c         WRITE(*,*) 'debug state 1111', diff(1), diff(2), 
c     &        diff(3), diff(4)
         output(f_count*FRAMESIZE + f_pos) = combine4(diff)
         w0 = ISHFT(w0, 2) + 1
         CALL state_999(output)
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE state_999(output)

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         integer*4 output(*)

         f_pos = f_pos + 1
c         WRITE(*,*) 'debug state 999', f_count, f_pos
         IF (f_pos .GT. FRAMESIZE) THEN
            output(f_count*FRAMESIZE+1) = w0
            w0 = 0
            f_pos = 2
            f_count = f_count+1
c            WRITE(*,*) 'End of frame'
         ENDIF
         state = 0
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Puts 2 words (the first 16 bits of each) together, in a 32 bit integer.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION combine2(int1, int2)

         IMPLICIT NONE
         integer*4 int1, int2   ! input

         combine2 = ISHFT(ibits(int1,0,16), 16) + ibits(int2, 0, 16)

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Puts 4 words (the first 8 bits of each) together, in a 32 bit integer.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      INTEGER*4 FUNCTION combine4(int)
         implicit none
         INCLUDE 'write_mseed_internal.inc.f'    ! jh include
         integer*4 int(4)
         integer*4 temp
         

cjh add pc option

        if(force_len) then
            temp = ISHFT(ibits(int(4), 0, 8), 8) + 
     *             ibits(int(3), 0, 8)
            temp = ISHFT(temp, 8) + ibits(int(2), 0, 8)
            combine4 = ISHFT(temp, 8) + ibits(int(1), 0, 8)
         else
            temp = ISHFT(ibits(int(1), 0, 8), 8) + 
     *      ibits(int(2), 0, 8)
            temp = ISHFT(temp, 8) + ibits(int(3), 0, 8)
            combine4 = ISHFT(temp, 8) + ibits(int(4), 0, 8)
         endif

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Updates the start time of the next block, by adding
c samples / sample_rate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE update_time(samples)

         IMPLICIT NONE
         INCLUDE 'write_mseed.inc.f'
         INCLUDE 'write_mseed_internal.inc.f'

         integer*2 samples      ! number of samples
         integer*4 time_to_add  ! time to add in fractions of seconds
         logical*1 isleap       ! auxliliary function
c change jh ock 2005, change samples +1 to samples in next line
         time_to_add = ((samples) * 10000) / mseed_sample_rate
c         WRITE (*,*) 'debug ',time_to_add

         time_to_add = time_to_add + fracsec
         fracsec = MOD (time_to_add, 10000)
         time_to_add = time_to_add/10000 ! now time_to_add is in seconds
         time_to_add = time_to_add + second
         second = MOD(time_to_add, 60)
         time_to_add = time_to_add/60 ! now it is in minutes
         time_to_add = time_to_add + minute
         minute = MOD(time_to_add, 60)
         time_to_add = time_to_add/60 ! now it is in hours
         time_to_add = time_to_add + hour
         hour = MOD (time_to_add, 24)
         time_to_add = time_to_add/24 ! now it is in days
         doy = doy + time_to_add
         DO WHILE (doy .GT. 366)
            year = year + 1
            IF (isleap(year)) THEN 
               doy = doy - 366
            ELSE 
               doy = doy - 365
            ENDIF
         ENDDO
         IF ((.NOT. isleap(year)) 
     &        .AND. (doy .EQ. 366)) THEN
            doy = 1 
            year = year + 1
         ENDIF
c         WRITE(*,*) mseed_year, mseed_day_of_year, mseed_hour, 
c     &        mseed_minute, mseed_second, mseed_fracsec
      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Fill header.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE fill_header()

         IMPLICIT NONE
         INCLUDE 'write_mseed.inc.f'
         INCLUDE 'write_mseed_internal.inc.f'

         logical   computer_word_order ! auxiliary function
         character*1 tochar     ! auxiliary function
         integer*2   int        ! auxiliary variable


         header_type = 'D'
         continuation = ' '
         station_ = mseed_station
         location_ = mseed_location
         channel_ = mseed_channel
         network_ = mseed_network
         year_ = year
         day_of_year_ = doy
         hour_ = tochar(hour)
         minute_ = tochar(minute)
         second_ = tochar(second)
         fracsec_ = fracsec
         time_correction = 0
         int = 1
         n_blockettes = tochar(int)
         data_p = 64
         first_blk = 48
         blk_type_1000 = 1000
         next_1000 = 0
         rec_length = tochar(length_)


c     defining byte order is done with IF/THEN/ELSE instead using the values
c     of .TRUE. and .FALSE. because on Windows, the integer values of 
c     .TRUE. and .FALSE. are the opposite as in the other systems.
c     this will give byte order om system writing
c     since we now want to control byte order indpendent of system
c     this has been replace by a fixed byte order
c
         int = 1       ! assume default big endian
         if(force_len) int=0
         byte_order = tochar(int)
c
c        IF (computer_word_order()) THEN
cjh         int = 1
cjh         byte_order = tochar(int)
cjh      ELSE
cjh         int = 0
cjh         byte_order = tochar(int)
cjh      ENDIF

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Inserts blockette 100 in data record.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE make_blk_100()

         IMPLICIT NONE
         INCLUDE 'write_mseed.inc.f'
         INCLUDE 'write_mseed_internal.inc.f'

         integer*2   blk_type_100
         integer*2   next_100
         real*4      rate
         character*1 flags

         equivalence(seed_record(65:66), blk_type_100)
         equivalence(seed_record(67:68), next_100)
         equivalence(seed_record(69:72), rate)
         equivalence(seed_record(73:73), flags)

         integer*2 int          ! temp variable
         character*1 tochar     ! auxiliary function
         integer*2   toint      ! auxiliary function

         data_p = 128
         next_1000 = 64
         blk_type_100 = 100
         next_100 = 0
         int = toint(n_blockettes)+1
         n_blockettes = tochar(int)
         rate = mseed_sample_rate

      END


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Defines factor and multiplier, integers, from a real sample rate.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION calc_rate(factor, multiplier, rate)

         IMPLICIT NONE

         integer*2 factor       ! sample rate factor
         integer*2 multiplier   ! sample rate multiplier
         real*4    rate         ! sample rate
         integer*2 i            ! counter
         integer*2 exponent     ! exponent of sample rate
         integer*4 fraction     ! fraction part of sample rate

         integer*4 i_rate
         real*4    r_rate
         equivalence(i_rate, r_rate)

         real*4 calculate_sample_rate ! auxiliary function

         r_rate = rate
         fraction = ibits(i_rate, 0, 23)
         fraction = ibset(fraction, 23)

         i = 0
         DO WHILE (.NOT. BTEST(fraction, 0))
            fraction = ISHFT(fraction, -1)
            i = i + 1
         ENDDO

         exponent = ibits(i_rate,23,8) -127 - 23 + i

c     trying to adjust exponent
         IF (exponent .GT. 14) THEN
            fraction = ISHFT(fraction, exponent - 14)
            exponent = 14
         ELSEIF (exponent .LT. -15) THEN
            fraction = ISHFT(fraction, exponent + 15) ! loosing precision
            exponent = -15
         ENDIF

c     trying to adjust fraction, loosing precision
         DO WHILE (fraction .GT. (2**15) - 1)
            fraction = ISHFT(fraction, -1)
            exponent = exponent + 1
         ENDDO

         IF (exponent .GT. 14) THEN
            calc_rate = .FALSE.
            factor = 0
            multiplier = 0
            RETURN
         ENDIF

         factor = fraction
         IF (exponent .LT. 0) THEN
            multiplier = -2**(-exponent)
         ELSE
            multiplier = 2**exponent
         ENDIF

         calc_rate = (calculate_sample_rate(factor, multiplier)
     &        .EQ. rate)
         RETURN

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Cleans seed_record.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE clean_seed_record()

         IMPLICIT NONE
         INCLUDE 'write_mseed_internal.inc.f'

         character*4 char
         integer*4   int
         equivalence(int, char)

         integer*4 i

         int = 0

         DO i = 0, BLK_SIZE/4, 4
            seed_record(i+1:i+4) = char
         ENDDO

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Fills the array with zeros.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      SUBROUTINE clean_array(array, size)

         IMPLICIT NONE
         integer*4 i            ! counter
         integer*4 array(*)     ! array to be cleaned
         integer*4 size         ! size of array

         DO i = 1, size
            array(i) = 0
         ENDDO

      END

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Converts a 2-byte integer into a 1-byte character.
c The integer must be small enough to fit in 1-byte. There is no
c overflow check in this function.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      CHARACTER*1 FUNCTION tochar(int)

         IMPLICIT NONE

         integer*2 int, int2          ! integer to be converted
         character*2 char       ! equivalence char

         equivalence(int2, char)

         logical computer_word_order ! auxiliary function

         int2 = int
         IF (computer_word_order()) THEN
            tochar = char(2:2)
         ELSE
            tochar = char(1:1)
         ENDIF
         RETURN

      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Checks if input can be represented with 1 byte.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION is_1byte(int)

         IMPLICIT NONE

         integer*4 int

         is_1byte = ((int .LE. 127) .AND. (int .GE. -128))
         RETURN
      END


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Checks if input can be represented with 2 bytes.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION is_2byte(int)

         IMPLICIT NONE

         integer*4 int

         is_2byte = ((int .LE. 32767) .AND. (int .GE.-32768))
         RETURN
      END

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Returns if the year is a leap year (ie with 366 days)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      LOGICAL FUNCTION isleap(year)

         IMPLICIT NONE

         integer*2 year

         isleap = ((MOD(year, 100) .NE. 0) .AND. (MOD(year,4) .EQ. 0)) 
     &        .OR. (MOD(year, 400) .EQ. 0)
         RETURN
      END

