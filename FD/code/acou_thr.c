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

int	nrec	= 1;
int	ixrec0	= 10;
int	izrec0	= 1 ;
int	idxrec	= 1;
int	idzrec	= 0;

char	output[128];
int	itprint	= 100;
int	mushwidth	=0;
float	mushfactor	=0.995;

struct state
   {
   	float p, u, w;
   };
#define S_SIZE sizeof(struct state)
struct state *state;
struct state *lhs, *rhs, *bot;

struct medium
   {
   	float buoy, bulk;
   };
#define M_SIZE sizeof(struct medium)
struct medium *med;
#define P(ix,iz)	state[(iz)*nx+ix].p
#define U(ix,iz)	state[(iz)*nx+ix].u
#define W(ix,iz)	state[(iz)*nx+ix].w
#define B(ix,iz)	med[(iz)*nx+ix].buoy
#define K(ix,iz)	med[(iz)*nx+ix].bulk

float *rec;
float *src;

char *ord;
#define ORD(ix,iz)	ord[(iz)*nx+ix]
int	maxord	=4;
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
FILE *debugfd, *fopen();
	debugfd= fopen("debug.out","w");

   	get_param(ac,av);
	fprintf(stdout,"nx= %3d nz= %3d nt=%3d\n",nx,nz,nt);
	fprintf(stdout,"dt= %8.4f h= %8.2f\n",dt,h);
	fprintf(stdout,"nsrc= %d ixsrc0=%d izsrc0=%d idxsrc=%d idzsrc=%d\n",
		nsrc,ixsrc0, izsrc0, idxsrc, idzsrc);
	fprintf(stdout,"nrec= %d ixrec0=%d izrec0=%d idxrec=%d idzrec=%d\n",
		nrec,ixrec0, izrec0, idxrec, idzrec);
	fprintf(stdout,"srcfeq= %8.3f lsrc=%d\n",srcfreq,lsrc);
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
	     rhs == NULL || lhs == NULL || bot == NULL )
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
		   	add_source(ixs,izs,it);
			step(it);
			if(it%itrecord == 0) record(it/itrecord);
			if(it%10 == 0) norm(it);
			/*
			if(it%itprint == 0)
				fprintf(stderr,"src= %d it= %3d\n",isrc,it);
				*/
		   }
		/*rec_norm();*/
		output_rec(ixs,izs);
	   }
   }

get_param(int ac, char **av)
   {
	int i;
	double arg, sin();

   	setpar(ac,av);
	mstpar("nx","d",&nx);
	mstpar("nz","d",&nz);
	mstpar("nt","d",&nt);
	mstpar("h","f",&h);
	mstpar("dt","f",&dt);
	getpar("itrecord","d",&itrecord);
	getpar("nthread","d",&nthreadmax);
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
	getpar("mushwidth","d",&mushwidth);
	getpar("mushfactor","f",&mushfactor);
	endpar();
   }

get_model(int ac, char **av)
   {
	int fd, ix, iz, k;
	char modelname[128], name[128];
	float *den, *vel, fac, velmax;
	float stab, pts_per_wave, coefsum, velmin;
	double sqrt();
	double bulkmax, bulkmin, buoymax, buoymin;

   	setpar(ac,av);
	mstpar("model","s",modelname);
	endpar();


	/* temporairily use state space */
	vel= (float *)(&state[0]);
	den= &vel[nx*nz];

	sprintf(name,"%s.vp",modelname);
	if( (fd= open(name,0)) < 0 )
	   {
	   	fprintf(stderr,"cannot open %s\n",name);
		exit(-1);
	   }
	if(read(fd,vel,4*nx*nz) != 4*nx*nz)
	   {
	   	fprintf(stderr,"vel read error in model\n");
		exit(-1);
	   }
	close(fd);

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
	fac= dt/h;
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
		k= iz*nx + ix;
	   	B(ix,iz)= fac/den[k];
		K(ix,iz)= fac * den[k] * vel[k] * vel[k];
	   }
	for(iz=0; iz<nz; iz++)
	   {
	   	K(0,iz)= (1.0-vel[iz*nz ] * fac)/(1.0 + vel[iz*nx ]*fac);
	   	K(nx-1,iz)= (1.0-vel[iz*nz +nx-1] * fac)/(1.0 + vel[iz*nx +nx-1]*fac);
	   }
	for(ix=0; ix<nx; ix++)
	   {
	   	K(ix,nz-1)= (1.0-vel[(nz-1)*nx + ix]*fac)/(1.0 + vel[(nz-1)*nx +ix]*fac);
	   }
	/* check stability condition */
	velmax= velmin= vel[0];
	for(k=1; k<nx*nz; k++)
	   {
		if(vel[k] > velmax) velmax= vel[k];
		if(vel[k] < velmin) velmin= vel[k];
	   }

	coefsum= 1.0;
	if(maxord == 4) coefsum= C1+C2;
	if(maxord == 6) coefsum= D1+D2+D3;
	if(maxord == 8) coefsum= E1+E2+E3+E4;
	stab= velmax * dt * coefsum * sqrt(2.0)/h;
	fprintf(stdout,"model stability vmax= %8.4f stab= %8.4f (should be < 1)\n",
		velmax, stab);
	pts_per_wave= velmin * (double)(lsrc) * dt/ h;
	fprintf(stdout,"model accuracy vmin= %8.4f point_per_wavelength= %8.4f\n",
		velmin, pts_per_wave);
	buoymin= bulkmin= 1.0e20;
	buoymax= bulkmax= -1.0e20;
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
	   	if(K(ix,iz) > bulkmax) bulkmax= K(ix,iz);
	   	if(K(ix,iz) < bulkmin) bulkmin= K(ix,iz);
	   	if(B(ix,iz) > buoymax) buoymax= B(ix,iz);
	   	if(B(ix,iz) < buoymin) buoymin= B(ix,iz);
	   }
	fprintf(stderr,"bulkmin= %14.4e bulkmax= %14.4e\n",bulkmin,bulkmax);
	fprintf(stderr,"buoymin= %14.4e buoymax= %14.4e\n",buoymin,buoymax);
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
	   	if(K(ix,iz) < 0.0)
		   {
		   	fprintf(stderr,"ix=%d iz=%d bulk= %14.4f\n",ix,iz,B(ix,iz));
			exit(-1);
		   }
	   }
   }

add_source(int ixs,int izs,int it)
    {
    	if(it >= lsrc) return;
	/*
	P(ixs,izs) += src[it];
	*/
	P(ixs,izs) = src[it];
   }

record(int it)
   {
	int ir, irx, irz;
   	for(ir=0; ir< nrec; ir++)
	   {
	   	irx= ixrec0 + ir*idxrec;
	   	irz= izrec0 + ir*idzrec;
		rec[ir*ntrecord + it]= P(irx,irz);
	   }
   }

step(int it)
   {
	int ix, iz;
	float ux, wz, px, pz;
	double abc();
	int iord;
	int ithr, load;
	int update_stress(), update_velocity();

   	/* step solution one time step */
	/* make a copy of the next-to-edge row for ABC */
	for(ix=0; ix<nx; ix++)
	   {
		bot[ix].p= P(ix,nz-2);
		bot[ix].u= U(ix,nz-2);
		bot[ix].w= W(ix,nz-2);
	   }
	for(iz=0; iz<nz; iz++)
	   {
		lhs[iz].p= P(1,iz);
		lhs[iz].u= U(1,iz);
		lhs[iz].w= W(1,iz);
		rhs[iz].p= P(nx-2,iz);
		rhs[iz].u= U(nx-2,iz);
		rhs[iz].w= W(nx-2,iz);
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
		   	P(ix,iz) *= mushfactor;
		   	U(ix,iz) *= mushfactor;
		   	W(ix,iz) *= mushfactor;
		   }
	   	for(ix=nx-mushwidth; ix < nx; ix++)
		   {
		   	P(ix,iz) *= mushfactor;
		   	U(ix,iz) *= mushfactor;
		   	W(ix,iz) *= mushfactor;
		   }
	   }
	for(ix=0; ix<nx; ix++)
	   {
	   	for(iz=nz-mushwidth; iz < nz; iz++)
		   {
		   	P(ix,iz) *= mushfactor;
		   	U(ix,iz) *= mushfactor;
		   	W(ix,iz) *= mushfactor;
		   }
	   }


   }

update_stress(struct arginfo *arg)
   {
	int ix, iz, k, kuse, kst, ndo;
	float ux, wz, px, pz;
	double abc();
	int iord;

	kst= arg->kst;
	ndo= arg->ndo;
   	for(k=kst; k<kst+ndo; k++)
	   {
	   	ix= k%nx;
		iz= k/nx;

		iord= ORD(ix,iz);
	   	switch(ORD(ix,iz))
		   {
		   	case ORD8:
			   	ux= E1*( U(ix,iz) - U(ix-1,iz) )
				   -E2*( U(ix+1,iz) - U(ix-2,iz) )
				   +E3*( U(ix+2,iz) - U(ix-3,iz) )
				   -E4*( U(ix+3,iz) - U(ix-4,iz) );
				wz= E1*( W(ix,iz+1) - W(ix,iz) )
				   -E2*( W(ix,iz+2) - W(ix,iz-1) )
				   +E3*( W(ix,iz+3) - W(ix,iz-2) )
				   -E4*( W(ix,iz+4) - W(ix,iz-3) );
				goto hop1;
		   	case ORD6:
			   	ux= D1*( U(ix,iz) - U(ix-1,iz) )
				   -D2*( U(ix+1,iz) - U(ix-2,iz) )
				   +D3*( U(ix+2,iz) - U(ix-3,iz) );
				wz= D1*( W(ix,iz+1) - W(ix,iz) )
				   -D2*( W(ix,iz+2) - W(ix,iz-1) )
				   +D3*( W(ix,iz+3) - W(ix,iz-2) );
				goto hop1;
		   	case ORD4:
			   	ux= C1*( U(ix,iz) - U(ix-1,iz) )
				   -C2*( U(ix+1,iz) - U(ix-2,iz) );
				wz= C1*( W(ix,iz+1) - W(ix,iz) )
				   -C2*( W(ix,iz+2) - W(ix,iz-1) );
				goto hop1;
		   	case ORD2:
			   	ux= U(ix,iz) - U(ix-1,iz);
				wz= W(ix,iz+1) - W(ix,iz);
			hop1:
				P(ix,iz) += K(ix,iz) *( ux + wz);
				break;

			case FREE:
				P(ix,iz)= 0.0;
				break;
			case ABC_LHS:
				P(ix,iz)= abc(K(ix,iz),lhs[iz].p,P(ix,iz),P(ix+1,iz));
				break;
			case ABC_RHS:
				P(ix,iz)= abc(K(ix,iz),rhs[iz].p,P(ix,iz),P(ix-1,iz));
				break;
			case ABC_BOT:
				P(ix,iz)= abc(K(ix,iz),bot[iz].p,P(ix,iz),P(ix,iz-1));
				break;
			case ABC_TOP:
				P(ix,iz)= 0.0;
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
	float ux, wz, px, pz;
	double abc();
	int iord;

	kst= arg->kst;
	ndo= arg->ndo;
   	for(k=kst; k<kst+ndo; k++)
	   {
	   	ix= k%nx;
		iz= k/nx;
	   	switch(ORD(ix,iz))
		   {
		   	case ORD8:
			   	px= E1*( P(ix+1,iz) - P(ix,iz) )
				   -E2*( P(ix+2,iz) - P(ix-1,iz) )
				   +E3*( P(ix+3,iz) - P(ix-2,iz) )
				   -E4*( P(ix+4,iz) - P(ix-3,iz) );
			   	pz= E1*( P(ix,iz) - P(ix,iz-1) )
				   -E2*( P(ix,iz+1) - P(ix,iz-2) )
				   +E3*( P(ix,iz+2) - P(ix,iz-3) )
				   -E4*( P(ix,iz+3) - P(ix,iz-4) );
				goto hop2;
		   	case ORD6:
			   	px= D1*( P(ix+1,iz) - P(ix,iz) )
				   -D2*( P(ix+2,iz) - P(ix-1,iz) )
				   +D3*( P(ix+3,iz) - P(ix-2,iz) );
			   	pz= D1*( P(ix,iz) - P(ix,iz-1) )
				   -D2*( P(ix,iz+1) - P(ix,iz-2) )
				   +D3*( P(ix,iz+2) - P(ix,iz-3) );
				goto hop2;
		   	case ORD4:
			   	px= C1*( P(ix+1,iz) - P(ix,iz) )
				   -C2*( P(ix+2,iz) - P(ix-1,iz) );
			   	pz= C1*( P(ix,iz) - P(ix,iz-1) )
				   -C2*( P(ix,iz+1) - P(ix,iz-2) );
				goto hop2;
		   	case ORD2:
			   	px= P(ix+1,iz) - P(ix,iz);
			   	pz= P(ix,iz) - P(ix,iz-1);
			hop2:
				U(ix,iz) += B(ix,iz) * px;
				W(ix,iz) += B(ix,iz) * pz;
				break;
			case FREE:
				U(ix,iz)= 0.0;
				W(ix,iz)= 0.0;
				break;
			case ABC_LHS:
				U(ix,iz)= abc(K(ix,iz),lhs[iz].u,U(ix,iz),U(ix+1,iz));
				W(ix,iz)= abc(K(ix,iz),lhs[iz].w,W(ix,iz),W(ix+1,iz));
				break;
			case ABC_RHS:
				U(ix,iz)= abc(K(ix,iz),rhs[iz].u,U(ix,iz),U(ix-1,iz));
				W(ix,iz)= abc(K(ix,iz),rhs[iz].w,W(ix,iz),W(ix-1,iz));
				break;
			case ABC_BOT:
				U(ix,iz)= abc(K(ix,iz),bot[ix].u,U(ix,iz),U(ix,iz-1));
				W(ix,iz)= abc(K(ix,iz),bot[ix].w,W(ix,iz),W(ix,iz-1));
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
	/*
	d= 0.0;
	*/
	return(d);
   }

int recfd	= -1;
output_rec(int ixs,int izs)
   {
	struct traceinfo isis;
	int ir, ixr, izr;

	/* recfd stays open over successive calls */
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
   	double pnorm, unorm, wnorm, sqrt();
   	double pmax, umax, wmax, fabs();
	int ipmax, iumax, iwmax;
	int ix, iz;

	pnorm= unorm= wnorm= 0.0;
	pmax= umax= wmax= 0.0;
	ipmax= iumax= iwmax= -1;
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
	   	pnorm += P(ix,iz) * P(ix,iz);
	   	unorm += U(ix,iz) * U(ix,iz);
	   	wnorm += W(ix,iz) * W(ix,iz);
		if(fabs(P(ix,iz)) > pmax)
		   {
		   	pmax= fabs(P(ix,iz));
			ipmax= iz*nx+ix;
		   }
		if(fabs(U(ix,iz)) > umax)
		   {
		   	umax= fabs(U(ix,iz));
			iumax= iz*nx+ix;
		   }
		if(fabs(W(ix,iz)) > wmax)
		   {
		   	wmax= fabs(W(ix,iz));
			iwmax= iz*nx+ix;
		   }
	   }
	pnorm= sqrt(pnorm);
	unorm= sqrt(unorm);
	wnorm= sqrt(wnorm);
	fprintf(stdout,"norm it=%3d p=%14.4e u=%14.4e w=%14.4e\n",
		it,pnorm,unorm,wnorm);
	/*
	fprintf(stdout,"\tp=%14.4e (%d,%d) u=%14.4e (%d,%d) w=%14.4e (%d,%d)\n",
		pmax, ipmax%nx, ipmax/nx,
		umax, iumax%nx, iumax/nx,
		wmax, iwmax%nx, iwmax/nx);
	*/
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
		fprintf(stdout,"rec norm ir=%2d %14.4e\n",ir,sum);
	   }
   }

setorder(int maxorder)
   {
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

char map[] = " 0 1 2 3 4 5 6 7 8 9*";
printerplot(int it)
   {
	int nxuse, nzuse, ival, ix, iz;
	double fabs(), max, val;
	char line[60];
   	nxuse= nx;
	nzuse= nz;
	if(nxuse > 50) nxuse= 50;
	if(nzuse > 50) nzuse= 50;
	max= -1.0e20;
	for(iz=0; iz<nzuse; iz++)
	for(ix=0; ix<nxuse; ix++)
		if(fabs(P(ix,iz)) > max) max= fabs(P(ix,iz));
	fprintf(stdout,"it= %d max= %14.4e\n",it,max);
	for(iz=0; iz<nzuse; iz++)
	   {
		for(ix=0; ix<nxuse; ix++) line[ix]= '.';
		for(ix=0; ix<nxuse; ix++)
		   {
		   	val= fabs(P(ix,iz));
			ival= (int)(val/max * 20.0);
			if(ival < 0) ival= 0;
			if(ival > 20) ival= 20;
			line[ix]= map[ival];
		   }
		line[nxuse]= '\0';
		fprintf(stdout,"%2d |%s|\n",iz,line);
	   }
	fprintf(stdout,"\n");
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
