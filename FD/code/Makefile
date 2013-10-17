#CFLAGS= -g
CFLAGS= -O3

acou: acou.o getpar.o
	cc -o acou acou.o getpar.o -lm

acou_thr: acou_thr.o getpar.o
	cc -O3 -DTHREADS -o acou_thr acou_thr.c getpar.o -lpthread -lm

acou1D: acou1D.o getpar.o
	cc -o acou1D acou1D.o getpar.o -lm

elas: elas.o getpar.o
	cc -o elas elas.o getpar.o -lm

elas_thr: elas_thr.o getpar.o
	cc -O3 -DTHREADS -o elas_thr elas_thr.c getpar.o -lpthread -lm

make_model: make_model.o getpar.o
	cc -o make_model make_model.o getpar.o -lm

make_model1D: make_model1D.o getpar.o
	cc -o make_model1D make_model1D.o getpar.o -lm

tar:
	tar cvf FD.tar acou_thr.c elas_thr.c getpar.c make_model.c getpar.h isis.h Makefile
