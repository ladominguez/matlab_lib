function color=false_color(A,transpose)

Color=zeros([size(A) 3]);
Hue=zeros(size(A));
Saturation=zeros(size(A));
Value=ones(size(A));

if max(max(abs(A)))>1
	%A=normalize(A);
	disp('Matrix values out of range [0-1] - false_color.m');
end

A=A-ones(size(A))*diag(mean(A));
A=normalize(A);

Red_index=find(A>=0.0);
Saturation(Red_index)=A(Red_index);

Blue_index=find(A<0.0); 
Hue(Blue_index)=0.6;
Saturation(Blue_index)=abs(A(Blue_index));

if nargin==1
    color(:,:,1)=Hue;
    color(:,:,2)=Saturation;
    color(:,:,3)=Value;
    color=hsv2rgb(color);
else
    color(:,:,1)=Hue';
    color(:,:,2)=Saturation';
    color(:,:,3)=Value';
    color=hsv2rgb(color);
end
