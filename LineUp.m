% LineUp.m: This program shift the sismograms. In other words this program
%	    line up a especific phase.
%
% 	Syntaxis
%		SeismShift=LineUp(Seismograms)
%	IN
%		Seismgrams: Matriz cointaing a seismogram of every
%			    station in each row.
%	OUT
%		SeismShift: Matriz with the seismograms lined up.
%
%	Author: Luis A. Dominguez. March 2007.

function SeismShift=LineUp()
close all
load PArrival.dat
load seis.dat 
Seismograms=seis;
whos seis Seismograms
files=dir('DATA/*HHZ.sac');
NumSeism=length(files);
TDuration=length(Seismograms)
Index=IndexGen('Z');
FirstArrival=min(PArrival);
FirstArrivalIndex=round(100*FirstArrival);

SeismShift=zeros(size(seis));
t=0:0.01:(TDuration-1)*0.01;
whos SeismShift t
for i=1:NumSeism 
   Shift=round((PArrival(i)-FirstArrival)*100);
   SeismShift(i,1:TDuration-Shift)=0.1.*Seismograms(i,Shift+1:TDuration); 
   plot(t,2.*SeismShift(i,:)+i,'k');
	hold on
end
axis tight

SetTitle('Z');
List=GetStaNames();


set(gca,'YLim',[0 70]);
set(gca,'YTick',1:69);
set(gca,'YTickLabel',List);
end
