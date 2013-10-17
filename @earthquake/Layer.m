function Layer=Layer(Epicenter)

if isa(Epicenter,'earthquake')
	Depth=Epicenter.depth;
else
	Depth=Epicenter;
end

if Depth>35.0
	Layer=3; % Deep
elseif Depth>20.0
	Layer=2; % Intermediate
elseif Depth>=0
	Layer=1; % Shallow
else
        error('Wrong depth value.')
end


