function A=funcScat_v2(pIn,layer,phase)
% [C]=funcScat_v2(p,layer,phase)
%
% Returns the transmition/reflection coefficients, for
% a given incident ray parameter.
%
% IN.
% 	p   	Incident ray parameter.
% 	phase	'PdPu', 'SdPu', 'PuPu', 'SuPu', 'PdSu',
%		'SdSu', 'PuSu', 'SuSu', 'PdPd', 'SdPd',
%		'PuPd', 'SuPd', 'PdSd', 'SdSd', 'PuSd',
%		'SuSd'.
%	layer	Layer must be higher or eqauel to 2
% OUT.
%	C	Reflection/refraction coeffcient.
%
%			By Paul Davis. 2007
% See Aki and Richards Page 144 Scatering MATRIX

[alpha beta rho]=layer_model_for_amplitudes(layer);

a1=alpha(1);
a2=alpha(2);
b1=beta(1);
b2=beta(2);  % Stands for beta2
r1=rho(1);	% Stands for rho1
r2=rho(2);	% Stands for rho2

%Test Values. See pag 147 Aki and Folks
%r1=3;
%a1=6;
%b1=3.5;
%r2=4;
%a2=7;
%b2=4.2; 

if isnumeric(phase)
	phase_index= bin2dec(num2str(phase));
	phase_opt=['PuPu'; 'PuSu'; 'SuPu'; 'SuSu'];
	phase=phase_opt(phase_index+1,:);
end

End=length(pIn);

for i=1:End

p=pIn(i);

i1=asin(p*a1); 
i2=asin(p*a2);
j1=asin(p*b1);
j2=asin(p*b2);

%See Akin and richards pag 144

a=r2*(1-2*b2^2*p^2)-r1*(1-2*b1^2*p^2);
b=r2*(1-2*b2^2*p^2)+2*r1*b1^2*p^2;
c=r1*(1-2*b1^2*p^2)+2*r2*b2^2*p^2;
d=2*(r2*b2^2-r1*b1^2);

E=b*(cos(i1)/a1)+c*(cos(i2)/a2);
F=b*(cos(j1)/b1)+c*(cos(j2)/b2);
G=a-d*(cos(i1)/a1)*(cos(j2)/b2);
H=a-d*(cos(i2)/a2)*(cos(j1)/b1);
D=E*F+G*H*p^2;


switch phase
	case 'PdPu'
		Coeff=((b*(cos(i1)/a1)-c*(cos(i2)/a2))*F-...
		        (a+d*(cos(i1)/a1)*(cos(j2)/b2))*H*p^2)/D;
	case 'SdPu'
		Coeff=-2*(cos(j1)/b1)*(a*b+c*d*(cos(i2)/a2)*(cos(j2)/b2))*p*b1/...
        		(a1*D);
	case 'PuPu'
		Coeff=2*r2*(cos(i2)/a2)*F*a2/...
		        (a1*D);
	case 'SuPu'
		Coeff=2*r2*(cos(j2)/b2)*H*p*b2/...
        		(a1*D);
	case 'PdSu'
		Coeff=-2*(cos(i1)/a1)*(a*b+c*d*(cos(i2)/a2)*(cos(j2)/b2))*p*a1/...
		        (b1*D);
	case 'SdSu'
		Coeff=-((b*(cos(j1)/b1)-c*(cos(j2)/b2))*E-(a+d*(cos(i2)/a2)*(cos(j1)/b1))*G*p^2)/...
		        D;
 	case 'PuSu'
		Coeff=-2*r2*(cos(i2)/a2)*G*p*a2/(b1*D);
	case 'SuSu'
		Coeff=2*r2*(cos(j2)/b2)*E*b2/...
		        (b1*D);
	case 'PdPd'
		Coeff=2*r1*(cos(i1)/a1)*F*a1/...
        		(a2*D);
	case 'SdPd'
		Coeff=-2*r1*(cos(j1)/b1)*G*p*b1/...
		        (a2*D);

	case 'PuPd'
		Coeff=-((b*(cos(i1)/a1)-c*(cos(i2)/a2))*F+(a+d*(cos(i2)/a2)*(cos(j1)/b1))*G*p^2)/...
        		D;
	case 'SuPd'
		Coeff=2*(cos(j2)/b2)*(a*c+b*d*(cos(i1)/a1)*(cos(j1)/b1))*p*b2/...
        		(a2*D);
	case 'PdSd'
		Coeff=2*r1*(cos(i1)/a1)*H*p*a1/...
       			 (b2*D);
	case 'SdSd'
		Coeff=2*r1*(cos(j1)/b1)*E*b1/...
        		(b2*D);
	case 'PuSd'
		Coeff=2*(cos(i2)/a2)*(a*c+b*d*(cos(i1)/a1)*(cos(j1)/b1))*p*a2/...
        		(b2*D);
	case 'SuSd'
		Coeff=((b*(cos(j1)/b1)-c*(cos(j2)/b2))*E+(a+d*(cos(i1)/a1)*(cos(j2)/b2))*H*p^2)/...
        		D;
	otherwise
		error('Wrong option. (funcScat_v2.m)')
end

A(i)=Coeff;

end


