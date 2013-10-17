clear_everything
files = dir('*.sac');
N     = numel(files);

for k = 1 : N
	a = rsac(files(k).name);
    plot(a.t,a.d)
	if a.picks(1)  ~= -12345
        draw_vert(a.picks(1))        
    end
    setw
    title([a.filename ' Dist = ' num2str(a.dist) ' km. Depth ' num2str(a.evdp) ' km.'])
    xlim([0 75])
    [t y buttom] = ginput(1);
    if buttom == 1
        a.picks(1)=t;
        wsac(a,a.filename);
    end
    
end
