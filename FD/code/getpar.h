#ifndef _GETPAR_H_
#define _GETPAR_H_

#include <stdio.h>

int getpar(char *name,char *type,int *val);
int mstpar(char *name,char *type,int *val);
int setpar(int ac,char **av);

/* Internal functions */
void gp_add_entry(char *name,char *value);
void gp_close_dump(FILE *file);
int gp_compute_hash(char *s);
void gp_do_par_file(char *fname,int level);
int gp_getvector(char *list,char *type,int *val);
void gp_subpar(char **apl,char **apv);

#endif /* _GETPAR_H_ */

