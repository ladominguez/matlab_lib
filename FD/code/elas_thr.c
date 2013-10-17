#include	<stdio.h>
/*#define THREADS	1*/
#ifdef THREADS
#include	<pthread.h>
#endif
#include	"isis.h"

int	nx;
int	nz;
int	nt;
float	h;
float	dt;
int	itrecord= 1;
int	ntrecord;

int	nsrc	= 1;
int	ixsrc0	= 10;
int	izsrc0	= 1;
int	idxsrc	= 0;
int	idzsrc	= 0;
int	lsrc	= 20;
float	srcfreq;
#define P_SRC	1
#define S_SRC	2
int	stype	= P_SRC;

int	nrec	= 1;
int	ixrec0	= 10;
int	izrec0	= 1 ;
int	idxrec	= 1;
int	idzrec	= 0;
char	rectype[8]	= "P";

char output[128];
int	itprint	= 100;
int	mushwidth	=0;
float	mushfactor	=0.995;

struct state
   {
   	float u, w;
	float Txx, Tzz, Txz;
   };
#define S_SIZE sizeof(struct state)
struct state *state;
struct state *rhs, *lhs, *bot;

struct medium
   {
   	float buoy, lam, mu;
   };
#define M_SIZE sizeof(struct medium)
struct medium *med;
#define TXX(ix,iz)	state[(iz)*nx+ix].Txx
#define TZZ(ix,iz)	state[(iz)*nx+ix].Tzz
#define TXZ(ix,iz)	state[(iz)*nx+ix].Txz
#define U(ix,iz)	state[(iz)*nx+ix].u
#define W(ix,iz)	state[(iz)*nx+ix].w
#define B(ix,iz)	med[(iz)*nx+ix].buoy
#define LAM(ix,iz)	med[(iz)*nx+ix].lam
#define MU(ix,iz)	med[(iz)*nx+ix].mu

float *rec;
float *src;

char *ord;
#define ORD(ix,iz)	ord[(iz)*nx+ix]
int	maxord	= 4;

#define ORD2	1
#define ORD4	2
#define ORD6	3
#define ORD8	4
#define FREE	0
#define ABC_LHS	5
#define ABC_RHS	6
#define ABC_BOT	7
#define ABC_TOP	8

#define C1	 1.125		/* 9/8 */
#define C2	 0.04166667	/* -1/24 */
#define D1	 1.1718750	/* 75/64 */
#define D2	 0.0651042	/* -25/384 */
#define D3	 0.00468757	/* 3/640 */
#define E1	 1.19628906
#define E2	 0.07975260
#define E3	 0.00957031
#define E4	 0.00069754

#define MAXTHREAD	100
int	nthreadmax	=1;
struct arginfo
   {
   	int	kst;
	int	ndo;
	int	id;
   };
struct arginfo arg[MAXTHREAD];

main(int ac, char **av)
   {
	int isrc, ixs, izs, it;

   	get_param(ac,av);
	fprintf(stdout,"nx= %3d nz= %3d nt=%3d\n",nx,nz,nt);
	fprintf(stdout,"dt= %8.4f h= %8.2f\n",dt,h);
	fprintf(stdout,"nsrc= %d ixsrc0=%d izsrc0=%d idxsrc=%d idzsrc=%d\n",
		nsrc,ixsrc0, izsrc0, idxsrc, idzsrc);
	fprintf(stdout,"nrec= %d ixrec0=%d izrec0=%d idxrec=%d idzrec=%d\n",
		nrec,ixrec0, izrec0, idxrec, idzrec);
	fprintf(stdout,"rectype= %c\n",rectype[0]);
	fprintf(stdout,"srcfreq= %8.3f lsrc=%d stype=%d\n",srcfreq,lsrc,stype);
	fprintf(stdout,"nthreads= %d\n",nthreadmax);

	/* main memory allocation */
	ntrecord= nt/itrecord;
	state= (struct state *)(malloc(nx*nz*S_SIZE));
	med  = (struct medium *)(malloc(nx*nz*M_SIZE));
	rec  = (float *)(malloc(4*nrec*ntrecord));
	ord  = (char *)(malloc(nx*nz));
	/* the followowing are for the absorbibg BC */
	rhs= (struct state *)(malloc(nz*S_SIZE));
	lhs= (struct state *)(malloc(nz*S_SIZE));
	bot= (struct state *)(malloc(nx*S_SIZE));
	if(state == NULL || med== NULL || rec == NULL || ord == NULL ||
	    rhs == NULL || lhs == NULL || bot == NULL)
	   {
	   	fprintf(stderr,"cannot alloc memory\n");
		exit(-1);
	   }
	get_model(ac,av);
	setorder(maxord);


	for(isrc= 0; isrc < nsrc; isrc++)
	   {
	   	ixs= ixsrc0 + isrc * idxsrc;
	   	izs= izsrc0 + isrc * idzsrc;
		zap(state,nx*nz*S_SIZE/4);
		for(it=0; it<nt; it++)
		   {
		   	add_source(ixs,izs,it,stype);
			step(it);
			if(it%itrecord == 0) record(it/itrecord);
			if(it%10 == 0) norm(it);
		   }
		/* rec_norm(); */
		output_rec(ixs,izs);
	   }
   }

get_param(int ac, char **av)
   {
	int i;
	double arg, sin();
	char stypestr[16];

   	setpar(ac,av);
	mstpar("nx","d",&nx);
	mstpar("nz","d",&nz);
	mstpar("nt","d",&nt);
	mstpar("h","f",&h);
	getpar("itrecord","d",&itrecord);
	mstpar("dt","f",&dt);
	mstpar("output","s",output);
	getpar("ord","d",&maxord);
	getpar("nsrc","d",&nsrc);
	getpar("ixsrc0","d",&ixsrc0);
	getpar("izsrc0","d",&izsrc0);
	getpar("idxsrc","d",&idxsrc);
	getpar("idzsrc","d",&idzsrc);
	if(ixsrc0+(nsrc-1)*idxsrc >= nx ||
	   izsrc0+(nsrc-1)*idzsrc >= nz )
	   {
	   	fprintf(stderr,"sources will be off of mesh\n");
		exit(-1);
	   }
	getpar("nrec","d",&nrec);
	getpar("rectype","s",rectype);
	getpar("ixrec0","d",&ixrec0);
	getpar("izrec0","d",&izrec0);
	getpar("idxrec","d",&idxrec);
	getpar("idzrec","d",&idzrec);
	if(ixrec0+(nrec-1)*idxrec >= nx ||
	   izrec0+(nrec-1)*idzrec >= nz )
	   {
	   	fprintf(stderr,"receivers will be off of mesh\n");
		exit(-1);
	   }
   	srcfreq= 1.0/((double)(lsrc) * dt);
	if(getpar("lsrc","d",&lsrc))
	   	srcfreq= 1.0/((double)(lsrc) * dt);
	if(getpar("srcfreq","f",&srcfreq))
		lsrc= (int)(srcfreq * dt);
	if( (src= (float *)(malloc(4*lsrc))) == NULL)
	   {
	   	fprintf(stderr,"Cannot alloc memeory for src\n");
		exit(-1);
	   }
	arg= 2.0*3.14159/(double)(lsrc-1);
	for(i=0; i<lsrc; i++)
		src[i]= sin( (double)(i) * arg);
	if(getpar("stype","s",stypestr))
	   	if(strcmp(stypestr,"S")== 0) stype= S_SRC;
	getpar("nthread","d",&nthreadmax);
	getpar("mushwidth","d",&mushwidth);
	getpar("mushfactor","f",&mushfactor);
	endpar();
   }

get_model(int ac, char **av)
   {
	int fd, ix, iz, k;
	char modelname[128], name[128];
	float *den, *vp, *vs, fac, mu, lam;
	double sqrt3, sqrt();
	double vpmin, vpmax, vsmin, vsmax, stab, coefsum, pts_per_wave;

   	setpar(ac,av);
	mstpar("model","s",modelname);
	endpar();

	/* temporairily use state space */
	vp= (float *)(&state[0]);
	den= &vp[nx*nz];
	vs= &vp[2*nx*nz];

	sprintf(name,"%s.den",modelname);
	if( (fd= open(name,0)) < 0 )
	   {
	   	fprintf(stderr,"cannot open %s\n",name);
		exit(-1);
	   }
	if(read(fd,den,4*nx*nz) != 4*nx*nz)
	   {
	   	fprintf(stderr,"den read error in model\n");
		exit(-1);
	   }
	close(fd);

	sprintf(name,"%s.vp",modelname);
	if( (fd= open(name,0)) < 0 )
	   {
	   	fprintf(stderr,"cannot open %s\n",name);
		exit(-1);
	   }
	if(read(fd,vp,4*nx*nz) != 4*nx*nz)
	   {
	   	fprintf(stderr,"vel read error in model\n");
		exit(-1);
	   }
	close(fd);

	sprintf(name,"%s.vs",modelname);
	if( (fd= open(name,0)) < 0 )
	   {
	   	fprintf(stderr,"cannot open %s\n",name);
		exit(-1);
	   }
	if(read(fd,vs,4*nx*nz) != 4*nx*nz)
	   {
	   	fprintf(stderr,"vel read error in model\n");
		exit(-1);
	   }
	close(fd);

	sqrt3= sqrt(3.0);
	fac= dt/h;
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
		k= iz*nx + ix;
		mu= vs[k]*vs[k]*den[k];
		lam= vp[k]*vp[k]*den[k] - 2.0*mu;
	   	B(ix,iz)= fac/den[k];
		LAM(ix,iz)= fac * lam;
		MU(ix,iz)= fac * mu;
	   }
	/* on the edges, we compute the coefficients for the ABC's */
	for(iz=0; iz<nz; iz++)
	   {
	   	LAM(0,iz)= (1.0 - vp[iz*nx   ]*fac)/(1.0 + vp[iz*nx   ]*fac);
	   	 MU(0,iz)= (1.0 - vs[iz*nx   ]*fac)/(1.0 + vs[iz*nx   ]*fac);
	   	LAM(nx-1,iz)= (1.0 - vp[iz*nx +nx-1]*fac)/(1.0 + vp[iz*nx +nx-1]*fac);
	   	 MU(nx-1,iz)= (1.0 - vs[iz*nx +nx-1]*fac)/(1.0 + vs[iz*nx +nx-1]*fac);
	   }
	for(ix=0; ix<nx; ix++)
	   {
	   	LAM(ix,nz-1)= (1.0 - vp[(nz-1)*nx +ix]*fac)/(1.0 + vp[(nz-1)*nx +ix]*fac);
	   	 MU(ix,nz-1)= (1.0 - vs[(nz-1)*nx +ix]*fac)/(1.0 + vs[(nz-1)*nx +ix]*fac);
	   }
	/* check stability condition */
	vpmax= vsmax= -99999.0;
	vpmin= vsmin=  99999.0;
	for(k=0; k<nx*nz; k++)
	   {
		if(vp[k] > vpmax) vpmax= vp[k];
		if(vp[k] < vpmin) vpmin= vp[k];
		if(vs[k] > vsmax) vsmax= vs[k];
		/* extra test to discount water */
		if(vs[k] < vsmin && vs[k] > 1.0) vsmin= vs[k];
	   }

	coefsum= 1.0;
	if(maxord == 4) coefsum= C1+C2;
	if(maxord == 6) coefsum= D1+D2+D3;
	if(maxord == 8) coefsum= E1+E2+E3+E4;
	stab= vpmax * dt * coefsum * sqrt(2.0)/h;
	fprintf(stdout,"model stability vmax= %8.4f stab= %8.4f (should be < 1)\n",
		vpmax, stab);
	pts_per_wave= vpmin * (double)(lsrc) * dt/ h;
	fprintf(stdout,"model accuracy P:  vpmin= %8.4f point_per_wavelength= %8.4f\n",
		vpmin, pts_per_wave);
	pts_per_wave= vsmin * (double)(lsrc) * dt/ h;
	fprintf(stdout,"model accuracy S:  vsmin= %8.4f point_per_wavelength= %8.4f\n",
		vsmin, pts_per_wave);

   }

add_source(int ixs,int izs,int it, int stype)
    {
    	if(it >= lsrc) return;
	/*
	TXX(ixs,izs) += src[it];
	TZZ(ixs,izs) += src[it];
	*/
	if(stype == S_SRC)
	   {
		TXZ(ixs,izs) = src[it];
	   }
	 else
	   {
		TXX(ixs,izs) = src[it];
		TZZ(ixs,izs) = src[it];
	   }
   }

record(int it)
   {
	int ir, irx, irz;
   	for(ir=0; ir< nrec; ir++)
	   {
	   	irx= ixrec0 + ir*idxrec;
	   	irz= izrec0 + ir*idzrec;
		switch(rectype[0])
		   {
		   	case 'P':
		   	case 'p':
			default:
				rec[ir*ntrecord + it]
				   = TXX(irx,irz) + TZZ(irx,irz);
				break;
		   	case 'S':
		   	case 's':
				rec[ir*ntrecord + it]
				   = TXZ(irx,irz);
				break;
		   	case 'U':
		   	case 'u':
				rec[ir*ntrecord + it]
				   = U(irx,irz);
				break;
		   	case 'W':
		   	case 'w':
				rec[ir*ntrecord + it]
				   = W(irx,irz);
				break;
		   }
	   }
   }

step(int it)
   {
   	/* step solution one time step */
	int ix, iz;
	float ux, wz, uz, wx, dxTxx, dzTzz, dxTxz, dzTxz, gam;
	double abc();
	int ithr, load;
	int update_stress(), update_velocity();

	/* make a copy of the next-to-edge row for ABC */
	for(ix=0; ix<nx; ix++)
	   {
	   	bot[ix].Txx= TXX(ix,nz-2);
	   	bot[ix].Tzz= TZZ(ix,nz-2);
	   	bot[ix].Txz= TXZ(ix,nz-2);
	   	bot[ix].u=     U(ix,nz-2);
	   	bot[ix].w=     W(ix,nz-2);
	   }
	for(iz=0; iz<nz; iz++)
	   {
	   	lhs[iz].Txx= TXX(1,iz);
	   	lhs[iz].Tzz= TZZ(1,iz);
	   	lhs[iz].Txz= TXZ(1,iz);
	   	lhs[iz].u=     U(1,iz);
	   	lhs[iz].w=     W(1,iz);
	   	rhs[iz].Txx= TXX(nx-2,iz);
	   	rhs[iz].Tzz= TZZ(nx-2,iz);
	   	rhs[iz].Txz= TXZ(nx-2,iz);
	   	rhs[iz].u=     U(nx-2,iz);
	   	rhs[iz].w=     W(nx-2,iz);
	   }

#ifdef THREADS
	launch(update_stress,nthreadmax);
	launch(update_velocity,nthreadmax);
#else
	arg[0].kst = 0;
	arg[0].ndo = nx*nz;
	update_stress(&arg[0]);
	update_velocity(&arg[0]);
#endif
	/* apply mush zones to cut down on side reflections */
	for(iz=0; iz<nz; iz++)
	   {
	   	for(ix=0; ix < mushwidth; ix++)
		   {
		   	TXX(ix,iz) *= mushfactor;
		   	TZZ(ix,iz) *= mushfactor;
		   	TXZ(ix,iz) *= mushfactor;
		   	U(ix,iz)   *= mushfactor;
		   	W(ix,iz)   *= mushfactor;
		   }
	   	for(ix=nx-mushwidth; ix < nx; ix++)
		   {
		   	TXX(ix,iz) *= mushfactor;
		   	TZZ(ix,iz) *= mushfactor;
		   	TXZ(ix,iz) *= mushfactor;
		   	U(ix,iz)   *= mushfactor;
		   	W(ix,iz)   *= mushfactor;
		   }
	   }
	for(ix=0; ix<nx; ix++)
	   {
	   	for(iz=nz-mushwidth; iz < nz; iz++)
		   {
		   	TXX(ix,iz) *= mushfactor;
		   	TZZ(ix,iz) *= mushfactor;
		   	TXZ(ix,iz) *= mushfactor;
		   	U(ix,iz)   *= mushfactor;
		   	W(ix,iz)   *= mushfactor;
		   }
	   }
   }

update_stress(struct arginfo *arg)
   {
	int ix, iz, k, kuse, kst, ndo;
	float ux, wz, uz, wx, dxTxx, dzTzz, dxTxz, dzTxz, gam;
	double abc();

	kst= arg->kst;
	ndo= arg->ndo;
   	for(k=kst; k<kst+ndo; k++)
	   {
	   	ix= k%nx;
		iz= k/nx;
	   	switch(ORD(ix,iz))
		   {
		   	case ORD8:
			   	ux= E1*( U(ix,iz) - U(ix-1,iz) )
				   -E2*( U(ix+1,iz) - U(ix-2,iz) )
				   +E3*( U(ix+2,iz) - U(ix-3,iz) )
				   -E4*( U(ix+3,iz) - U(ix-4,iz) );
				uz= E1*( U(ix,iz) - U(ix,iz-1) )
				   -E2*( U(ix,iz+1) - U(ix,iz-2) )
				   +E3*( U(ix,iz+2) - U(ix,iz-3) )
				   -E4*( U(ix,iz+3) - U(ix,iz-4) );
			   	wx= E1*( W(ix+1,iz) - W(ix,iz) )
				   -E2*( W(ix+2,iz) - W(ix-1,iz) )
				   +E3*( W(ix+3,iz) - W(ix-2,iz) )
				   -E4*( W(ix+4,iz) - W(ix-3,iz) );
				wz= E1*( W(ix,iz+1) - W(ix,iz) )
				   -E2*( W(ix,iz+2) - W(ix,iz-1) )
				   +E3*( W(ix,iz+3) - W(ix,iz-2) )
				   -E4*( W(ix,iz+4) - W(ix,iz-3) );
				goto hop1;
		   	case ORD6:
			   	ux= D1*( U(ix,iz) - U(ix-1,iz) )
				   -D2*( U(ix+1,iz) - U(ix-2,iz) )
				   +D3*( U(ix+2,iz) - U(ix-3,iz) );
				uz= D1*( U(ix,iz) - U(ix,iz-1) )
				   -D2*( U(ix,iz+1) - U(ix,iz-2) )
				   +D3*( U(ix,iz+2) - U(ix,iz-3) );
			   	wx= D1*( W(ix+1,iz) - W(ix,iz) )
				   -D2*( W(ix+2,iz) - W(ix-1,iz) )
				   +D3*( W(ix+3,iz) - W(ix-2,iz) );
				wz= D1*( W(ix,iz+1) - W(ix,iz) )
				   -D2*( W(ix,iz+2) - W(ix,iz-1) )
				   +D3*( W(ix,iz+3) - W(ix,iz-2) );
				goto hop1;
		   	case ORD4:
			   	ux= C1*( U(ix,iz) - U(ix-1,iz) )
				   -C2*( U(ix+1,iz) - U(ix-2,iz) );
				uz= C1*( U(ix,iz) - U(ix,iz-1) )
				   -C2*( U(ix,iz+1) - U(ix,iz-2) );
			   	wx= C1*( W(ix+1,iz) - W(ix,iz) )
				   -C2*( W(ix+2,iz) - W(ix-1,iz) );
				wz= C1*( W(ix,iz+1) - W(ix,iz) )
				   -C2*( W(ix,iz+2) - W(ix,iz-1) );
				goto hop1;
		   	case ORD2:
			   	ux= U(ix,iz) - U(ix-1,iz);
				uz= U(ix,iz) - U(ix,iz-1);
			   	wx= W(ix+1,iz) - W(ix,iz);
				wz= W(ix,iz+1) - W(ix,iz);
			hop1:
				gam= LAM(ix,iz) + 2.0*MU(ix,iz);
				TXX(ix,iz) +=  gam*ux + LAM(ix,iz)*wz;
				TZZ(ix,iz) +=  LAM(ix,iz)*ux + gam*wz;
				TXZ(ix,iz) +=  MU(ix,iz)*(uz + wx);
				break;

		   	case FREE:
				TXX(ix,iz) = 0.0;
				TZZ(ix,iz) = 0.0;
				TXZ(ix,iz) = 0.0;
				break;

		   	case ABC_LHS:
				TXX(ix,iz)= abc( LAM(ix,iz),
				                 lhs[iz].Txx,
						 TXX(ix,iz),
						 TXX(ix+1,iz));
				TZZ(ix,iz)= abc( LAM(ix,iz),
				                 lhs[iz].Tzz,
						 TZZ(ix,iz),
						 TZZ(ix+1,iz));
				TXZ(ix,iz)= abc(  MU(ix,iz),
				                 lhs[iz].Txz,
						 TXZ(ix,iz),
						 TXZ(ix+1,iz));
				break;
		   	case ABC_RHS:
				TXX(ix,iz)= abc( LAM(ix,iz),
				                 rhs[iz].Txx,
						 TXX(ix,iz),
						 TXX(ix-1,iz));
				TZZ(ix,iz)= abc( LAM(ix,iz),
				                 rhs[iz].Tzz,
						 TZZ(ix,iz),
						 TZZ(ix-1,iz));
				TXZ(ix,iz)= abc(  MU(ix,iz),
				                 rhs[iz].Txz,
						 TXZ(ix,iz),
						 TXZ(ix-1,iz));
				break;
		   	case ABC_BOT:
				TXX(ix,iz)= abc( LAM(ix,iz),
				                 bot[ix].Txx,
						 TXX(ix,iz),
						 TXX(ix,iz-1));
				TZZ(ix,iz)= abc( LAM(ix,iz),
				                 bot[ix].Tzz,
						 TZZ(ix,iz),
						 TZZ(ix,iz-1));
				TXZ(ix,iz)= abc(  MU(ix,iz),
				                 bot[ix].Txz,
						 TXZ(ix,iz),
						 TXZ(ix,iz-1));
				break;
		   	case ABC_TOP:
				TXX(ix,iz) = 0.0;
				TZZ(ix,iz) = 0.0;
				TXZ(ix,iz) = 0.0;
				break;
			default:
				fprintf(stderr,"Illegal instruction at ix=%d iz=%d ord=%d\n",
					ix,iz,ORD(ix,iz));
				exit(-1);
		   }
	   }
   }

update_velocity(struct arginfo *arg)
   {
	int ix, iz, k, kuse, kst, ndo;
	float ux, wz, uz, wx, dxTxx, dzTzz, dxTxz, dzTxz, gam;
	double abc();

	kst= arg->kst;
	ndo= arg->ndo;
   	for(k=kst; k<kst+ndo; k++)
	   {
	   	ix= k%nx;
		iz= k/nx;
	   	switch(ORD(ix,iz))
		   {
		   	case ORD8:
			   	dxTxx= E1*( TXX(ix+1,iz) - TXX(ix,iz) )
				      -E2*( TXX(ix+2,iz) - TXX(ix-1,iz) )
				      +E3*( TXX(ix+3,iz) - TXX(ix-2,iz) )
				      -E4*( TXX(ix+4,iz) - TXX(ix-3,iz) );
			   	dzTzz= E1*( TZZ(ix,iz) - TZZ(ix,iz-1) )
				      -E2*( TZZ(ix,iz+1) - TZZ(ix,iz-2) )
				      +E3*( TZZ(ix,iz+2) - TZZ(ix,iz-3) )
				      -E4*( TZZ(ix,iz+3) - TZZ(ix,iz-4) );
			   	dxTxz= E1*( TXZ(ix,iz) - TXZ(ix-1,iz) )
				      -E2*( TXZ(ix+1,iz) - TXZ(ix-2,iz) )
				      +E3*( TXZ(ix+2,iz) - TXZ(ix-3,iz) )
				      -E4*( TXZ(ix+3,iz) - TXZ(ix-4,iz) );
			   	dzTxz= E1*( TXZ(ix,iz+1) - TXZ(ix,iz) )
				      -E2*( TXZ(ix,iz+2) - TXZ(ix,iz-1) )
				      +E3*( TXZ(ix,iz+3) - TXZ(ix,iz-2) )
				      -E4*( TXZ(ix,iz+4) - TXZ(ix,iz-3) );
				goto hop2;
		   	case ORD6:
			   	dxTxx= D1*( TXX(ix+1,iz) - TXX(ix,iz) )
				      -D2*( TXX(ix+2,iz) - TXX(ix-1,iz) )
				      +D3*( TXX(ix+3,iz) - TXX(ix-2,iz) );
			   	dzTzz= D1*( TZZ(ix,iz) - TZZ(ix,iz-1) )
				      -D2*( TZZ(ix,iz+1) - TZZ(ix,iz-2) )
				      +D3*( TZZ(ix,iz+2) - TZZ(ix,iz-3) );
			   	dxTxz= D1*( TXZ(ix,iz) - TXZ(ix-1,iz) )
				      -D2*( TXZ(ix+1,iz) - TXZ(ix-2,iz) )
				      +D3*( TXZ(ix+2,iz) - TXZ(ix-3,iz) );
			   	dzTxz= D1*( TXZ(ix,iz+1) - TXZ(ix,iz) )
				      -D2*( TXZ(ix,iz+2) - TXZ(ix,iz-1) )
				      +D3*( TXZ(ix,iz+3) - TXZ(ix,iz-2) );
				goto hop2;
		   	case ORD4:
			   	dxTxx= C1*( TXX(ix+1,iz) - TXX(ix,iz) )
				      -C2*( TXX(ix+2,iz) - TXX(ix-1,iz) );
			   	dzTzz= C1*( TZZ(ix,iz) - TZZ(ix,iz-1) )
				      -C2*( TZZ(ix,iz+1) - TZZ(ix,iz-2) );
			   	dxTxz= C1*( TXZ(ix,iz) - TXZ(ix-1,iz) )
				      -C2*( TXZ(ix+1,iz) - TXZ(ix-2,iz) );
			   	dzTxz= C1*( TXZ(ix,iz+1) - TXZ(ix,iz) )
				      -C2*( TXZ(ix,iz+2) - TXZ(ix,iz-1) );
				goto hop2;

		   	case ORD2:
			   	dxTxx= TXX(ix+1,iz) - TXX(ix,iz);
			   	dzTzz= TZZ(ix,iz) - TZZ(ix,iz-1);
			   	dxTxz= TXZ(ix,iz) - TXZ(ix-1,iz);
			   	dzTxz= TXZ(ix,iz+1) - TXZ(ix,iz);
			hop2:
				U(ix,iz) += B(ix,iz) * (dxTxx + dzTxz);
				W(ix,iz) += B(ix,iz) * (dxTxz + dzTzz);
				break;
		   	case FREE:
				U(ix,iz)= 0.0;
				W(ix,iz)= 0.0;
				break;

		   	case ABC_LHS:
				U(ix,iz)= abc( LAM(ix,iz),
				               lhs[iz].u,
					        U(ix,iz),
						U(ix+1,iz));
				W(ix,iz)= abc(  MU(ix,iz),
				               lhs[iz].w,
					        W(ix,iz),
						W(ix+1,iz));
				break;
		   	case ABC_RHS:
				U(ix,iz)= abc( LAM(ix,iz),
				               rhs[iz].u,
					        U(ix,iz),
						U(ix-1,iz));
				W(ix,iz)= abc(  MU(ix,iz),
				               rhs[iz].w,
					        W(ix,iz),
						W(ix-1,iz));
				break;
		   	case ABC_BOT:
				U(ix,iz)= abc(  MU(ix,iz),
				               bot[ix].u,
					        U(ix,iz),
						U(ix,iz-1));
				W(ix,iz)= abc( LAM(ix,iz),
				               bot[ix].w,
					        W(ix,iz),
						W(ix,iz-1));
				break;
		   	case ABC_TOP:
				U(ix,iz)= 0.0;
				W(ix,iz)= 0.0;
				break;
			default:
				fprintf(stderr,"Illegal instruction at ix=%d iz=%d ord=%d\n",
					ix,iz,ORD(ix,iz));
				exit(-1);
		   }
	   }
   }

double
abc(double coef, double a, double b, double c)
  {
	/*
	  Absorbing boundary condition 
	  Determine d from a, b, and c and
	  coef= (1-v*dt/h)/(1+v*dt/h)

	    x  x+1
	  +---+---+
	  | c | d | t+1
	  +---+---+
	  | a | b | t
	  +---+---+
	 */
  	double d;
	d= a + coef * (b-c);
	return(d);
   }

int recfd	= -1;
output_rec(int ixs,int izs)
   {
	struct traceinfo isis;
	int ir, ixr, izr;

	/*  Writes the demultiplexed seismograms in demultiplexed form. */
	/*  Wites 'isis' headers' for each seismogram */
	/* recfd stays open over successive calls with new sources */
	if(recfd < 0)
	   {
	   	if( (recfd= creat(output,0664)) < 0)
		   {
		   	fprintf(stderr,"cannot create out-ut= %s\n",output);
			exit(-1);
		   }
	   }
	zap(&isis,TRSIZE/4);
	for(ir=0; ir<nrec; ir++)
	   {
	   	ixr= ixrec0 + ir * idxrec;
	   	izr= izrec0 + ir * idzrec;
		isis.xr= (float)(ixr) * h;
		isis.yr= 0.0;
		isis.zr= (float)(izr) * h;
		isis.xs= (float)(ixs) * h;
		isis.ys= 0.0;
		isis.zs= (float)(izs) * h;
		isis.nt= ntrecord;
		isis.samplerate= dt * (double)(itrecord);
		isis.t0= 0.0;
		isis.status= 0;
		isis.dtstatic= 0.0;
		isis.ampstatic= 1.0;
		isis.srcflagnum= 100+ ixs;
		isis.recflagnum= 500+ ixr;
		write(recfd,&isis,TRSIZE);
		write(recfd,&rec[ir*ntrecord],4*ntrecord);
	   }
   }

zap(float *x, int n)
   {
   	int i;
	for(i=0; i<n; i++) x[i]= 0.0;
   }

norm(int it)
   {
   	double Txxnorm, Tzznorm, Txznorm, unorm, wnorm, sqrt();
	int ix, iz;

	Txxnorm= Tzznorm= Txznorm= unorm= wnorm= 0.0;
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
	   	Txxnorm += TXX(ix,iz) * TXX(ix,iz);
	   	Tzznorm += TZZ(ix,iz) * TZZ(ix,iz);
	   	Txznorm += TXZ(ix,iz) * TXZ(ix,iz);
	   	unorm += U(ix,iz) * U(ix,iz);
	   	wnorm += W(ix,iz) * W(ix,iz);
	   }
	Txxnorm= sqrt(Txxnorm);
	Tzznorm= sqrt(Tzznorm);
	Txznorm= sqrt(Txznorm);
	unorm= sqrt(unorm);
	wnorm= sqrt(wnorm);
	fprintf(stderr,"norm it=%3d Txx=%14.4e Tzz=%14.4e Txz=%14.4e u=%14.4e w=%14.4e\n",
		it,Txxnorm, Tzznorm, Txznorm,unorm,wnorm);
   }

rec_norm()
   {
	int ir, i;
	float *p;
	double sum, sqrt();

   	for(ir=0; ir<nrec; ir++)
	   {
	   	sum= 0.0;
		p= &rec[ir*ntrecord];
		for(i=0; i< ntrecord; i++) sum += p[i]*p[i];
		sum= sqrt(sum);
		fprintf(stderr,"rec norm ir=%2d %14.4e\n",ir,sum);
	   }
   }

setorder(int maxorder)
   {
	/* This routine sets the operation that is performed on
	   each node in the model. Most nodes are 'maxorder'. The
	   order decreases linearlt towould the edges.  Boundary
	   conditions are then specified at the edge nodes.
	 */
	int k, max, ix, iz;
	max= maxorder/2;
	for(k=1; k<= max; k++)
	   {
		for(iz=k; iz < nz-k; iz++)
		for(ix=k; ix < nx-k; ix++)
			ORD(ix,iz)= k;
	   }
	for(iz=0, ix=0; ix<nx; ix++) ORD(ix,iz)= FREE;
	for(iz=nz-1, ix=0; ix<nx; ix++) ORD(ix,iz)= ABC_BOT;
	for(ix=0, iz=0; iz<nz; iz++) ORD(ix,iz)= ABC_LHS;
	for(ix=nx-1, iz=0; iz<nz; iz++) ORD(ix,iz)= ABC_RHS;
   }
#ifdef THREADS
pthread_t	thr[MAXTHREAD];

launch(void(*update)(void *), int nthread)
   {
	/* this routine divides the work, and launches a thread for
	   each part.  It then waits for all of them to finish
	 */
	int load, ithr;
	load= (nx*nz + nthread -1)/nthread;
	for(ithr= 0; ithr < nthread; ithr++)
	   {
		/* launch threads */
		arg[ithr].kst = ithr*load;
		arg[ithr].ndo = load;
		if(arg[ithr].kst +arg[ithr].ndo > nx*nz) arg[ithr].ndo= nx*nz-arg[ithr].kst;
		arg[ithr].id  = ithr;
		thr[ithr]= ithr;
		if(pthread_create(&thr[ithr],NULL,(void *)update,&arg[ithr]))
		   {
		   	fprintf(stderr,"failure to create thread\n");
			exit(-1);
		   }
	   }
	for(ithr= 0; ithr < nthread; ithr++)
	   {
		/* wait for thread to finish */
	   	if(pthread_join(thr[ithr],NULL))
		   {
		   	fprintf(stderr,"failure to rejoin thread\n");
			exit(-1);
		   }
	   }
   }
#endif
