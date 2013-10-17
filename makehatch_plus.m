function A = makehatch_plus(hatch,n)
%MAKEHATCH_PLUS Predefined hatch patterns
%
% Modification of MAKEHATCH to allow for selection of matrix size. Useful whe using 
%   APPLYHATCH_PLUS with higher resolution output.
%
% input (optional) N    size of hatch matrix (default = 6)
%
%  MAKEHATCH_PLUS(HATCH,N) returns a matrix with the hatch pattern for HATCH
%   according to the following table:
%      HATCH        pattern
%     -------      ---------
%        /          right-slanted lines
%        \          left-slanted lines
%        |          vertical lines
%        -          horizontal lines
%        +          crossing vertical and horizontal lines
%        x          criss-crossing lines
%        .          single dots
%
%  See also: APPLYHATCH_PLUS

%  By Ben Hinkle, bhinkle@mathworks.com
%  This code is in the public domain. 

% Modified Brian FG Katz    8-aout-03

if nargin == 1, n = 6; end
n=round(n);

A=zeros(n);
switch (hatch)
 case '/'
  A = fliplr(eye(n));
 case '\'
  A = eye(n);
 case '|'
  A(:,1) = 1;
 case '-'
  A(1,:) = 1;
 case '+'
  A(:,1) = 1;
  A(1,:) = 1;
 case 'x'
  A = eye(n) | fliplr(diag(ones(n-1,1),-1));
 case '.'
  A(1:2,1:2)=1;
 otherwise
  error(['Undefined hatch pattern "' hatch '".']);
end