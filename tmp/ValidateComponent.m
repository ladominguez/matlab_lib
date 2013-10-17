function [files N]=ValidateComponent(Component,subdir)
% New Update - 11/07/2009
% This function will not longer have 3 output arguments. Now, the
% subdirectory will be the second input argument. If not 2nd argument it
% assumes that you are looking for files in the current directory.
%
% New Input and Output Forms,
% [files subdir N]=ValidateComponent(Component,subdir)
% [files subdir N]=ValidateComponent(Component)
% [files N]=ValidateComponent(Component,subdir)
% 
% Default Options:
%   Component = 'Z'
%   subdir = '.'

if nargin<=1
    subdir='';
end

if exist('Component','var')
    Component=upper(Component);
end

if nargin==0 | strcmp(Component,'Z' )
	FullName=fullfile(pwd,subdir,'*Z.sac');
    files=dir(FullName);
    Component='Z';
elseif strcmp(Component,'E')
	FullName=fullfile(pwd,subdir,'*HE.sac');
        files=dir(FullName);
elseif strcmp(Component,'N')
	FullName=fullfile(pwd,subdir,'*HN.sac');
        files=dir(FullName);
elseif strcmp(Component,'R' )
	FullName=fullfile(pwd,subdir,'*R.sac');
        files=dir(FullName);
elseif strcmp(Component,'T')
	FullName=fullfile(pwd,subdir,'*T.sac');
        files=dir(FullName);          
elseif strcmp(Component,'DCR')
    FullName=fullfile(pwd,subdir,'*DCR.sac');
        files=dir(FullName);
elseif strcmp(Component,'DCT')
    FullName=fullfile(pwd,subdir,'*DCT.sac');
        files=dir(FullName);                      
elseif strcmp(Component,'CRR')
    FullName=fullfile(pwd,subdir,'*CRR.sac');
        files=dir(FullName);
elseif strcmp(Component,'CRT')
    FullName=fullfile(pwd,subdir,'*CRT.sac');
        files=dir(FullName);        
elseif strcmp(upper(Component),'ALL')
    FullName=fullfile(pwd,subdir,'*.sac');
        files=dir(FullName);   
else
    FullName=fullfile(pwd,subdir,['*.' Component '.sac']);
        files=dir(FullName);
end



if (isempty(files))
    disp(['Not SAC files found in ' subdir]);
    N=0;
else
    N=length(files);
end
    

% if nargout == 2 && nargin == 2
%     subdir=N;
% end
