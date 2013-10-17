
#include	<stdio.h>

struct layers
   {
   	float depth;
	float vp, vs, den;
   };

struct layers lay[1000];
float den1	=1000.0;
float den2	=2600.0;
float vel1	=1500;
float vel2	= 2500;
float vptovs	= 1.7320508;
main(int ac, char **av)
   {
	float *vp, *vs, *den, *vpcol, *vscol, *dencol, h;
	double depth, vpval, vsval, denval, z;
	int ix, iz, nx, nz, k, ilay, nlay, fd, linenum;
	char basename[128], name[128], layername[128], line[128];
	FILE *fopen(), *input;

	setpar(ac,av);
	mstpar("nx","d",&nx);
	mstpar("nz","d",&nz);
	mstpar("h","f",&h);
	mstpar("model","s",basename);
	mstpar("layers","s",layername);
	endpar();
	fprintf(stdout,"nx= %d nz= %d h= %7.2f input=%s\n",nx,nz,h,layername);

	vp= (float *)(malloc(4*nx*nz));
	vs= (float *)(malloc(4*nx*nz));
	den= (float *)(malloc(4*nx*nz));
	vpcol= (float *)(malloc(4*nz));
	vscol= (float *)(malloc(4*nz));
	dencol= (float *)(malloc(4*nz));
	if(vp == NULL || vs== NULL || den == NULL ||
		vpcol == NULL || vscol == NULL || dencol == NULL)
	   {
	   	fprintf(stderr,"cannot alloc memory\n");
		exit(-1);
	   }
	if( (input= fopen(layername,"r")) == NULL )
	   {
	   	fprintf(stderr,"cannot open layers= %s\n",layername);
		exit(-1);
	   }
	linenum= 0;
	nlay= 0;
	while( fgets(line,128,input) != NULL )
	   {
		linenum++;
	   	if(line[0] == '#') continue;
		k= sscanf(line,"%lf %lf %lf %lf",&depth,&vpval,&vsval,&denval);
		if(k != 4)
		   {
		   	fprintf(stderr,"layer model syntax error at line= %d\n",linenum);
			exit(-1);
		   }
		if(vsval < 0.0) vsval= -vpval*vsval;
		if(denval < 0.0) denval= -vpval*denval;
		lay[nlay].depth= depth;
		lay[nlay].vp= vpval;
		lay[nlay].vs= vsval;
		lay[nlay].den= denval;
		nlay++;
	   }
	fclose(input);
	fprintf(stdout,"nlayers= %d\n",nlay);
	/* backstop */
	lay[nlay].depth= 999999999.0;

	ilay= 0;
	for(iz=0; iz<nz; iz++)
	   {
	   	z= iz*h;
		if(z >= lay[ilay+1].depth) ilay++;
		vpcol[iz]= lay[ilay].vp;
		vscol[iz]= lay[ilay].vs;
		dencol[iz]= lay[ilay].den;
	   }
	   	
	for(iz=0; iz<nz; iz++)
	for(ix=0; ix<nx; ix++)
	   {
		   	vp[iz*nx+ix]= vpcol[iz];
		   	vs[iz*nx+ix]= vscol[iz];
		   	den[iz*nx+ix]= dencol[iz];
	   }
	sprintf(name,"%s.den",basename);
	if( (fd= creat(name,0664)) < 0)
	   {
	   	fprintf(stderr,"cannot create file %s\n",name);
		exit(-1);
	   }
	write(fd,den,4*nx*nz);
	close(fd);

	sprintf(name,"%s.vp",basename);
	if( (fd= creat(name,0664)) < 0)
	   {
	   	fprintf(stderr,"cannot create file %s\n",name);
		exit(-1);
	   }
	write(fd,vp,4*nx*nz);
	close(fd);

	sprintf(name,"%s.vs",basename);
	if( (fd= creat(name,0664)) < 0)
	   {
	   	fprintf(stderr,"cannot create file %s\n",name);
		exit(-1);
	   }
	write(fd,vs,4*nx*nz);
	close(fd);
   }
