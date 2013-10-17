%calculates the covariance matrix of the model used in mylsq
vect=ones(1,mmm)*ssq/(nnn-mmm);
cov=diag(vect,0);
vmod=inv(am'*am)*cov;
sdev=sqrt(diag(vmod));
['        a     Stdev'];
[a' sdev];
