function create_subdir(file)
% create_subdir(file)
%
% Reads the file in format CMT line by line. It
% creates a subdirectory for every event in the file.
% Ex.
% PDE    2007  06 08 150838.05  13.64  -90.80  38  5.5 MwGCMT  3FM .......
%
% This line will create the subdirectory
%   mkdir 20070608150838
%
%  By Luis Dominguez, Nov 2008.

fid=fopen(file);
% Year 9-12
% Month 15-16
% Day 18-19
% Time 21-26

while 1
    l=fgetl(fid);
    if ~ischar(l),    break,  end
    name=[l(9:12) l(15:16) l(18:19) l(21:26)];
    eval(['mkdir ' name]);    
end
