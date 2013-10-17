#!/usr/bin/perl 
# Extracts a CMT solution from the Master file (concatenated dek format)
# and prints out a file in the format used by SPECFEM. 
#
# Usage: cmtsol.pl C060696B or cmtsol.pl 060696B
#
# Doesn't need the initial quality indicator.  
# The my() construct allows you to define
# variables whose influence does not extend outside the scope of the
# subroutine within which they are enclosed.
#
# Last modified by fjsimons@alum.mit.edu, July 9th, 2008

# Should write the next two lines to decide for themselves.
my $century = 1000;
my $century = 2000;

foreach $code (@ARGV){

    @file = $ENV{"IFILES"}."/CMT/CMT-events";
    
    open(fid1,"@file") || die "Can't find CMT file.\n";
    
    open(fid2,">>CMTSOLUTION-$code") || die "Can't open file locally.\n";
    
    $count = 0;
    while(<fid1>){
	if (/$code/ or $count >0 and $count <4) {
	    $count += 1;
	    @line=split;
	    if ($count ==1) {
		($hr,$mn,$sc)=split(":",@line[2]);
		($mo,$dy,$yr)=split("\/",@line[1]);
		my $lat = substr($_,28,7);
		my $lon = substr($_,35,8);
		my $dep = substr($_,43,6);
		my $m1 = substr($_,49,3);
		my $m2 = substr($_,52,3);
		my $name = substr($_,55,24);
		printf(fid2 "%-5s%4i %2i %2i %2i %2i %5.2f %8.4f %9.4f %5.1f %3.1f %3.1f %24s\n",
		       "PDE",$century+$yr,$mo,$dy,$hr,$mn,$sc,$lat,$lon,$dep,$m1,$m2,$name);
		printf(fid2 "%-14s %8s\n","event name:",@line[0]);
	    };
	    if ($count ==2) {
		my $dt = substr($_,33,6);
		printf(fid2 "%-14s %8.4f\n","time shift:",$dt);
		# Using my would have made these local to the loop!
		# WANT TO USE THE SECOND LINE OF THE CMT SOLUTION FOR THIS
		$lat = substr($_,43,7);
		$lon = substr($_,55,8);
		$dep = substr($_,68,6);
	    }
	    if ($count ==3) {
		printf(fid2 "%-14s %8.4f\n","half duration:",@line[1]);
		printf(fid2 "%-14s %8.4f\n","latitude:",$lat);
		printf(fid2 "%-14s%9.4f\n","longitude:",$lon);
		printf(fid2 "%-14s %8.4f\n","depth:",$dep);
		# my $ex = @line[3];
		# printf(fid2 "%-9s %13.6E\n","Mrr:",10**$ex*@line[4]);
		# printf(fid2 "%-9s %13.6E\n","Mtt:",10**$ex*@line[6]);
		# printf(fid2 "%-9s %13.6E\n","Mpp:",10**$ex*@line[8]);
		# printf(fid2 "%-9s %13.6E\n","Mrt:",10**$ex*@line[10]);
		# printf(fid2 "%-9s %13.6E\n","Mrp:",10**$ex*@line[12]);
		# printf(fid2 "%-9s %13.6E\n","Mtp:",10**$ex*@line[14]);
		# Sometime duration exceeds 9.99, so need to do:
		my $ex = substr($_,11,3);
		$Mrr=10**$ex*substr($_,14,6);
		$Mtt=10**$ex*substr($_,25,6);
		$Mpp=10**$ex*substr($_,36,6);
		$Mrt=10**$ex*substr($_,47,6);
		$Mrp=10**$ex*substr($_,58,6);
		$Mtp=10**$ex*substr($_,69,6);
		printf(fid2 "%-9s %13.6E\n","Mrr:",$Mrr);
		printf(fid2 "%-9s %13.6E\n","Mtt:",$Mtt);
		printf(fid2 "%-9s %13.6E\n","Mpp:",$Mpp);
		printf(fid2 "%-9s %13.6E\n","Mrt:",$Mrt);
		printf(fid2 "%-9s %13.6E\n","Mrp:",$Mrp);
		printf(fid2 "%-9s %13.6E\n","Mtp:",$Mtp);
	    }
	}
	if ($count ==4){$count=0}
    }
    
    close(fid1);
    close(fid2);
}
