%% Stacking
clear_everything;
Component='R';
Gain=25;
[files Nf]=ValidateComponent(Component);

Window=75; % Time in seconds
t_marker=1;
index=IndexTrench(files);

hold on
sac=rsac(files(index(1)).name);
nsamples=floor(Window/sac.dt);
index_template=find(sac.t>=sac.picks(1),nsamples,'first');
Template=normalize(sac.d(index_template));

timeshift=zeros(1,Nf);
dst=timeshift;
dst(1)=distance2trench(sac);
stack=zeros(Nf,nsamples);
for k=2:Nf
    sac=rsac(files(index(k)).name);
    y=normalize(sac.d);
    yc=xcorr(y,Template);
    yc=yc(sac.npts+1:end);
    [a b]=max(yc);
    index_stack=find(sac.t>=sac.t(b),nsamples,'first');
    if length(index_stack)~=size(stack,2)
        continue
    end
    stack(k,:)=sac.d(index_stack);
    timeshift(k)=sac.picks(t_marker)-sac.t(b);
   
    dst(k)=distance2trench(sac);
    plot(sac.t,Gain*y+dst(k),'k',sac.picks(1),dst(k),'o','MarkerFaceColor','b')
    plot(sac.t(b),dst(k),'kd','MarkerFaceColor','g');
    
%    plot(stack(k,:),'Color',[0.7 0.7 0.7])   
    if timeshift(k)<=4.0 
         sac.picks(2)=sac.t(b);
    else
        sac.picks(2)=sac.picks(1);
    end
  %   wsac(sac,sac.filename)
end
setw
xlabel('Time [s]')
ylabel('Distance to the trench [km]')
SetTitle(Component, sac)
%%
figure
plot(dst,timeshift,'d')
ylabel('t_{teo}-t_{corr}')
xlabel('Distance to the trench [km]')
grid
setw
SetTitle(Component, sac)
figure(1) 
return
%% find scattered field
figure
hold on
[files Nf]=ValidateComponent('Z');
index=IndexTrench(files);
 for k=1:Nf
     sac=rsac(files(index(k)).name);
     t2=sac.picks(1)-timeshift(k);
     index_inc=find(sac.t>=t2,nsamples,'first');
     y=normalize(sac.d);
     y(index_inc)=0;
     yc=xcorr(y,Template);
     yc=yc(sac.npts+1:end);
     [a b]=max(yc);
     plot(sac.t,10*y+dst(k),'k',sac.picks(1),dst(k),'o',...
        sac.t(b),dst(k),'x');
    %sac.picks(2),dst(k),'+',
 end
setw
xlabel('Time [s]')
ylabel('Distance to the trench [km]')
SetTitle(Component, sac)

