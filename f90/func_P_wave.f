C	Compile this code with myTTMake
C	This program prints the travel time of the P-wave in terms of the depth 
C	and delta. It reads the file params.dat, the first line must contain 
C	the delta[Degrees] and the second one the depth[km]. This program
C 	is used by the matlab function TravelTime.f. 
	SUBROUTINE Pwave(DELTA,DEPTH,TIME)
C
	SAVE
	PARAMETER (MAX=60)
	LOGICAL LOG,PRNT(3)
	CHARACTER*8 PHLST(10),PHCD(MAX)
	CHARACTER*20 modnam
	REAL*8 DEPTH
	REAL*8 DELTA,TIME
	DIMENSION TT(MAX),DTDD(MAX),DTDH(MAX),DDDP(MAX)
	INTEGER N
	DATA in/1/,modnam/'iasp91'/,PHLST(1)/'query'/,PRNT(3)/.true./
	DIMENSION USCR(2)
c	OPEN(11,file='params.dat')
	call tabin(in,modnam)
	call brnset(1,phlst,prnt)
1	CONTINUE
C	READ(11,40) DELTA
C 40	FORMAT(F6.3)
C	READ(11,41) DEPTH
C 41	FORMAT(F5.2)
	PRNT(1)=.false.
	PRNT(2)=.false.
	call depset(DEPTH,USCR)
	call trtm(DELTA,MAX,N,TT,DTDD,DTDH,DDDP,PHCD)
	TIME=TT(1)
	return
	END
