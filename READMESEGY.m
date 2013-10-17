Function Synopsis
[D,H] = readsegy(filename,hw,min,max)

--------------------------------------------------------------------------------

Help text
READSEGY: Read SEGY data

   Reads data D and trace header from  SEGY file. 
   The data and headers are extracted  in 
   a range given by hw (header words).
   
   [D,H] = readsegy(filename,hw,mi,max) returns the data D and

   IN   filename: name of segy
        hw: header word to limit number of traces to read
        min, max: min and maximum value of hw

   OUT  D: the data (in a matrix) 
        H: the header in a structure

   example:    [D,H] = readsegy('data','cdp',500,550) will provide
               the traces and associated headers for traces with the 
               header word cdp goes from 500 to 550.

   example:    [D,H] = readsegy('data','offset',250,510) like the above
               example but now the header word 'offset' is used to
               read traces with offsets in the range 250-500mts.

   example:    [D,H] = readsegy('data') reads everything until end
               of file.
 
   example:    suppose you want to read and extract the offset of
               each trace:
               [D,H]=readsegy('data');
               my_offsets = [D.offset];


  M.D.Sacchi, July 1997, Dept. of Physics, UofA.
        
  sacchi@phys.ualberta.ca

  Modified, Ago 2001, raplace .mat structures by functions


--------------------------------------------------------------------------------

Cross-Reference Information
This function calls 

count_struct   ./SEGY/count_struct.m
header         ./SEGY/header.m
segy_struct    ./SEGY/segy_struct.m


--------------------------------------------------------------------------------

Listing of function ./SEGY/readsegy.m