function Lk=Lkos(k,th,params,Hk,blurs)
% Lk=Lkos(k,th,params,Hk,blurs)
%
% Computes the likelihood function for the isotropic Forsyth model in
% Olhede & Simons
%
% INPUT:
%
% k        Wavenumber(s) at which this is to be evaluated [1/m]
% th       The parameter vector with elements:
%          D   Isotropic flexural rigidity [Nm]
%          f2  The sub-surface to surface initial loading ratio
%          s2  The first Matern parameter, aka sigma^2
%          nu  The second Matern parameter
%          rho The third Matern parameter
% params   A structure with AT LEAST these constants that are known:
%          DEL   surface and subsurface density contrast [kg/m^3]
%          g     gravitational acceleration [m/s^2]
% Hk       A complex matrix of Fourier-domain observations
% blurs    1 Blur using the Fejer window [default]
%          0 Don't blur using the Fejer window
% 
% OUTPUT:
%
% Lk       A one-column vector with the wavenumbers unwrapped
%
% SEE ALSO: 
%
% LOGLIOS
%
% Last modified by fjsimons-at-alum.mit.edu, 01/05/2012

defval('blurs',1)

switch blurs
 case 0
  % That's lots of screen time, FMINUNC evaluates this a lot
  % disp('LKOS without BLURRING')
  % First calculate the Matern spectrum with the spectral parameters
  S11=maternos(k,th(3),th(4),th(5));

  % Extract the needed parameters of the estimation variables
  D=th(1);
  % Extract the needed parameters of the simulation variables
  DEL=params.DEL;
  g=params.g;
  
  % First the auxiliary quantities
  phi=phios(k,D,DEL,g);
  xi =xios(k,D,DEL,g);
  % Note that this has a zero at zero wavenumber
  pxm=(phi.*xi-1);

  % Then calculate then T matrices with the lithospheric parameters, and yes
  % we know Tinv will have an Inf and detT a 0 at k=0, but HFORMOS will
  % turn the Inf into a NaN and log(0)+NaN remains NaN, ...
  [invT,detT]=Tos(k,th,params,phi,xi,pxm);
  
  % Then put it all together... and all we have to worry about is a NaN in
  % Lk which we take care of in LOGLIOS. Note that Lk should be real. 
  warning off MATLAB:log:logOfZero
  Lk=-2*log(S11)-log(detT)-hformos(S11,invT,Hk);
  warning on MATLAB:log:logOfZero

  % Should make sure that this is real! Don't take any chances
  Lk=realize(Lk);
 case 1
  % That's lots of screen time, FMINUNC evaluates this a lot
  % disp('LKOS with BLURRING')
  % Extract the needed parameters of the simulation variables
  NyNx=params.NyNx;
  dydx=params.dydx;
  % Note that with refi=1 we should get the unblurred version
  refi=2;
  k2=knum2(refi*NyNx,[(refi*NyNx(1)-1)*dydx(1) (refi*NyNx(2)-1)*dydx(2)]);
  
  % Now make the spectral-spectral portion of the spectral matrix
  S11=maternos(k2,th(3),th(4),th(5));
  % The lithospheric-spectral matrix on this second grid
  [~,~,~,T]=Tos(k2,th,params); 
  % Which we multiply by the spectral-spectral portion
  S=[S11.*T(:,1) S11.*T(:,2) S11.*T(:,3)];
    
  % Which we need to convolve now in two dimensions
  % And then do subsampling onto the original target grid
  Sb=bluros(S,NyNx,refi);
  
  % Now we need the determinant of the blurred S and its inverse
  detS=[Sb(:,1).*Sb(:,3)-Sb(:,2).^2];
  % If refi=1 then [detS-detT.*S11.^2] should be tiny
  % plot(detS,detT.*S11.^2,'+'); axis image; grid on
  % If refi=1 then [invS(:,1)-invT(:,1)./S11] etc should be tiny
  % plot(invS(:,1),invT(:,1)./S11,'+'); axis image; grid on
  invS=[Sb(:,3) -Sb(:,2) Sb(:,1)]./repmat(detS,1,3);
  % Trouble is at the central wave numbers, we should take those out
  
  % Then put it all together...
  warning off MATLAB:log:logOfZero
  Lk=-log(detS)-hformos(1,invS,Hk);
  warning on MATLAB:log:logOfZero
  
  % Should make sure that this is real! Don't take any chances
  Lk=realize(Lk);
  
  % Fix the center portion to the NaN it should be, see KNUM2
  kzero=sub2ind(NyNx,floor(NyNx(1)/2)+1,floor(NyNx(2)/2)+1);
  difer(k(kzero),[],[],NaN)
  % Behavior is rather different if this is NOT done... knowing that it
  % will not blow up but rather be some numerically large value
  Lk(kzero)=NaN;
  
  % If refi=1 then
  % plot(Lk,-2*log(S11)-log(detT)-hformos(S11,invT,Hk),'+')
  % And this is true but only within limits, replace a NaN in there
end

% Let's take a look at the blurred and the unblurred versions, even at
% refi=1 and at the effect of taking the NaN with us at kzero or not


