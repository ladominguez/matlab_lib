function create_request(file)
% create_request.m
%
% This function reads a text file in cmt format. It creates
% two files. 
%   (1) request.stp which can be used as an input that
%       to request data for an stp server (Ex. MASEstp).
%   (2) movefiles.sh. It's a scrip to move the data after being
%       request to individual files.
%
% See. create_subdir.m, set_params.m
%
% By Luis Dominguez, Nov 2008.

fin=fopen(file);
fout1=fopen('request.stp','w');
fout2=fopen('move_files.sh','w');
% Year 9-12
% Month 15-16
% Day 18-19
% Time 21-26
Cmp='HH_';
Sta='%';
Dur='+30m';

while 1
    l=fgetl(fin);
    if ~ischar(l),    break,  end
    date=[l(9:12) '/' l(15:16) '/' l(18:19) '/' l(21:26)];
    time=[l(21:22) ':' l(23:24) ':' l(25:26)];
    cmd1=['WIN TO ' Sta ' ' Cmp ' ' date ',' time ' ' Dur];
    dir=[l(9:12) l(15:16) l(18:19) l(21:26)];
    cmd2=['mkdir ' dir];
    cmd3=['mv ' dir '*.sac ' dir];
    
    fprintf(fout1,'%s\n',cmd1);
    fprintf(fout2,'%s\n',cmd2);
    fprintf(fout2,'%s\n',cmd3);
end

fclose(fin);
fclose(fout1);
fclose(fout2);