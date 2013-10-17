function varargout=Tos(k,th,params,phi,xi,pxm,xver)
% [invT,detT,L,T]=Tos(k,th,params,phi,xi,pxm,xver)
%
% Calculates functions of isotropic T in Olhede & Simons.
%
% INPUT:
%
% k        Wavenumber(s) at which this is to be evaluated [1/m]
% th       The parameter vector with TWO elements (rest ignored)
%          D   Isotropic flexural rigidity [Nm]
%          f2  The sub-surface to surface initial loading ratio
% params   A structure with AT LEAST these constants that are known:
%          DEL   surface and subsurface density contrast [kg/m^3]
%          g     gravitational acceleration [m/s^2]
% phi      Optionally precalculated phi, see PHIOS
% xi       Optionally precalculated xi, see XIOS
% pxm      Optionally precalculated (phi*xi-1)
%
% OUTPUT:
%
% invT     A 3-column vector with all the wavenumbers unwrapped,
%          invT={invT[1,1](k) invT[1,2](k) invT[2,2](k)}
% detT     The determinant of T, a column vector over the wavenumbers
% L        The Cholesky factorization of T, as the lower-left matrix 
%          L={L[1,1](k) L[2,1](k) L[2,2](k)}, where L[1,2]=0
% T        The actual matrix T, in the same format as invT
%
% Last modified by fjsimons-at-alum.mit.edu, 02/10/2011

defval('xver',0)

% Extract the parameters from the input
D=th(1);
f2=th(2);
DEL=params.DEL;
g=params.g;

defval('phi',phios(k,D,DEL,g));
defval('xi',xios(k,D,DEL,g));
% Note that this has a zero at zero wavenumber
defval('pxm',(phi.*xi-1));

% Forcefully set f2 to a positive number even if it means a throw back
f2=abs(f2);

% The inverse of T; ignore warnings as Inf turns to NaN in HFORMOS 
warning off MATLAB:divideByZero
fax=dpos(DEL,-2,2)*xi.^2/f2./pxm.^2;
warning on MATLAB:divideByZero
invT=[fax.*(                   1+f2*dpos(DEL,2,-2)*phi.^2) ...
      fax.*(dpos(DEL,-1,1)*xi   +f2*dpos(DEL,1,-1)*phi   ) ...
      fax.*(dpos(DEL,-2,2)*xi.^2+f2)];

if nargout>=2 || xver==1
  % Compute the determinant of T; this will be zero at k=0
  detT=f2*dpos(DEL,4,-4)*xi.^(-4).*pxm.^2;
else
  detT=NaN;
end

if nargout>=3 || xver==1
  % Compute the Cholesky factorization of T
  fax=dpos(DEL,0,-1)*xi.^(-1)./...
      sqrt(dpos(DEL,0,2)*xi.^2+f2*dpos(DEL,2,0));
  L=[fax.*( dpos(DEL,0,2)*xi.^2+f2*dpos(DEL,2,0)) ...
     fax.*(-dpos(DEL,1,-1)*[dpos(DEL,0,2)*xi+f2*dpos(DEL,2,0).*phi]) ...
     fax.*(sqrt(f2)*dpos(DEL,2,0)*pxm)];
else
  L=NaN;
end

if nargout>=4 || xver==1
  % Compute T itself, which is required when producing blurred things
  fax=xi.^(-2);
  T=[fax.*(             xi.^2+f2*dpos(DEL,2,-2)        ) ...
     fax.*(-dpos(DEL,1,-1)*xi-f2*dpos(DEL,3,-3)*phi    ) ...
     fax.*( dpos(DEL,2,-2)   +f2*dpos(DEL,4,-4)*phi.^2)];
else
  T=NaN;
end

% And now for the output
varns={invT,detT,L,T};
varargout=varns(1:nargout);

% Verification mode
if xver==1
  disp('Tos being verified')
  % The zero wavenumbers are always going to be trouble
  kbadi=find(sum(isinf(invT),2)); kgoodi=skip(1:length(k(:)),kbadi);
  % disp(sprintf('Troublesome wave number at %3g',k(kbadi)))
  % Explicit verification of the determinant
  difer(detT-[T(:,1).*T(:,3)-T(:,2).^2],8,[],NaN)
  % Explicit verification of the inverse by the Cayley-Hamilton theorem
  warning off MATLAB:divideByZero
  chek1=invT-[T(:,3) -T(:,2) T(:,1)]./repmat(detT,1,3);
  warning on MATLAB:divideByZero
  difer(chek1(~isnan(chek1))/length(chek1),[],[],NaN)
  % Explicit verification of the inverse by the checking the identity
  chek2=invT(kgoodi,1).*T(kgoodi,1)+invT(kgoodi,2).*T(kgoodi,2)-1;
  difer(chek2(~isnan(chek2)),7,[],NaN)
  chek3=invT(kgoodi,1).*T(kgoodi,2)+invT(kgoodi,2).*T(kgoodi,3);
  difer(chek3(~isnan(chek3)),7,[],NaN)
  chek4=invT(kgoodi,2).*T(kgoodi,2)+invT(kgoodi,3).*T(kgoodi,3)-1;
  difer(chek4(~isnan(chek4)),7,[],NaN)
  % Check the Cholesky by multiplication
  difer(L(:,1).*L(:,1)-T(:,1),8,[],NaN)
  difer(L(:,1).*L(:,2)-T(:,2),8,[],NaN)
  difer(L(:,2).*L(:,2)+L(:,3).*L(:,3)-T(:,3),8,[],NaN)
  % Check the Cholesky by factorization at a random wave number
  randi=ceil(rand*length(T)); 
  Trand=[T(randi,1) T(randi,2) ; T(randi,2) T(randi,3)];
  Lrand=[L(randi,1)    0       ; L(randi,2) L(randi,3)];
  try
    difer(chol(Trand)'-Lrand,[],1,NaN);
  catch
    % This may have a small imaginary part
    difer(imag(Trand),[],[],NaN)
    try 
      % But it should be positive definite if f2 is also positive  
      difer(chol(real(Trand))'-Lrand,[],[],NaN);
    catch
      % If not, let it go but make a note of it
      disp('Cholesky not happy')
    end
  end
end
