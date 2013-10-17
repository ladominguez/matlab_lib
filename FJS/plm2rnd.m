function varargout=plm2rnd(L,bta,meth,norma)
% [lmcosi,bta,bto,sdl,el]=PLM2RND(L,BTA,mth,norma)
%
% Makes a random field up to degree L with a spectral slope of bta.
% Both methods start from random-normal coefficient distributions.
% 
% INPUT:
%
% L         Maximum degree of the expansion
% bta       Spectral slope (default: geopotential Earth: -4.0361)
% meth      1 Random behavior of approximately bta
%           2 Scaled behavior of exactly bta
% norma     The normalization used in PLM2SPEC (default: 2)
%           1 *(l+1) 
%           2 /(2l+1)
%           3 none
%
% OUTPUT:
%
% lmcosi    Matrix with [l m Ccos Csin] spherical harmonics
% bta       Input beta value, again
% bto       Actual spectral slope of this realization
% sdl       Actual spectrum of this realization
% el        Degrees of the spectrum
%
% SEE ALSO:
%
% RND2PLM
%
% EXAMPLE:
%
% plm2rnd('demo1') % Verifies input and output
% plm2rnd('demo2') % Compares EGM96 to random structures
%
% Last modified by fjsimons-at-alum.mit.edu, 02/21/2010

defval('bta',-4.0361)
defval('L',100)
defval('meth',1)
defval('norma',2)

if ~isstr(L)
  [m,l,mzero]=addmon(L);
  switch meth
   case 1
    disp('Using Gaussian random')
    c=randn(addmup(L),2);
    c(mzero,2)=0; 
    lmcosi=[l m c];
   case 2
    disp('Using uniform random')
    c=2*rand(addmup(L),2)-1;
    c(mzero,2)=0;
    lmcosi=[l m c]; 
   otherwise
    error('Specify valid method')
  end
  
  [sdl,el,bto]=plm2spec(lmcosi,norma);
  % Repeat observed spectrum for all m
  srep=addmin(sdl);
  lmcosi(:,3)=lmcosi(:,3)./sqrt(srep).*l.^(bta/2);
  lmcosi(:,4)=lmcosi(:,4)./sqrt(srep).*l.^(bta/2);
  lmcosi(1,3)=1;
  lmcosi(1,4)=0;
  if nargout>=3
    [sdl,el,bto]=plm2spec(lmcosi,norma);
    disp(sprintf('Best-fitting beta %5.2f',bto))
  end
  varns={lmcosi,bta,bto,sdl,el};
  varargout=varns(1:nargout);
else
  switch L
   case 'demo1'
    L=round(rand*180);
    [lmcosi,bta1]=plm2rnd(L,[]);
    [psd,l,bta2,lfit,logy,logpm]=plm2spec(lmcosi,2);
    disp(sprintf('L= %i ; slope in= %8.3f ; slope out= %8.3f',...
		 L,bta1,bta2))
   case 'demo2'    
    egm=fralmanac('EGM96','SHM');
    ah=krijetem(subnum(3,2));
    axes(ah(1))
    plotplm(egm(4:end,:),[],[],1)
    axes(ah(2))
    dbt=plotplm(egm,[],[],3);

    syn1=plm2rnd(max(egm(:,1)),bta);
    syn2=plm2rnd(max(egm(:,1)),bta);
    
    axes(ah(3))
    plotplm(syn1(7:end,:),[],[],1)
    
    axes(ah(4))
    dbt1=plotplm(syn1(4:end,:),[],[],3);

    axes(ah(5))
    plotplm(syn2(7:end,:),[],[],1)
    axes(ah(6))
    dbt2=plotplm(syn1(4:end,:),[],[],3);
    figdisp([],'demo2')
  end
end
