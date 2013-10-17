##################################################
#
# SEISAN 9.0
#
# February 2011
#
# Makefile for SEISAN LIB directory
#
# To use DISLIN on Linux 
#  do not use xlib.c 
#  put in xget_screen_size_unix.c
#  put in dislinplot.for
#  make a small change in seisplot.for, see file
#  get appropriate libraries etc from www.dislin.de
#
# changes:
#
#   ...
#   27 Jan 11 jh: rename seis_unix, seis_sub
#   29 Jan 11 lo: cleanup and windows gfortran
#   24 Jan 11 lo: changed names of systems
#   
#
##################################################

##################################################
# THE ARCHITECTURE IS EXPECTED TO BE GIVEN BY
# THE ENVIRONMENTAL VARIABLE SEISARCH, WHICH
# CAN BE: 
#
#    solaris 
#    g77
#    gfortran
#    macosx 
#    macosxppc
#    windows
#
##################################################

##################################################
# PATH TO WHICH OUTPUT FILES ARE WRIITEN,
# THIS CAN BE SET TO $(SEISARCH) IF 
# SEVERAL OPERATING SYSTEMS COMPILE 
# SOURCE ON SHARED DISKS,
# OBVIOUSLY OUTPATH CAN BE USED TO WRITE
# OBJECTS TO ANY OTHER PLACE
#################################################
# To compile under windows
# set OUTPATH to . and SEISARCH to windows
##################################################
#SEISARCH=windows

# OUTPATH = $(SEISARCH)
OUTPATH = .

##################################################
# COMPILERS AND FLAGS
fc_solaris = f77 -g -c -I../INC -o $@
fc_g77 = g77 -g -c -I../INC -fdollar-ok -fugly-complex -fno-automatic -finit-local-zero -o $@
fc_gfortran = gfortran -g -c -I../INC -fdollar-ok -fno-automatic -o $@
fc_macosx = gfortran -m64 -g -c -I../INC -fdollar-ok -fno-automatic -o $@
fc_macosxppc = gfortran -g -c -I../INC -fdollar-ok -fno-automatic -o $@
fc_windows = gfortran -g -c -I../INC -fdollar-ok -fno-automatic -o $@

cc_solaris = cc -c -I../INC -o $@
cc_gfortran = gcc -g -c -I../INC -o $@
cc_g77 = gcc -g -c -I../INC -o $@
cc_macosx = gcc -m64 -g -c -I../INC -I/usr/X11R6/include -o $@
cc_macosxppc = gcc -g -c -I../INC -I/usr/X11R6/include -o $@
cc_windows = gcc -g -c -I../INC -o $@
fc = $(fc_$(SEISARCH))
cc = $(cc_$(SEISARCH))

##################################################
# FILES SPECFIC TO PLATFORM
solaris_ONLY = $(OUTPATH)/comp_sun.o $(OUTPATH)/xlib.o
linux_ONLY = $(OUTPATH)/comp_linux.o $(OUTPATH)/xlib.o
gfortran_ONLY = $(OUTPATH)/comp_linux.o $(OUTPATH)/xlib.o
linux_ONLY = $(OUTPATH)/comp_linux.o $(OUTPATH)/xlib.o
macosx_ONLY = $(OUTPATH)/comp_linux.o $(OUTPATH)/xlib.o
macosxppc_ONLY = $(OUTPATH)/comp_sun.o $(OUTPATH)/xlib.o
windows_ONLY =  $(OUTPATH)/comp_pc.o $(OUTPATH)/dislinplot.o $(OUTPATH)/xget_screen_size_pc.o

PLATFORM_DEP_OBJ = $($(SEISARCH)_ONLY)

##################################################
# NAME OF ARCHIVE
archive = seisan.a

# not included hypinv2.for

#
# LIST OF OBJECTS THAT ARE COMMON ON ALL PLATFORMS
# AND THAT ARE PART OF THE ARCHIVE
#
SUBS = $(OUTPATH)/abstim.o $(OUTPATH)/auto_tr.o \
  $(OUTPATH)/auto_amp.o $(OUTPATH)/autocoda.o \
  $(OUTPATH)/autofil.o $(OUTPATH)/azibazi.o \
  $(OUTPATH)/bcd.o $(OUTPATH)/bndpas.o \
  $(OUTPATH)/check_s.o \
  $(OUTPATH)/compdecomp.o $(OUTPATH)/codecoutil.o  \
  $(OUTPATH)/componen.o \
  $(OUTPATH)/conv_def.o $(OUTPATH)/fft.o  \
  $(OUTPATH)/eev_sub.o $(OUTPATH)/err_ellipse.o \
  $(OUTPATH)/filename.o $(OUTPATH)/findchan.o \
  $(OUTPATH)/findevin.o $(OUTPATH)/focmec_exe_sub.o \
  $(OUTPATH)/ga_lib.o $(OUTPATH)/get_baz.o \
  $(OUTPATH)/gmt.o $(OUTPATH)/gse_io.o \
  $(OUTPATH)/gserespl.o $(OUTPATH)/gsesei_lib.o \
  $(OUTPATH)/general.o \
  $(OUTPATH)/hypoloc.o $(OUTPATH)/hypoloc1.o \
  $(OUTPATH)/hyposub1.o $(OUTPATH)/hyposub2.o \
  $(OUTPATH)/hyposub3.o $(OUTPATH)/hyposub4.o \
  $(OUTPATH)/hyposub6.o \
  $(OUTPATH)/hypo71sub.o $(OUTPATH)/make_hypoc_brief.o \
  $(OUTPATH)/iscloc_wrap.o  $(OUTPATH)/iscloc.o \
  $(OUTPATH)/inc_id.o $(OUTPATH)/indata.o \
  $(OUTPATH)/isf_isc.o  $(OUTPATH)/isfnor_lib.o \
  $(OUTPATH)/libsei.o $(OUTPATH)/lsqlin.o \
  $(OUTPATH)/lgstr.o $(OUTPATH)/maglib.o\
  $(OUTPATH)/maxlik.o $(OUTPATH)/mb_att.o \
  $(OUTPATH)/merge_f.o  $(OUTPATH)/mfhead.o \
  $(OUTPATH)/mul_spec.o \
  $(OUTPATH)/nortype.o $(OUTPATH)/picsub.o \
  $(OUTPATH)/plot_foc.o \
  $(OUTPATH)/polos.o $(OUTPATH)/quarrycheck.o \
  $(OUTPATH)/recfil.o  $(OUTPATH)/rea.o \
  $(OUTPATH)/rea2.o $(OUTPATH)/removedc.o \
  $(OUTPATH)/sei_mes.o $(OUTPATH)/seiplot.o \
  $(OUTPATH)/seisinc.o $(OUTPATH)/sfilname.o \
  $(OUTPATH)/seed.o $(OUTPATH)/seed.o \
  $(OUTPATH)/shead.o $(OUTPATH)/sheads.o \
  $(OUTPATH)/sacsei_lib.o $(OUTPATH)/sig_spec.o \
  $(OUTPATH)/sacsubf.o $(OUTPATH)/seisanarch.o \
  $(OUTPATH)/spec_dist.o $(OUTPATH)/stat_loc.o \
  $(OUTPATH)/swap.o $(OUTPATH)/syntsel.o \
  $(OUTPATH)/sys_resp.o $(OUTPATH)/systime.o \
  $(OUTPATH)/svd.o $(OUTPATH)/timerout.o \
  $(OUTPATH)/xy_plot.o $(OUTPATH)/respfil.o \
  $(OUTPATH)/seis_sub.o $(OUTPATH)/sfil.o \
  $(OUTPATH)/tau.o $(OUTPATH)/text_sort.o \
  $(OUTPATH)/volcano.o $(OUTPATH)/wave.o 

#
# INCLUDE FILES
#
INCS = ../INC/*.inc ../INC/*.f ../INC/*INC 

info:
	@echo --------------------------------------------------
	@echo "SEISAN Makefile FOR LIB DIRETORY, OPTIONS ARE:"
	@echo " "
	@echo "   all - compiles all, and creates archive"
	@echo "   $(OUTPATH)/<object> - create object"
	@echo "   $(OUTPATH)/$(archive) - create archive"
	@echo "   clean - remove executables"
	@echo " "
	@echo "OUTPUT PATH IS SET TO $(OUTPATH) "
	@echo " "
	@echo "The platform is set through the environmental "
	@echo "variable SEISARCH. The following are supported:"
	@echo "solaris, g77, gfortran, macosx, macosxppc, windows"
	@echo --------------------------------------------------
	@echo "$(test)"

all: output $(OUTPATH) $(PLATFORM_DEP_OBJ) $(SUBS) $(NON_ARCHIVE_SUBS) \
     $(OUTPATH)/$(archive) libmseed/$(OUTPATH)/libmseed.a

output:
	@echo -------------------------------------------------
	@echo ---- COMPILING SEISAN 9.0 LIBRARIES ----------------
	@echo -------------------------------------------------

solaris: 
	mkdir solaris
	mkdir libmseed/solaris
windows: 
	mkdir windows
	mkdir libmseed/windows
g77: 
	mkdir g77
	mkdir libmseed/g77
gfortran: 
	mkdir gfortran
	mkdir libmseed/gfortran
macosx:
	mkdir macosx
	mkdir libmseed/macosx
macosxppc:
	mkdir macosxppc
	mkdir libmseed/macosxppc

#
# fortran object files
#
$(OUTPATH)/abstim.o: abstim.for $(INCS)
	$(fc) abstim.for 

$(OUTPATH)/auto_tr.o: auto_tr.for $(INCS)
	$(fc) auto_tr.for 

$(OUTPATH)/auto_amp.o: auto_amp.for $(INCS)
	$(fc) auto_amp.for

$(OUTPATH)/autocoda.o: autocoda.for $(INCS)
	$(fc) autocoda.for

$(OUTPATH)/autofil.o: autofil.for $(INCS)
	$(fc) autofil.for

$(OUTPATH)/azibazi.o: azibazi.for $(INCS)
	$(fc) azibazi.for

$(OUTPATH)/bcd.o: bcd.for $(INCS)
	$(fc) bcd.for

$(OUTPATH)/bndpas.o: bndpas.for $(INCS)
	$(fc) bndpas.for

$(OUTPATH)/check_s.o: check_s.for $(INCS)
	$(fc) check_s.for

$(OUTPATH)/codecoutil.o: codecoutil.for $(INCS)
	$(fc) codecoutil.for

$(OUTPATH)/compdecomp.o: compdecomp.for $(INCS)
	$(fc) compdecomp.for

$(OUTPATH)/comp_linux.o: comp_linux.for $(INCS)
	$(fc) comp_linux.for

$(OUTPATH)/comp_pc.o: comp_pc.for $(INCS)
	$(fc) comp_pc.for

$(OUTPATH)/comp_sun.o: comp_sun.for $(INCS)
	$(fc) comp_sun.for

$(OUTPATH)/componen.o: componen.for $(INCS)
	$(fc) componen.for

$(OUTPATH)/conv_def.o: conv_def.for $(INCS)
	$(fc) conv_def.for

$(OUTPATH)/dislinplot.o: dislinplot.for $(INCS)
	$(fc) dislinplot.for

$(OUTPATH)/err_ellipse.o: err_ellipse.for $(INCS)
	$(fc) err_ellipse.for

$(OUTPATH)/eev_sub.o: eev_sub.for $(INCS)
	$(fc) eev_sub.for

$(OUTPATH)/fft.o: fft.for $(INCS)
	$(fc) fft.for

$(OUTPATH)/filename.o: filename.for $(INCS)
	$(fc) filename.for

$(OUTPATH)/findchan.o: findchan.for $(INCS)
	$(fc) findchan.for

$(OUTPATH)/findevin.o: findevin.for $(INCS)
	$(fc) findevin.for

$(OUTPATH)/focmec_exe_sub.o: focmec_exe_sub.for
	$(fc) focmec_exe_sub.for

$(OUTPATH)/ga_lib.o: ga_lib.for $(INCS)
	$(fc) ga_lib.for

$(OUTPATH)/general.o: general.for $(INCS)
	$(fc) general.for
	
$(OUTPATH)/get_baz.o: get_baz.for $(INCS)
	$(fc) get_baz.for
	
$(OUTPATH)/gmt.o: gmt.for $(INCS)
	$(fc) gmt.for

$(OUTPATH)/getenv2.o: getenv2.for
	$(fc) getenv2.for
	
$(OUTPATH)/gse_io.o: gse_io.for $(INCS)
	$(fc) gse_io.for

$(OUTPATH)/gsesei_lib.o: gsesei_lib.for $(INCS)
	$(fc) gsesei_lib.for

$(OUTPATH)/gserespl.o: gserespl.for $(INCS)
	$(fc) gserespl.for

$(OUTPATH)/hypinv1.o: hypinv1.for $(INCS)
	$(fc) hypinv1.for

$(OUTPATH)/hypinv2.o: hypinv2.for $(INCS)
	$(fc) hypinv2.for

$(OUTPATH)/hypinv3.o: hypinv3.for $(INCS)
	$(fc) hypinv3.for

$(OUTPATH)/hypoloc.o: hypoloc.for $(INCS)
	$(fc) hypoloc.for

$(OUTPATH)/hypoloc1.o: hypoloc1.for $(INCS)
	$(fc) hypoloc1.for

$(OUTPATH)/hyposub1.o: hyposub1.for $(INCS)
	$(fc) hyposub1.for

$(OUTPATH)/hyposub2.o: hyposub2.for $(INCS)
	$(fc) hyposub2.for

$(OUTPATH)/hyposub3.o: hyposub3.for $(INCS)
	$(fc) hyposub3.for

$(OUTPATH)/hyposub4.o: hyposub4.for $(INCS)
	$(fc) hyposub4.for

$(OUTPATH)/hyposub6.o: hyposub6.for $(INCS)
	$(fc) hyposub6.for

$(OUTPATH)/hypo71sub.o: hypo71sub.for
	$(fc) hypo71sub.for

$(OUTPATH)/iscloc_wrap.o: iscloc_wrap.for $(INCS)
	$(fc) iscloc_wrap.for

$(OUTPATH)/inc_id.o: inc_id.for $(INCS)
	$(fc) inc_id.for

$(OUTPATH)/indata.o: indata.for $(INCS)
	$(fc) indata.for

$(OUTPATH)/isf_isc.o: isf_isc.for $(INCS)
	$(fc) isf_isc.for

$(OUTPATH)/isfnor_lib.o: isfnor_lib.for $(INCS)
	$(fc) isfnor_lib.for

$(OUTPATH)/libsei.o: libsei.for $(INCS)
	$(fc) libsei.for

$(OUTPATH)/lgstr.o: lgstr.for $(INCS)
	$(fc) lgstr.for

$(OUTPATH)/lsqlin.o: lsqlin.for $(INCS)
	$(fc) lsqlin.for

$(OUTPATH)/make_hypoc_brief.o: make_hypoc_brief.for $(INCS)
	$(fc) make_hypoc_brief.for

$(OUTPATH)/maxlik.o: maxlik.for $(INCS)
	$(fc) maxlik.for

$(OUTPATH)/maglib.o: maglib.for $(INCS)
	$(fc) maglib.for

$(OUTPATH)/mb_att.o: mb_att.for $(INCS)
	$(fc) mb_att.for

$(OUTPATH)/merge_f.o: merge_f.for $(INCS)
	$(fc) merge_f.for

$(OUTPATH)/mfhead.o: mfhead.for $(INCS)
	$(fc) mfhead.for

$(OUTPATH)/mul_spec.o: mul_spec.for $(INCS)
	$(fc) mul_spec.for

$(OUTPATH)/nortype.o: nortype.for $(INCS)
	$(fc) nortype.for

$(OUTPATH)/picsub.o: picsub.for $(INCS)
	$(fc) picsub.for

$(OUTPATH)/plot_foc.o: plot_foc.for $(INCS)
	$(fc) plot_foc.for

$(OUTPATH)/polos.o: polos.for $(INCS)
	$(fc) polos.for

$(OUTPATH)/quarrycheck.o: quarrycheck.for
	$(fc) quarrycheck.for
	
$(OUTPATH)/rea.o: rea.for $(INCS)
	$(fc) rea.for

$(OUTPATH)/rea2.o: rea2.for $(INCS)
	$(fc) rea2.for

$(OUTPATH)/recfil.o: recfil.for $(INCS)
	$(fc) recfil.for

$(OUTPATH)/removedc.o: removedc.for $(INCS)
	$(fc) removedc.for

$(OUTPATH)/sacsei_lib.o: sacsei_lib.for $(INCS)
	$(fc) sacsei_lib.for

$(OUTPATH)/sacsubf.o: sacsubf.for $(INCS)
	$(fc) sacsubf.for

$(OUTPATH)/seed.o: seed.for $(INCS)
#	$(fc) seed.for
	$(fc) -fno-range-check seed.for

$(OUTPATH)/sei_mes.o: sei_mes.for $(INCS)
	$(fc) sei_mes.for

$(OUTPATH)/sig_spec.o: sig_spec.for $(INCS)
	$(fc) sig_spec.for

$(OUTPATH)/seiplot.o: seiplot.for $(INCS)
	$(fc) seiplot.for

$(OUTPATH)/seisinc.o: seisinc.for $(INCS)
	$(fc) seisinc.for

$(OUTPATH)/sfilname.o: sfilname.for $(INCS)
	$(fc) sfilname.for

$(OUTPATH)/shead.o: shead.for $(INCS)
	$(fc) shead.for

$(OUTPATH)/sheads.o: sheads.for $(INCS)
	$(fc) sheads.for

$(OUTPATH)/spec_dist.o: spec_dist.for $(INCS)
	$(fc) spec_dist.for

$(OUTPATH)/stat_loc.o: stat_loc.for $(INCS)
	$(fc) stat_loc.for

$(OUTPATH)/svd.o: svd.for $(INCS)
	$(fc) svd.for

$(OUTPATH)/swap.o: swap.for $(INCS)
	$(fc) swap.for

$(OUTPATH)/syntsel.o: syntsel.for $(INCS)
	$(fc) syntsel.for

$(OUTPATH)/sys_resp.o: sys_resp.for $(INCS)
	$(fc) sys_resp.for

$(OUTPATH)/systime.o: systime.for $(INCS)
	$(fc) systime.for

$(OUTPATH)/tau.o: tau.for $(INCS)
	$(fc) tau.for

$(OUTPATH)/text_sort.o: text_sort.for $(INCS)
	$(fc) text_sort.for

$(OUTPATH)/timerout.o: timerout.for $(INCS)
	$(fc) timerout.for

$(OUTPATH)/volcano.o: volcano.for $(INCS)
	$(fc) volcano.for

$(OUTPATH)/wave.o: wave.for $(INCS)
	$(fc) wave.for

$(OUTPATH)/xy_plot.o: xy_plot.for $(INCS)
	$(fc) xy_plot.for

 
#
# c object files
#
$(OUTPATH)/respfil.o: respfil.c
	$(cc) respfil.c

$(OUTPATH)/seis_sub.o: seis_sub.c
	$(cc) seis_sub.c

$(OUTPATH)/seisanarch.o: seisanarch.c
	$(cc) seisanarch.c -Ilibmseed/

$(OUTPATH)/sfil.o: sfil.c
	$(cc) sfil.c

$(OUTPATH)/xget_screen_size_pc.o: xget_screen_size_pc.c
	$(cc) xget_screen_size_pc.c

$(OUTPATH)/xlib.o:xlib.c
	$(cc) xlib.c 

$(OUTPATH)/iscloc.o: iscloc.c $(INCS) \
    ../INC/iscloc.h  ../INC/iscloc_jb_model.h  ../INC/iscloc_jb_tables.h 
	$(cc) iscloc.c

#
# libmseed
#
libmseed/$(OUTPATH)/libmseed.a: libmseed/*.c
	cd libmseed; make gcc; mv *.o $(OUTPATH)/; mv *.a $(OUTPATH)/; cd ..

#
# make archive
#
$(OUTPATH)/$(archive): $(SUBS) $(INCS)
	ar cr $(OUTPATH)/$(archive) $(SUBS) $(PLATFORM_DEP_OBJ)
	ranlib $(OUTPATH)/$(archive)

# 
# delete object files with option clean
#
clean:
	rm -f $(OUTPATH)/*.o
	rm -f $(OUTPATH)/seisan.a 
	rm -f libmseed/$(OUTPATH)/* 

